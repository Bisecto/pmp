import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/add_occupant/add_occupant.dart';
import 'package:pim/view/mobile_view/dashboard/property_details/tabview_container/space/add_space/add_space_tab.dart';
import 'package:pim/view/mobile_view/dashboard/tenant_section/pdf_view.dart';

import 'package:pim/view/mobile_view/landing_page.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:pim/view/widgets/app_custom_text.dart';
import 'package:pim/view/widgets/form_button.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../../../model/space_model.dart';
import '../../../../../../res/apis.dart';
import '../../../../../../res/app_colors.dart';
import '../../../../../../utills/app_utils.dart';
import '../../../../res/app_images.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';

class TenantSpaceDetail extends StatefulWidget {
  final UserModel userModel;
  final int index;

  const TenantSpaceDetail({
    super.key,
    required this.userModel,
    required this.index,
  });

  @override
  State<TenantSpaceDetail> createState() => _TenantSpaceDetailState();
}

class _TenantSpaceDetailState extends State<TenantSpaceDetail> {
  PropertyBloc spaceBloc = PropertyBloc();
  List<String> images = [];

  @override
  void initState() {
    // TODO: implement initState
    _preloadImages();
    // spaceBloc.add(GetSingleSpaceEvent(
    //     widget.userModel.occupiedSpaces[widget.index].propertySpaceDetails!.id
    //         .toString(),
    //     widget.userModel.occupiedSpaces[widget.index].propertyDetails!.id
    //         .toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    images = widget.userModel.occupiedSpaces[widget.index].propertySpaceDetails!
        .propertySpaceImages;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAppBar(
                    title: widget
                        .userModel.occupiedSpaces[widget.index].spaceNumber),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Space Details",
                      size: 16,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                lodgeContainer(context: context),
                const SizedBox(
                  height: 15,
                ),
                TextStyles.textDetails(
                    textValue:
                        "Occupant: ${widget.userModel.occupiedSpaces[widget.index].fullName}",
                    textSize: 12,
                    textColor: AppColors.black),
                const SizedBox(
                  height: 15,
                ),
                TextStyles.textDetails(
                    textValue:
                        "Space Type: ${widget.userModel.occupiedSpaces[widget.index].spaceType}",
                    textSize: 12,
                    textColor: AppColors.black),
                const SizedBox(
                  height: 15,
                ),
                TextStyles.textHeadings(
                  textValue:
                      "NGN ${AppUtils.convertPrice(widget.userModel.occupiedSpaces[widget.index].rentPaid)}",
                  textSize: 12,
                ),
                const SizedBox(
                  height: 10,
                ),
                FormButton(
                  onPressed: () async {

                    final pdfData =
                    await generatePdf();
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat
                        format) async =>
                        pdfData,
                        dynamicLayout: false,
                        name:
                        "${widget.userModel.firstName}OCCUPANT_INFO");
                  },
                  text: "Download",
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
  late Uint8List logoImage;
  late Uint8List companyImage;
  late Uint8List studentImageBytes;
  late Uint8List qrCodeImageBytes;
  Future<void> _preloadImages() async {
    try {
      logoImage = await _loadAssetImage(AppImages.logo);
      companyImage = await _loadAssetImage(AppImages.companyLogo);

      studentImageBytes = await _fetchOrDefaultImage(
        widget.userModel.occupiedSpaces[widget.index].profilePic,
        AppImages.person,
      );

      qrCodeImageBytes = await _fetchOrDefaultImage(
        AppApis.appBaseUrl + widget.userModel.occupiedSpaces[widget.index].qrCodeImage,
        AppImages.defaultQrCode,
      );
      setState(() {
        isImageLoaded = true;
      });
    } catch (e) {
      AppUtils().debuglog("Error preloading images: $e");
    }
  }
  bool isImageLoaded = false;

  Future<Uint8List> _fetchOrDefaultImage(
      String url, String defaultAssetPath) async {
    try {
      AppUtils().debuglog('Fetching image from: $url');
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        AppUtils().debuglog('Image fetched successfully from: $url');
        return response.bodyBytes;
      } else {
        AppUtils().debuglog(
            'Failed to fetch image. Status: ${response.statusCode}, URL: $url');
      }
    } catch (e) {
      AppUtils().debuglog('Error fetching image from $url: $e');
    }
    return _loadAssetImage(defaultAssetPath);
  }

  // Helper functions for image loading
  Future<Uint8List> _loadAssetImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildHeader(logoImage),
                    pw.SizedBox(height: 10),
                    _buildTitle('Generated Occupant Details'),
                    pw.SizedBox(height: 10),
                    _buildOccupantBio(studentImageBytes),
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    _buildOccupantInfo(),
                    pw.SizedBox(height: 10),
                    if (widget.userModel.occupiedSpaces[widget.index].occupationStatus.toLowerCase() ==
                        'employed')
                      _buildEmploymentDetails(),
                    if (widget.userModel.occupiedSpaces[widget.index].occupationStatus.toLowerCase() ==
                        'student')
                      _buildStudentDetails(),
                    if (widget.userModel.occupiedSpaces[widget.index].occupationStatus.toLowerCase() ==
                        'self-employed')
                      _buildSelfEmployedDetails(),
                    pw.SizedBox(height: 10),
                    _buildOccupantDetails(),
                    pw.SizedBox(height: 10),
                    _buildRentDetails(),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Image(
                      pw.MemoryImage(
                        qrCodeImageBytes,
                      ),
                      width: 70,
                    ),
                    pw.Text("Scan to get information about the property owner"),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("Powered by"),
                        pw.Image(pw.MemoryImage(companyImage),
                            width: 100, height: 100),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildEmploymentDetails() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Employment Information'),
          pw.SizedBox(height: 5),
          _buildPaymentTable([
            [
              'Organization',
              widget.userModel.occupiedSpaces[widget.index].employedProfile?.organisation ?? 'N/A'
            ],
            ['Position', widget.userModel.occupiedSpaces[widget.index].employedProfile?.position ?? 'N/A'],
            [
              'Employer Contact',
              widget.userModel.occupiedSpaces[widget.index].employedProfile?.employerContact ?? 'N/A'
            ],
            [
              'Organization Location',
              widget.userModel.occupiedSpaces[widget.index].employedProfile?.organisationLocation ?? 'N/A'
            ],
          ]),
        ],
      ),
    );
  }

  pw.Widget _buildStudentDetails() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Student Information'),
          pw.SizedBox(height: 5),
          _buildPaymentTable([
            ['University', widget.userModel.occupiedSpaces[widget.index].studentProfile?.university ?? 'N/A'],
            ['Student ID', widget.userModel.occupiedSpaces[widget.index].studentProfile?.studentId ?? 'N/A'],
            ['Faculty', widget.userModel.occupiedSpaces[widget.index].studentProfile?.faculty ?? 'N/A'],
            ['Department', widget.userModel.occupiedSpaces[widget.index].studentProfile?.department ?? 'N/A'],
          ]),
        ],
      ),
    );
  }

  pw.Widget _buildSelfEmployedDetails() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Self-Employed Information'),
          pw.SizedBox(height: 5),
          _buildPaymentTable([
            [
              'Nature of Job',
              widget.userModel.occupiedSpaces[widget.index].selfEmployedProfile?.natureOfJob ?? 'N/A'
            ],
            [
              'Job Description',
              widget.userModel.occupiedSpaces[widget.index].selfEmployedProfile?.jobDescription ?? 'N/A'
            ],
          ]),
        ],
      ),
    );
  }

  pw.Widget _buildHeader(logoImage) {
    return pw.Container(
      //padding: pw.EdgeInsets.all(16),
      // padding: pw.EdgeInsets.all(16),
      //color: PdfColors.redAccent,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(pw.MemoryImage(logoImage), width: 70),
          pw.Text(widget.userModel.occupiedSpaces[widget.index].spaceType.toUpperCase(),
              style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black)),
          pw.SizedBox()
        ],
      ),
    );
  }

  pw.Widget _buildTitle(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
          fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
    );
  }

  pw.Widget _buildOccupantBio(Uint8List studentImage) {
    return pw.Row(
      children: [
        pw.Image(pw.MemoryImage(studentImage),
            width: 100, height: 100, fit: pw.BoxFit.cover),
        pw.SizedBox(width: 5),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Full Name', widget.userModel.occupiedSpaces[widget.index].fullName),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildOccupantInfo() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('PROPERTY INFORMATION'),
          pw.SizedBox(height: 10),
          _buildAcademicTable([
            ['Property Name', widget.userModel.occupiedSpaces[widget.index].propertyDetails!.propertyName],
            ['Property Address', widget.userModel.occupiedSpaces[widget.index].propertyDetails!.address],
            ['Property Type', widget.userModel.occupiedSpaces[widget.index].propertyDetails!.propertyType],
            ['City', widget.userModel.occupiedSpaces[widget.index].propertyDetails!.city],
            ['Location', widget.userModel.occupiedSpaces[widget.index].propertyDetails!.location],
          ]),
        ],
      ),
    );
  }

  pw.Widget _buildOccupantDetails() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Occupant INFORMATION'),
          pw.SizedBox(height: 10),
          _buildPaymentTable([
            ['MOBILE NUMBER', widget.userModel.occupiedSpaces[widget.index].mobilePhone],
            ['STATE', widget.userModel.occupiedSpaces[widget.index].state],
            ['LGA', widget.userModel.occupiedSpaces[widget.index].localGovernment],
            ['DOB', widget.userModel.occupiedSpaces[widget.index].dob],
            ['MARITAL STATUS', widget.userModel.occupiedSpaces[widget.index].relationship],
            ['OCCUPATION', widget.userModel.occupiedSpaces[widget.index].occupationStatus],
            ['GENDER', widget.userModel.occupiedSpaces[widget.index].gender],
          ]),
        ],
      ),
    );
  }

  pw.Widget _buildRentDetails() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('RENT INFORMATION'),
          pw.SizedBox(height: 10),
          _buildPaymentTable([
            ['RENT PAID', widget.userModel.occupiedSpaces[widget.index].rentPaid.toString()],
            ['RENT DUE', widget.userModel.occupiedSpaces[widget.index].rentExpirationDate],
            ['ROOM', widget.userModel.occupiedSpaces[widget.index].spaceNumber.toString()],
            ['MARITAL STATUS', widget.userModel.occupiedSpaces[widget.index].relationship],
          ]),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text('$title: ',
              style: _infoTextStyle.copyWith(fontWeight: pw.FontWeight.bold)),
          pw.Expanded(child: pw.Text(value, style: _infoTextStyle)),
        ],
      ),
    );
  }

  pw.Widget _buildAcademicTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.redAccent),
          children: rows.map((row) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(row[0],
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                      fontSize: 10)),
            );
          }).toList(),
        ),
        pw.TableRow(
          children: rows.map((row) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(row[1], style: const pw.TextStyle(fontSize: 8)),
            );
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildPaymentTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey, width: 0.5),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.redAccent),
          children: rows.map((row) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(row[0],
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white)),
            );
          }).toList(),
        ),
        pw.TableRow(
          children: rows.map((row) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(row[1].replaceAll('₦', 'NGN'),
                  style: const pw.TextStyle(fontSize: 8)),
            );
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
          fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
    );
  }

  pw.TextStyle get _infoTextStyle =>
      const pw.TextStyle(fontSize: 12, color: PdfColors.black);


  int imageNum = 0;

  PageController _controller = PageController();

  _onPageChanged(int index) {
    setState(() {
      imageNum = index;
    });
  }

  void nextPage() {
    _controller.animateToPage(_controller.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

    setState(() {
      if (imageNum == images.length - 1) {
      } else {
        imageNum = imageNum + 1;
      }
    });
  }

  void previousPage() {
    _controller.animateToPage(_controller.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

    setState(() {
      if (imageNum == 0) {
      } else {
        imageNum = imageNum - 1;
      }
    });
  }

  // Set active = {};
  //
  // void _handleTap(index) {
  //   setState(() {
  //     active.contains(index) ? active.remove(index) : active.add(index);
  //   });
  // }

  Widget lodgeContainer({required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: widget.userModel.occupiedSpaces[widget.index]
                .propertySpaceDetails!.propertySpaceImages.isEmpty
            ? 50
            : 270,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: AppColors.white,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.userModel.occupiedSpaces[widget.index]
                  .propertySpaceDetails!.propertySpaceImages.isEmpty)
                TextStyles.textDetails(
                    textValue:
                        "No image has been added to this space yet. \nClick the edit icon to added required details",
                    textColor: AppColors.black),
              if (widget.userModel.occupiedSpaces[widget.index]
                  .propertySpaceDetails!.propertySpaceImages.isNotEmpty)
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: images.length,
                        controller: _controller,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(images[index]),
                                    ),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.2,
                      left: 25,
                      child: GestureDetector(
                        onTap: () {
                          previousPage();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.2,
                      right: 25,
                      child: GestureDetector(
                        onTap: () {
                          nextPage();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        //width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: SizedBox(
                            width: 78,
                            child: Material(
                              type: MaterialType.card,
                              color: Colors.black38,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_enhance,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    CustomText(
                                      maxLines: 1,
                                      text: imageNum == 0
                                          ? '1/${images.length}'
                                          : '${imageNum + 1}/${images.length}',
                                      color: Colors.orange,
                                      size: 14,
                                      weight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                    final data =widget.userModel.toJson();// jsonDecode(widget.userModel.toString());
                    final pdfBytes = await _generatePdf(PdfPageFormat.a4, data);

                    // Trigger file sharing (or save)
                    await Printing.sharePdf(
                      bytes: pdfBytes,
                      filename: 'tenant_report.pdf',
                    );
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
  Future<Uint8List> _generatePdf(PdfPageFormat format, Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final occupied = data['occupied_spaces'][0];

    final profileImage = await _networkImage(occupied['profile_pic']);
    final qrImage = await _networkImage(occupied['qr_code_image']);
    final propertyImages = await Future.wait(
      (occupied['property_details']['property_images'] as List<dynamic>)
          .map((url) => _networkImage(url))
          .toList(),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              "Tenant Report",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (profileImage != null)
                pw.Container(width: 100, height: 100, child: pw.Image(profileImage)),
              pw.SizedBox(width: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Name: ${occupied['full_name']}"),
                  pw.Text("Title: ${occupied['title']}"),
                  pw.Text("Gender: ${occupied['gender']}"),
                  pw.Text("Phone: ${occupied['mobile_phone']}"),
                  pw.Text("Email: ${occupied['email']}"),
                  pw.Text("Occupation: ${occupied['occupation_status']}"),
                  pw.Text("Relationship: ${occupied['relationship']}"),
                ],
              ),
              pw.Spacer(),
              if (qrImage != null)
                pw.Container(width: 100, height: 100, child: pw.Image(qrImage)),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text("Rent Details", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Bullet(text: "Timeline: ${occupied['rent_timeline']}"),
          pw.Bullet(text: "Start: ${occupied['rent_commencement_date']}"),
          pw.Bullet(text: "End: ${occupied['rent_expiration_date']}"),
          pw.Bullet(text: "Paid: ₦${occupied['rent_paid']}"),
          pw.Bullet(text: "Status: ${occupied['payment_status']}"),
          pw.Bullet(text: "Mesh Bill Paid: ₦${occupied['mesh_bill_paid']}"),
          pw.Bullet(text: "Due In: ${occupied['rent_due_deadline_countdown']}"),
          pw.SizedBox(height: 20),
          pw.Text("Property Details", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Bullet(text: "Name: ${occupied['property_details']['property_name']}"),
          pw.Bullet(text: "Type: ${occupied['property_details']['property_type']}"),
          pw.Bullet(text: "Address: ${occupied['property_details']['address']}"),
          pw.Bullet(text: "City: ${occupied['property_details']['city']}"),
          pw.Bullet(text: "Location: ${occupied['property_details']['location']}"),
          pw.Bullet(text: "Description: ${occupied['property_details']['description']}"),
          pw.Bullet(text: "Total Spaces: ${occupied['property_details']['total_space']}"),
          pw.Bullet(text: "Occupied Spaces: ${occupied['property_details']['occupied_space']}"),
          pw.SizedBox(height: 20),
          if (propertyImages.isNotEmpty)
            pw.Text("Property Images", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.Wrap(
            spacing: 10,
            runSpacing: 10,
            children: propertyImages
                .where((img) => img != null)
                .map((img) => pw.Container(width: 150, child: pw.Image(img!)))
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  Future<pw.ImageProvider?> _networkImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return pw.MemoryImage(response.bodyBytes);
      }
    } catch (_) {}
    return null;
  }
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

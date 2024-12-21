import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/res/app_colors.dart';
import 'package:pim/view/widgets/form_button.dart';
import 'package:printing/printing.dart';
import '../../../../model/property_model.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_svg_images.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_utils.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_custom_text.dart';
import '../../add_occupant/add_occupant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'generate_occupant_pdf.dart';

class ViewOccupant extends StatefulWidget {
  final Occupant occupant;
  final Property property;
  final UserModel userModel;

  const ViewOccupant(
      {super.key,
      required this.occupant,
      required this.property,
      required this.userModel});

  @override
  State<ViewOccupant> createState() => _ViewOccupantState();
}

class _ViewOccupantState extends State<ViewOccupant> {
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    final ByteData logoBytes = await rootBundle.load(AppImages.logo);
    final Uint8List logoImage = logoBytes.buffer.asUint8List();
    final ByteData companyLogoBytes =
        await rootBundle.load(AppImages.companyLogo);
    final Uint8List companyImage = companyLogoBytes.buffer.asUint8List();
    // Load student image
    final http.Response response =
        await http.get(Uri.parse(widget.occupant.profilePic));

    ///studentImage);
    ///response.statusCode);
    Uint8List studentImageBytes;
    if (response.statusCode == 200 || response.statusCode == 201) {
      studentImageBytes = response.bodyBytes;
      pdf.addPage(
        pw.Page(
          //pageFormat: Pd,
          build: (pw.Context context) {
            return pw.Container(
                //padding: pw.EdgeInsets.all(32),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildHeader(logoImage),
                      //pw.Divider(),
                      pw.SizedBox(height: 10),
                      _buildTitle('Generated Occupant details'),
                      pw.SizedBox(height: 10),
                      _buildOccupantBio(
                        studentImageBytes,
                      ),
                      pw.Divider(),

                      pw.SizedBox(height: 10),
                      _buildOccupantInfo(),
                      pw.SizedBox(height: 10),
                      _buildOccupantDetails(),
                      pw.SizedBox(height: 10),
                      _buildRentDetails(),
                      pw.SizedBox(height: 10),
                      //_buildFooter('Thank you for your payment.'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                          ""),
                      pw.Row(
                        children: [
                          pw.Text("Powered by"),
                          pw.Image(
                              pw.MemoryImage(
                                companyImage,
                              ),
                              width: 100,
                              height: 100),
                        ],
                      ),
                    ],
                  ),
                ]));
          },
        ),
      );
    } else {
      final ByteData studentBytes = await rootBundle.load(AppImages.person);
      studentImageBytes = studentBytes.buffer.asUint8List();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Container(
                //padding: pw.EdgeInsets.all(32),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildHeader(logoImage),
                      //pw.Divider(),
                      pw.SizedBox(height: 10),
                      _buildTitle('Generated Occupant details'),
                      pw.SizedBox(height: 10),
                      _buildOccupantBio(
                        studentImageBytes,
                      ),
                      pw.Divider(),

                      pw.SizedBox(height: 10),
                      _buildOccupantInfo(),
                      pw.SizedBox(height: 10),
                      _buildOccupantDetails(),
                      pw.SizedBox(height: 10),
                      _buildRentDetails(),
                      pw.SizedBox(height: 10),
                      //_buildFooter('Thank you for your payment.'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("© ${DateTime.now().year} Applead"),
                      pw.Row(
                        children: [
                          pw.Text("Powered by"),
                          pw.Image(pw.MemoryImage(companyImage),
                              width: 100, height: 100),
                        ],
                      ),
                    ],
                  ),
                ]));
          },
        ),
      );
    }

    return pdf.save();
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
          pw.Text(widget.property.propertyName.toUpperCase(),
              style:
                  pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold,color: PdfColors.black)),
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
              _buildInfoRow('Full Name', widget.occupant.name),
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
            ['Property Name', widget.property.propertyName],
            ['Property Address', widget.property.address],
            ['Property Type', widget.property.propertyType],
            ['City', widget.property.city],
            ['Location', widget.property.location],
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
            ['MOBILE NUMBER', widget.occupant.mobileNumber],
            ['STATE', widget.occupant.state],
            ['LGA', widget.occupant.localGovernment],
            ['DOB', widget.occupant.dob],
            ['MARITAL STATUS', widget.occupant.relationship],
            ['OCCUPATION', widget.occupant.occupationStatus],
            ['GENDER', widget.occupant.gender],
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
            ['RENT PAID', widget.occupant.rentPaid],
            ['RENT DUE', widget.occupant.rentDueDate],
            ['ROOM NUMBER', widget.occupant.roomNumber.toString()],
            ['MARITAL STATUS', widget.occupant.relationship],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppAppBar(title: widget.occupant.name!),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Occupant Details",
                      size: 18,
                      weight: FontWeight.w700,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              AppNavigator.pushAndStackPage(context,
                                  page: AddOccupantScreen(
                                    userModel: widget.userModel,
                                    property: widget.property,
                                    isEdit: true,
                                    occupant: widget.occupant,
                                  ));
                            },
                            child: SvgPicture.asset(AppSvgImages.edit)),
                        //const Icon(Icons.edit),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(AppSvgImages.delete),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                FormButton(
                  onPressed: () async {
                    final pdfData = await generatePdf();
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async => pdfData,
                        dynamicLayout: false,
                        name:
                        "${widget.occupant.name}OCCUPANT_INFO");
                  },
                  text: "Download",
                  isIcon: true,
                  borderRadius: 10,
                  bgColor: AppColors.blue,
                  iconWidget: Icons.download,
                ),
                const SizedBox(
                  height: 15,
                ),
                profileContainer(widget.occupant, context: context),
                const SizedBox(
                  height: 15,
                ),
                moreDetailsContainer(widget.occupant, context: context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileContainer(Occupant occupant, {required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 350,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 250,
                width: AppUtils.deviceScreenSize(context).width,
                decoration: BoxDecoration(
                  //color: AppColors.red,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.15),
                  //     spreadRadius: 0,
                  //     blurRadius: 10,
                  //     offset: const Offset(0, 4),
                  //   ),
                  // ],
                  image: DecorationImage(
                      image: NetworkImage(
                        occupant.profilePic,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: occupant.name,
                    color: AppColors.black,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  const CustomText(
                    text: '✅ Active  ',
                    size: 14,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        text: "Marital status:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${occupant.relationship}  ',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CustomText(
                        text: "Employment Status:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${occupant.occupationStatus}',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget moreDetailsContainer(Occupant occupant, {required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        text: "Room Number:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${occupant.roomNumber}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CustomText(
                        text: "Rent Due Date:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${AppUtils.formateSimpleDate(dateTime: occupant.rentDueDate.toString())}.',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        text: "DOB:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text:
                            ' ${AppUtils.formateSimpleDate(dateTime: occupant.dob.toString())}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CustomText(
                        text: "Gender:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${occupant.gender}',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        text: "LGA:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${occupant.localGovernment}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const CustomText(
                        text: "State:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${occupant.state}',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

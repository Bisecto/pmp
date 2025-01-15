import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/add_occupant/add_occupant.dart';
import 'package:pim/view/widgets/app_custom_text.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../../../bloc/property_bloc/property_bloc.dart';
import '../../../../../../model/property_model.dart';
import '../../../../../../res/apis.dart';
import '../../../../../../res/app_colors.dart';
import '../../../../../../res/app_images.dart';
import '../../../../../widgets/app_custom_text.dart';
import 'occupant_list.dart';

class OccupantContainer extends StatefulWidget {
  final Property property;
  final UserModel userModel;
  final PropertyBloc propertyBloc;

  const OccupantContainer(
      {super.key,
      required this.property,
      required this.userModel,
      required this.propertyBloc});

  @override
  State<OccupantContainer> createState() => _OccupantContainerState();
}

class _OccupantContainerState extends State<OccupantContainer> {
  @override
  void initState() {
    super.initState();
    loadResources();
  }

  late Uint8List logoImage;
  late Uint8List companyImage;
  late Uint8List studentImageBytes;

  Future<void> loadResources() async {
    try {
      await prepareImage();
    } catch (e) {
      // Handle error gracefully
      print("Error loading resources: $e");
    }
  }

  Future<void> prepareImage() async {
    try {
      final logoBytes = await rootBundle.load(AppImages.logo);
      logoImage = logoBytes.buffer.asUint8List();

      final companyLogoBytes = await rootBundle.load(AppImages.companyLogo);
      companyImage = companyLogoBytes.buffer.asUint8List();

      final http.Response response = await http.get(
        Uri.parse(AppApis.appBaseUrl + widget.property.firstImage),
      );

      if (response.statusCode == 200) {
        studentImageBytes = response.bodyBytes;
      } else {
        throw Exception("Failed to load student image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error preparing images: $e");
      rethrow; // Propagate the error to the caller
    }
  }

  Future<Uint8List> generatePdf(Property prop) async {
    final pdf = pw.Document();

    print("Starting PDF generation...");
    final tableHeaders = [
      'Name',
      'State',
      'Room No.',
      'Rent Paid',
      'Rent Due Date',
      'Employment Status'
    ];

    // Verify resources
    if (logoImage == null || companyImage == null) {
      print("Missing required images for PDF generation");
      return Uint8List(0);
    }

    // Check occupants data
    if (prop.occupants.isEmpty) {
      print("No occupants data available in the property model");
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(logoImage, prop),
                pw.SizedBox(height: 10),
                _buildTitle('Generated Property details'),
                pw.SizedBox(height: 10),
                _buildPropertyInfo(studentImageBytes, prop),
                pw.Divider(),
                // Table Header
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  color: PdfColors.blueGrey,
                  child: pw.Row(
                    children: tableHeaders
                        .map((header) => pw.Expanded(
                              child: pw.Text(
                                header,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                                textAlign: pw.TextAlign.center,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                // Table Rows
                ...prop.occupants.map((occupant) {
                  return pw.Column(children: [
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Text(occupant.fullName,
                              style: const pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.start),
                        ),
                        pw.Expanded(
                          child: pw.Text(occupant.state,
                              style: const pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Expanded(
                          child: pw.Text('${occupant.roomNumber}',
                              style: const pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Expanded(
                          child: pw.Text(occupant.rentPaid.toString(),
                              style: const pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Expanded(
                          child: pw.Text(occupant.rentExpirationDate,
                              style: const pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Expanded(
                          child: pw.Text(occupant.occupationStatus,
                              style: const pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.center),
                        ),
                      ],
                    ),
                    pw.Divider(),
                  ]);
                }).toList(),
                pw.SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );

    print("PDF generation complete.");
    return pdf.save();
  }

  pw.Widget _buildHeader(logoImage, Property prop) {
    return pw.Container(
      //padding: pw.EdgeInsets.all(16),
      // padding: pw.EdgeInsets.all(16),
      //color: PdfColors.redAccent,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(pw.MemoryImage(logoImage), width: 70),
          pw.Text(prop.propertyName.toUpperCase(),
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

  pw.Widget _buildPropertyInfo(Uint8List studentImage, Property prop) {
    return pw.Row(
      children: [
        pw.Image(pw.MemoryImage(studentImage),
            width: 100, height: 100, fit: pw.BoxFit.cover),
        pw.SizedBox(width: 5),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Property Name', prop.propertyName),
              _buildInfoRow('Property Type', prop.propertyType),
              _buildInfoRow('Property Address', prop.address),
              _buildInfoRow('Property State', prop.location),
              _buildInfoRow(
                  'Total Flats',
                  (prop.occupiedFlatsRooms + prop.availableFlatsRooms)
                      .toString()),
              _buildInfoRow(
                  'Available Flats', prop.availableFlatsRooms.toString()),
              _buildInfoRow(
                  'Occupied Flats', prop.occupiedFlatsRooms.toString()),
            ],
          ),
        ),
      ],
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

  pw.TextStyle get _infoTextStyle =>
      const pw.TextStyle(fontSize: 12, color: PdfColors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Occupants",
                size: 15,
                weight: FontWeight.w600,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () async {
                        print(1);
                        final pdfData = await generatePdf(widget.property);
                        if (pdfData.isEmpty) {
                          print("Generated PDF data is empty!");
                          return;
                        }

                        // Save PDF locally
                        final directory = await getTemporaryDirectory();
                        final filePath =
                            '${directory.path}/GeneratedProperty.pdf';
                        final file = File(filePath);
                        await file.writeAsBytes(pdfData);
                        print("PDF saved to: $filePath");

                        await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async {
                            print("Generating PDF layout...");
                            final data = pdfData;
                            print(
                                "PDF layout generated. Size: ${data.length} bytes");
                            return data;
                          },
                          dynamicLayout: false,
                          name: "${widget.property.propertyName}_PROPERTY_INFO",
                        );

                        // await Printing.layoutPdf(
                        //     onLayout: (PdfPageFormat
                        //             format) async =>
                        //         pdfData,
                        //     dynamicLayout: false,
                        //     name:
                        //         "${widget.property.propertyName}PROPERTY_INFO");
                        print(1);
                      },
                      child: SvgPicture.asset(
                        AppSvgImages.download,
                        height: 30,
                        width: 30,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigator.pushAndStackPage(context,
                          page: AddOccupantScreen(
                            userModel: widget.userModel,
                            property: widget.property,
                            isEdit: false,
                            occupant: null, spaces:widget.property.spaces,
                          ));
                    },
                    child: Container(
                      height: 45,
                      // width:
                      //     AppUtils.deviceScreenSize(context)
                      //             .width /
                      //         3,
                      decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "  Add occupant  ",
                            color: AppColors.white,
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.property.occupants.isEmpty)
            const CustomText(
              text: "No tenant has been added yet",
            ),
          if (widget.property.occupants.isNotEmpty)
            OccupantList(
              occupants: widget.property.occupants,
              property: widget.property,
              userModel: widget.userModel,
              propertyBloc: widget.propertyBloc,
            )
        ],
      ),
    );
  }
}

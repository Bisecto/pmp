import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/app_svg_images.dart';
import 'package:pim/utills/app_navigator.dart';
import 'package:pim/view/mobile_view/add_occupant/add_occupant.dart';
import 'package:pim/view/mobile_view/add_property/add_property_tab.dart';
import 'package:pim/view/mobile_view/landing_page.dart';
import 'package:pim/view/widgets/app_bar.dart';
import 'package:pim/view/widgets/app_custom_text.dart';
import 'package:pim/view/widgets/form_button.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../model/property_model.dart';
import '../../../../res/apis.dart';
import '../../../../res/app_colors.dart';
import '../../../../res/app_images.dart';
import '../../../../utills/app_utils.dart';
import '../../../important_pages/dialog_box.dart';
import '../../../important_pages/not_found_page.dart';
import 'occupant_list.dart';

class PropertyDetails extends StatefulWidget {
  final Property property;
  final UserModel userModel;

  const PropertyDetails(
      {super.key, required this.property, required this.userModel});

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  PropertyBloc propertyBloc = PropertyBloc();

  @override
  void initState() {
    // TODO: implement initState
    propertyBloc.add(GetSinglePropertyEvent(widget.property.id.toString()));
    super.initState();
  }

  Future<Uint8List> generatePdf(Property prop) async {
    final pdf = pw.Document();
    final ByteData logoBytes = await rootBundle.load(AppImages.logo);
    final Uint8List logoImage = logoBytes.buffer.asUint8List();
    final ByteData companyLogoBytes =
        await rootBundle.load(AppImages.companyLogo);
    final Uint8List companyImage = companyLogoBytes.buffer.asUint8List();
    // Load student image
    final http.Response response =
        await http.get(Uri.parse(AppApis.appBaseUrl+prop.firstImage));
    final tableHeaders = [
      'Name',
      'State',
      'Room No.',
      'Rent Paid',
      'Rent Due Date',
      'Employment Status'
    ];

    ///studentImage);
    ///response.statusCode);
    Uint8List studentImageBytes;
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
                    _buildHeader(logoImage,prop),
                    //pw.Divider(),
                    pw.SizedBox(height: 10),
                    _buildTitle('Generated Property details'),
                    pw.SizedBox(height: 10),
                    _buildPropertyInfo(
                      studentImageBytes,prop
                    ),
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

                    ...prop.occupants.map((occupant) {
                      print(occupant);
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(vertical: 5),
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.grey300),
                          ),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                                child: pw.Text(occupant.name,
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.center)),
                            pw.Expanded(
                                child: pw.Text(occupant.state,
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.center)),
                            pw.Expanded(
                                child: pw.Text('${occupant.roomNumber}',
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.center)),
                            pw.Expanded(
                                child: pw.Text(occupant.rentPaid,
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.center)),
                            pw.Expanded(
                                child: pw.Text(occupant.rentDueDate,
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.center)),
                            pw.Expanded(
                                child: pw.Text(occupant.occupationStatus,
                                    style: const pw.TextStyle(fontSize: 10),
                                    textAlign: pw.TextAlign.center)),
                          ],
                        ),
                      );
                    }).toList(),

                    pw.SizedBox(height: 20),

                    //_buildFooter('Thank you for your payment.'),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(""),
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

    return pdf.save();
  }

  pw.Widget _buildHeader(logoImage,Property prop) {
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

  pw.Widget _buildPropertyInfo(Uint8List studentImage,Property prop) {
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
                  (prop.occupiedFlatsRooms +
                          prop.availableFlatsRooms)
                      .toString()),
              _buildInfoRow('Available Flats',
                  prop.availableFlatsRooms.toString()),
              _buildInfoRow('Occupied Flats',
                  prop.occupiedFlatsRooms.toString()),
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
      body: SafeArea(
          child: BlocConsumer<PropertyBloc, PropertyState>(
              bloc: propertyBloc,
              listenWhen: (previous, current) => current is! PropertyInitial,
              buildWhen: (previous, current) => current is! PropertyInitial,
              listener: (context, state) {
                if (state is SinglePropertySuccessState) {
                  //MSG.snackBar(context, state.msg);

                  // AppNavigator.pushAndRemovePreviousPages(context,
                  //     page: LandingPage(studentProfile: state.studentProfile));
                } else if (state is DeletePropertySuccessState) {
                  MSG.snackBar(context, "Property has beedn deleted");
                  AppNavigator.pushAndRemovePreviousPages(context,
                      page: LandingPage(
                          selectedIndex: 0, userModel: widget.userModel));
                } else if (state is PropertyErrorState) {
                  MSG.warningSnackBar(context, state.error);
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  // case PostsFetchingState:
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                  case SinglePropertySuccessState:
                    final singlePropertySuccessState =
                        state as SinglePropertySuccessState;

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              AppAppBar(
                                  title: singlePropertySuccessState
                                      .property.propertyName),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                    text: "Property Details",
                                    size: 18,
                                    weight: FontWeight.w700,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            AppNavigator.pushAndStackPage(
                                                context,
                                                page: AddPropertyScreen(
                                                  userModel: widget.userModel,
                                                  isEdit: true,
                                                  property:
                                                      singlePropertySuccessState
                                                          .property,
                                                ));
                                          },
                                          child: SvgPicture.asset(
                                              AppSvgImages.edit)),
                                      //const Icon(Icons.edit),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            propertyBloc.add(
                                                DeletePropertyEvent(
                                                    singlePropertySuccessState
                                                        .property.id
                                                        .toString()));
                                          },
                                          child: SvgPicture.asset(
                                              AppSvgImages.delete)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              lodgeContainer(
                                  property: singlePropertySuccessState.property,
                                  context: context),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: "Status",
                                        size: 18,
                                        weight: FontWeight.w600,
                                      ),
                                      Container(
                                        height: 45,
                                        width:
                                            AppUtils.deviceScreenSize(context)
                                                    .width /
                                                2.5,
                                        decoration: BoxDecoration(
                                            color: AppColors.green,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: CustomText(
                                          text: singlePropertySuccessState
                                              .property.status,
                                          color: AppColors.white,
                                          weight: FontWeight.bold,
                                        )),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: "Available rooms",
                                        size: 18,
                                        weight: FontWeight.w600,
                                      ),
                                      Container(
                                        height: 45,
                                        width:
                                            AppUtils.deviceScreenSize(context)
                                                    .width /
                                                2.5,
                                        decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: CustomText(
                                          text:
                                              "${singlePropertySuccessState.property.availableFlatsRooms}",
                                          color: AppColors.black,
                                          weight: FontWeight.bold,
                                        )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const CustomText(
                                    text: "Occupants",
                                    size: 18,
                                    weight: FontWeight.w600,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () async {
                                            final pdfData = await generatePdf(singlePropertySuccessState.property);
                                            await Printing.layoutPdf(
                                                onLayout: (PdfPageFormat
                                                        format) async =>
                                                    pdfData,
                                                dynamicLayout: false,
                                                name:
                                                    "${widget.property.propertyName}PROPERTY_INFO");
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
                                                occupant: null,
                                              ));
                                        },
                                        child: Container(
                                          height: 45,
                                          width:
                                              AppUtils.deviceScreenSize(context)
                                                      .width /
                                                  3,
                                          decoration: BoxDecoration(
                                              color: AppColors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_box,
                                                color: AppColors.white,
                                              ),
                                              CustomText(
                                                text: " Add occupant",
                                                color: AppColors.white,
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
                              if (singlePropertySuccessState
                                  .property.occupants.isEmpty)
                                const CustomText(
                                  text: "No tenant has been added yet",
                                ),
                              if (singlePropertySuccessState
                                  .property.occupants.isNotEmpty)
                                OccupantList(
                                  occupants: singlePropertySuccessState
                                      .property.occupants,
                                  property: singlePropertySuccessState.property,
                                  userModel: widget.userModel,
                                )
                            ],
                          ),
                        ),
                      ),
                    );

                  case PropertyLoadingState:
                    return const Column(
                      children: [
                        AppLoadingPage("Fetching Property..."),
                      ],
                    );
                  default:
                    return const Column(
                      children: [
                        AppLoadingPage("Fetching Property..."),
                      ],
                    );
                }
              })),
    );
  }

  Widget lodgeContainer({required Property property, required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: AppColors.white,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 200,
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
                        AppApis.appBaseUrl + property.firstImage,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.red,
                        ),
                        CustomText(text: 'Dublin,ireland', size: 14),
                      ],
                    ),
                    if (property.propertyType.toLowerCase() == 'static')
                      TextStyles.textHeadings(
                        textValue:
                            "NGN ${AppUtils.convertPrice(property.price)}",
                        textSize: 18,
                      ),
                    //   if(property.propertyType.toLowerCase()=='static')
                    // TextStyles.textHeadings(
                    //   textValue: AppUtils.formatCurrency(1000.0),
                    //   textSize: 18,
                    // ),
                  ],
                ),
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

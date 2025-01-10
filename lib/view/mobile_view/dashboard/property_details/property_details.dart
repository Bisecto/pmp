import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
import 'package:path_provider/path_provider.dart';

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
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    propertyBloc.add(GetSinglePropertyEvent(widget.property.id.toString()));

    //propertyBloc.add(GetSinglePropertyEvent(widget.property.id.toString()));

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
      final ByteData logoBytes = await rootBundle.load(AppImages.logo);
      logoImage = logoBytes.buffer.asUint8List();

      final ByteData companyLogoBytes =
          await rootBundle.load(AppImages.companyLogo);
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

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   prepareImage();
  //   super.initState();
  // }

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
                    images = singlePropertySuccessState.property.imageUrls
                            .map(
                                (imageUrl) => AppApis.appBaseUrl + imageUrl.url)
                            .toList() ??
                        [];
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
                                    size: 16,
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
                                            AppSvgImages.edit,
                                            height: 25,
                                            width: 25,
                                          )),
                                      //const Icon(Icons.edit),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            showDeleteConfirmationModal(context,
                                                () {
                                              propertyBloc.add(
                                                  DeletePropertyEvent(
                                                      singlePropertySuccessState
                                                          .property.id
                                                          .toString()));
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            AppSvgImages.delete,
                                            height: 25,
                                            width: 25,
                                          )),
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
                                        size: 15,
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
                                          size: 15,
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
                                        text: "Total Space",
                                        size: 15,
                                        weight: FontWeight.w600,
                                      ),
                                      Container(
                                        height: 45,
                                        width:
                                            AppUtils.deviceScreenSize(context)
                                                    .width /
                                                2.5,
                                        decoration: BoxDecoration(
                                            color: AppColors.black,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: CustomText(
                                          text:
                                              "${singlePropertySuccessState.property.availableFlatsRooms} Spaces",
                                          size: 15,
                                          color: AppColors.white,
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
                                    size: 15,
                                    weight: FontWeight.w600,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            print(1);
                                            final pdfData = await generatePdf(
                                                singlePropertySuccessState
                                                    .property);
                                            if (pdfData.isEmpty) {
                                              print(
                                                  "Generated PDF data is empty!");
                                              return;
                                            }

                                            // Save PDF locally
                                            final directory =
                                                await getTemporaryDirectory();
                                            final filePath =
                                                '${directory.path}/GeneratedProperty.pdf';
                                            final file = File(filePath);
                                            await file.writeAsBytes(pdfData);
                                            print("PDF saved to: $filePath");

                                            await Printing.layoutPdf(
                                              onLayout:
                                                  (PdfPageFormat format) async {
                                                print(
                                                    "Generating PDF layout...");
                                                final data = pdfData;
                                                print(
                                                    "PDF layout generated. Size: ${data.length} bytes");
                                                return data;
                                              },
                                              dynamicLayout: false,
                                              name:
                                                  "${widget.property.propertyName}_PROPERTY_INFO",
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
                                                occupant: null,
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                  propertyBloc: propertyBloc,
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

  void showDeleteConfirmationModal(
      BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Property'),
          content: const Text(
              'Are you sure you want to delete this property? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the modal
                onConfirm(); // Trigger the confirm action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const CustomText(
                text: 'Delete',
                color: AppColors.white,
              ),
            ),
          ],
        );
      },
    );
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

  Widget lodgeContainer({required Property property, required context}) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 270,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: AppColors.white,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (property.imageUrls.isNotEmpty)
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
              if (property.imageUrls.isNotEmpty) const SizedBox(height: 20),
              // GestureDetector(
              //   onTap: () => Get.to(() => FullGalleryScreen(
              //     index: 1,
              //     images: images,
              //   )),
              //   child: const Center(
              //     child: CustomText(
              //         color: Colors.black54,
              //         text: 'Tap to view in fullScreen',
              //         weight: FontWeight.w700,
              //         size: 13),
              //   ),
              // ),
              if (property.imageUrls.isEmpty)
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
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.red,
                        ),
                        CustomText(
                            text: "${property.city}, ${property.location}",
                            size: 14),
                      ],
                    ),
                    if (property.priceType.toLowerCase() == 'static')
                      TextStyles.textHeadings(
                        textValue:
                            "NGN ${AppUtils.convertPrice(property.price)}",
                        textSize: 12,
                      ),
                    if (property.priceType.toLowerCase() != 'static')
                      TextStyles.textHeadings(
                        textValue:
                            "NGN ${AppUtils.convertPrice(property.priceRangeStart.toString())} - ${AppUtils.convertPrice(property.priceRangeStop.toString())}",
                        textSize: 12,
                      ),
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

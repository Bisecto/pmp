import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/res/app_colors.dart';
import 'package:pim/view/important_pages/dialog_box.dart';
import 'package:pim/view/widgets/form_button.dart';
import 'package:printing/printing.dart';
import '../../../../bloc/property_bloc/property_bloc.dart';
import '../../../../model/property_model.dart';
import '../../../../res/app_images.dart';
import '../../../../res/app_svg_images.dart';
import '../../../../utills/app_navigator.dart';
import '../../../../utills/app_utils.dart';
import '../../../../utills/shared_preferences.dart';
import '../../../important_pages/not_found_page.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/app_custom_text.dart';
import '../../add_occupant/add_occupant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'generate_occupant_pdf.dart';

class ViewOccupant extends StatefulWidget {
  Occupant occupant;
  final String occpuantId;
  final Property property;
  final UserModel userModel;

  ViewOccupant(
      {super.key,
      required this.occupant,
      required this.property,
      required this.userModel,
      required this.occpuantId});

  @override
  State<ViewOccupant> createState() => _ViewOccupantState();
}

class _ViewOccupantState extends State<ViewOccupant> {
  PropertyBloc occupantBloc = PropertyBloc();
  late Uint8List logoImage;
  late Uint8List companyImage;
  late Uint8List studentImageBytes;
  late Uint8List qrCodeImageBytes;

  Future<Uint8List> _fetchOrDefaultImage(
      String url, String defaultAssetPath) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.bodyBytes;
      }
    } catch (e) {
      print("Error fetching image from $url: $e");
    }
    return _loadAssetImage(defaultAssetPath);
  }

  // Helper functions for image loading
  Future<Uint8List> _loadAssetImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    occupantBloc.add(GetSingleOccupantEvent(widget.occupant.id.toString()));
    super.initState();
    _preloadImages();
  }

  Future<void> _preloadImages() async {
    try {
      // Load logo and company images
      logoImage = await _loadAssetImage(AppImages.logo);
      companyImage = await _loadAssetImage(AppImages.companyLogo);

      // Fetch student image
      studentImageBytes = await _fetchOrDefaultImage(
        widget.occupant.profilePic,
        AppImages.person,
      );

      // Fetch QR code image
      qrCodeImageBytes = await _fetchOrDefaultImage(
        AppApis.appBaseUrl + widget.occupant.qrCodeImage,
        AppImages.defaultQrCode,
      );
    } catch (e) {
      // Handle any errors during preloading
      print("Error preloading images: $e");
    }
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
                    if (widget.occupant.occupationStatus.toLowerCase() ==
                        'employed')
                      _buildEmploymentDetails(),
                    if (widget.occupant.occupationStatus.toLowerCase() ==
                        'student')
                      _buildStudentDetails(),
                    if (widget.occupant.occupationStatus.toLowerCase() ==
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
                    pw.Image(pw.MemoryImage(qrCodeImageBytes), width: 70),
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
              widget.occupant.employedProfile?.organisation ?? 'N/A'
            ],
            ['Position', widget.occupant.employedProfile?.position ?? 'N/A'],
            [
              'Employer Contact',
              widget.occupant.employedProfile?.employerContact ?? 'N/A'
            ],
            [
              'Organization Location',
              widget.occupant.employedProfile?.organisationLocation ?? 'N/A'
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
            ['University', widget.occupant.studentProfile?.university ?? 'N/A'],
            ['Student ID', widget.occupant.studentProfile?.studentId ?? 'N/A'],
            ['Faculty', widget.occupant.studentProfile?.faculty ?? 'N/A'],
            ['Department', widget.occupant.studentProfile?.department ?? 'N/A'],
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
              widget.occupant.selfEmployedProfile?.natureOfJob ?? 'N/A'
            ],
            [
              'Job Description',
              widget.occupant.selfEmployedProfile?.jobDescription ?? 'N/A'
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
          pw.Text(widget.property.propertyName.toUpperCase(),
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
              _buildInfoRow('Full Name', widget.occupant.fullName),
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
            ['MOBILE NUMBER', widget.occupant.mobilePhone],
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
            ['RENT PAID', widget.occupant.rentPaid.toString()],
            ['RENT DUE', widget.occupant.rentExpirationDate],
            ['ROOM', widget.occupant.spaceNumber.toString()],
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

  Future<void> deleteOccupant({
    required String accessToken,
    required String occupantId,
    required String apiUrl,
    required VoidCallback onSuccess,
    required Function(String error) onError,
  }) async {
    final String url = '$apiUrl$occupantId/';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      print(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 204) {
        onSuccess(); // Notify that the delete is complete
      } else {
        final errorDetail =
            json.decode(response.body)['detail'] ?? 'Unknown error';
        onError(errorDetail); // Notify about the error
      }
    } catch (e) {
      onError('An error occurred while deleting the occupant: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: BlocConsumer<PropertyBloc, PropertyState>(
              bloc: occupantBloc,
              listenWhen: (previous, current) => current is! PropertyInitial,
              buildWhen: (previous, current) => current is! PropertyInitial,
              listener: (context, state) {
                if (state is SingleOccupantSuccessState) {
                  //MSG.snackBar(context, state.msg);

                  // AppNavigator.pushAndRemovePreviousPages(context,
                  //     page: LandingPage(studentProfile: state.studentProfile));
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
                  case SingleOccupantSuccessState:
                    final singleOccupantSuccessState =
                        state as SingleOccupantSuccessState;
                    widget.occupant = singleOccupantSuccessState.occupant;
                    // images = singlePropertySuccessState.property.imageUrls
                    //     .map(
                    //         (imageUrl) => AppApis.appBaseUrl + imageUrl.url)
                    //     .toList() ??
                    //     [];
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AppAppBar(title: widget.occupant.fullName!),
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
                                                spaces: widget.property.spaces,
                                              ));
                                        },
                                        child: SvgPicture.asset(
                                          AppSvgImages.edit,
                                          height: 25,
                                          width: 25,
                                        )),
                                    //const Icon(Icons.edit),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          String accessToken =
                                              await SharedPref.getString(
                                                  'access-token');
                                          showDeleteConfirmationModal(context,
                                              () {
                                            deleteOccupant(
                                              accessToken: accessToken,
                                              occupantId: widget.occpuantId,
                                              apiUrl: AppApis.singleOccupantApi,
                                              onSuccess: () {
                                                MSG.snackBar(context,
                                                    'Occupant deleted successfully!');

                                                Navigator.pop(context, true);
                                              },
                                              onError: (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Error: $error')),
                                                );
                                              },
                                            );
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
                            FormButton(
                              onPressed: () async {
                                final pdfData = await generatePdf();
                                await Printing.layoutPdf(
                                    onLayout: (PdfPageFormat format) async =>
                                        pdfData,
                                    dynamicLayout: false,
                                    name:
                                        "${widget.occupant.fullName}OCCUPANT_INFO");
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
                            moreDetailsContainer(widget.occupant,
                                context: context)
                          ],
                        ),
                      ),
                    );

                  case PropertyLoadingState:
                    return const Column(
                      children: [
                        AppLoadingPage("Fetching Occupant..."),
                      ],
                    );
                  default:
                    return const Column(
                      children: [
                        AppLoadingPage("Fetching Occupant..."),
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
          title: const Text('Delete Occupant'),
          content: const Text(
              'Are you sure you want to delete this occupant? This action cannot be undone.'),
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
                    text: occupant.fullName,
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
        height: 220,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        text: ' ${occupant.spaceNumber}  ',
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
                        text:
                            '  ${AppUtils.formatComplexDate(dateTime: occupant.rentExpirationDate.toString())}.',
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
              SizedBox(
                height: 20,
              ),
              if (occupant.occupationStatus.toLowerCase() == 'employed')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Employment Information:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const CustomText(
                          text: "Organization:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: AppUtils.deviceScreenSize(context).width / 2,
                          child: CustomText(
                            text:
                                ' ${occupant.employedProfile!.organisation}  ',
                            size: 14,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: "Position:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: '  ${occupant.employedProfile!.position}',
                          size: 14,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: "Employer Contact:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text:
                              ' ${occupant.employedProfile!.employerContact}  ',
                          size: 14,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: "Organization Location:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: AppUtils.deviceScreenSize(context).width / 2,
                          child: CustomText(
                            text:
                                '  ${occupant.employedProfile!.organisationLocation}',
                            size: 14,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              // Display Student Information if Occupant is a Student
              if (occupant.occupationStatus.toLowerCase() == 'student')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Information:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const CustomText(
                          text: "University:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: '  ${occupant.studentProfile!.university}',
                          size: 14,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: "Student ID:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: '  ${occupant.studentProfile!.studentId}',
                          size: 14,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: "faculty:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: '  ${occupant.studentProfile!.faculty}',
                          size: 14,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const CustomText(
                          text: "Department:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: '  ${occupant.studentProfile!.department}',
                          size: 14,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              // Display Self-Employed Information if Occupant is Self-Employed
              if (occupant.occupationStatus.toLowerCase() == 'self-employed')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Self-Employed Information:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const CustomText(
                          text: "Nature of Job:",
                          color: AppColors.black,
                          size: 14,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(
                          width: AppUtils.deviceScreenSize(context).width / 2,
                          child: CustomText(
                            text:
                                '  ${occupant.selfEmployedProfile!.natureOfJob}',
                            size: 14,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: const CustomText(
                            text: "Job Description:",
                            color: AppColors.black,
                            size: 14,
                            weight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: AppUtils.deviceScreenSize(context).width / 2,
                          child: CustomText(
                            text:
                                '  ${occupant.selfEmployedProfile!.jobDescription}',
                            size: 14,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

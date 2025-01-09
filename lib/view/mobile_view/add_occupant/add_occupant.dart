import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/view/widgets/drop_down.dart';
import 'package:provider/provider.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_input.dart';
import '../landing_page.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AddOccupantScreen extends StatefulWidget {
  final UserModel userModel;
  final Property property;
  final Occupant? occupant;
  final bool isEdit;

  const AddOccupantScreen(
      {super.key,
      required this.userModel,
      required this.property,
      required this.occupant,
      required this.isEdit});

  @override
  _AddOccupantScreenState createState() => _AddOccupantScreenState();
}

class _AddOccupantScreenState extends State<AddOccupantScreen> {
  int _currentStep = 0;

  // Controllers to capture form input
  final TextEditingController occupantNameController = TextEditingController();
  final TextEditingController occupantEmailController = TextEditingController();
  final TextEditingController occupantPhoneNumberController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController rentCommencementController =
      TextEditingController();

  // final TextEditingController rentExpirationController =
  //     TextEditingController();
  final TextEditingController lgaController = TextEditingController();
  final TextEditingController amtPaidController = TextEditingController();
  final TextEditingController roomNumberController = TextEditingController();
  final TextEditingController cautionFeeController = TextEditingController();

  String selectedGender = '';
  String selectedState = '';
  String selectedEmploymentStatus = '';
  String selectedMaritalStatus = '';
  String selectedPaymnetStatus = '';
  String selectedPaymnetDueTimeline = '';
  String selectedApartmentType = '';
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  PropertyBloc propertyBloc = PropertyBloc();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.isEdit) {
      handleUpdate();
    }
    super.initState();
  }

  void handleUpdate() async {
    //setState(() async {
      cautionFeeController.text = widget.occupant!.meshBillPaid.toString();
      occupantNameController.text = widget.occupant!.fullName;
      occupantEmailController.text = widget.occupant!.email;
      occupantPhoneNumberController.text =
          widget.occupant!.mobilePhone.replaceAll('+234', '');
      dobController.text = widget.occupant!.dob;
      rentCommencementController.text = widget.occupant!.rentCommencementDate;
      // rentExpirationController.text = widget.occupant!.rentDueDate;
      lgaController.text = widget.occupant!.localGovernment;
      amtPaidController.text = widget.occupant!.rentPaid.toString();
      roomNumberController.text = widget.occupant!.roomNumber.toString();
      selectedGender = widget.occupant!.gender;
      selectedState = widget.occupant!.state;
      selectedEmploymentStatus = widget.occupant!.occupationStatus;
      selectedMaritalStatus = widget.occupant!.relationship;
      selectedPaymnetDueTimeline = widget.occupant!.rentTimeline.capitalize();
      selectedPaymnetStatus = widget.occupant!.paymentStatus.capitalize();

      selectedApartmentType = widget.occupant!.apartmentType.capitalize();
      print(widget.occupant!.profilePic);
      // for (String imageUrl in widget.occupant!) {
      try {
        File imageFile = await downloadImage(widget.occupant!.profilePic);
        setState(() {
          imageFileList!.add(XFile(imageFile.path));
          // _selectedImage=XFile(imageFile.path);
        });
      } catch (e) {
        print('Error downloading image: $e');
      }
      // }
   // });
  }

  Future<File> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/${imageUrl.split('/').last}';
      final file = File(filePath);
      return file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to download image');
    }
  }

  void _showPickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? selectedImage =
          await _imagePicker.pickImage(source: source, imageQuality: 50);
      if (selectedImage != null) {
        setState(() {
          _selectedImage = selectedImage;
          imageFileList!.clear();
          imageFileList!.add(selectedImage);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomText(
              text: widget.isEdit ? 'Edit Occupant' : 'Add Occupant'),
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer<PropertyBloc, PropertyState>(
            bloc: propertyBloc,
            listenWhen: (previous, current) => current is! PropertyInitial,
            buildWhen: (previous, current) => current is! PropertyInitial,
            listener: (context, state) {
              if (state is AddPropertySuccessState) {
                MSG.snackBar(context, "Occupant Upload Successful");

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
                case const (PropertySuccessState) || const (PropertyInitial):
                  return Stepper(
                    type: StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepTapped: (int step) {
                      setState(() {
                        _currentStep = step;
                      });
                    },
                    onStepContinue: () {
                      if (_currentStep < 2) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        // Final step: Save property
                        _saveOccupant();
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep -= 1;
                        });
                      }
                    },
                    steps: <Step>[
                      Step(
                        title: const CustomText(
                          text: 'Occupant Details',
                          size: 12,
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _showPickerDialog,
                                child: Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.save_alt_rounded),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: TextStyles.richTexts(
                                          text1: 'Click to select image',
                                          text2: '',
                                          size: 14,
                                          color: Colors.purple,
                                          color2: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16), // Add spacing
                              if (imageFileList!.isNotEmpty)
                                SizedBox(
                                  height: 250, // Fixed height for image display
                                  child: imageFileList?.isEmpty ?? true
                                      ? const Center(
                                          child: Text("No Image Selected"))
                                      : Image.file(
                                          File(imageFileList![0].path),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              const SizedBox(height: 16), // Add spacing
                              CustomTextFormField(
                                controller: occupantNameController,
                                hint: "Enter Occupant's name",
                                label: 'Full Name',
                                borderRadius: 10,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: occupantEmailController,
                                hint: "Enter Occupant's email",
                                label: 'Email',
                                borderRadius: 10,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: occupantPhoneNumberController,
                                hint: '8123457146',
                                label: 'Mobile Phone Number',
                                borderColor: Colors.grey,
                                isMobileNumber: true,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: dobController,
                                hint: 'YYYY-MM-DD',
                                label: 'Date Of Birth',
                                borderColor: Colors.grey,
                                //: Icons.date_range,
                                readOnly: true,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Gender',
                                hint: "Status",
                                initialValue: selectedGender,
                                selectedValue: selectedGender,
                                items: const ['Male', 'Female', 'Others'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Relationship Status Type',
                                hint: "Status",
                                initialValue: selectedMaritalStatus,
                                selectedValue: selectedMaritalStatus,
                                items: const ['Married', 'Single', 'Divorced'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedMaritalStatus = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Employment Status Type',
                                hint: "Status",
                                initialValue: selectedEmploymentStatus,
                                selectedValue: selectedEmploymentStatus,
                                items: const [
                                  'Employed',
                                  'Self-Employed',
                                  'Student'
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedEmploymentStatus = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'State',
                                hint: "Select state",
                                selectedValue: selectedState,
                                initialValue: selectedState,
                                items: const [
                                  "Abia",
                                  "Adamawa",
                                  "Akwa Ibom",
                                  "Anambra",
                                  "Bauchi",
                                  "Bayelsa",
                                  "Benue",
                                  "Borno",
                                  "Cross River",
                                  "Delta",
                                  "Ebonyi",
                                  "Edo",
                                  "Ekiti",
                                  "Enugu",
                                  "FCT - Abuja",
                                  "Gombe",
                                  "Imo",
                                  "Jigawa",
                                  "Kaduna",
                                  "Kano",
                                  "Katsina",
                                  "Kebbi",
                                  "Kogi",
                                  "Kwara",
                                  "Lagos",
                                  "Nasarawa",
                                  "Niger",
                                  "Ogun",
                                  "Ondo",
                                  "Osun",
                                  "Oyo",
                                  "Plateau",
                                  "Rivers",
                                  "Sokoto",
                                  "Taraba",
                                  "Yobe",
                                  "Zamfara"
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedState = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: lgaController,
                                hint: 'Enter LGA',
                                label: 'LGA',
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep == 0
                            ? StepState.editing
                            : StepState.complete,
                      ),
                      Step(
                          title: const CustomText(
                            text: 'Rent Information',
                            size: 12,
                          ),
                          content: Column(
                            children: [
                              DropDown(
                                label: 'Rent Due Timeline',
                                hint: "Select Rent Due Timeline",
                                selectedValue: selectedPaymnetDueTimeline,
                                initialValue: selectedPaymnetDueTimeline,
                                items: const ['Weekly', 'Monthly', "Yearly"],
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymnetDueTimeline = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Rent Payment Status',
                                hint: "Select Rent Payment Status",
                                selectedValue: selectedPaymnetStatus,
                                initialValue: selectedPaymnetStatus,
                                items: const ['Paid', 'Pending'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymnetStatus = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: amtPaidController,
                                hint: 'Enter amount paid',
                                label: 'Amount Paid',
                                textInputType: TextInputType.number,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: rentCommencementController,
                                hint: 'DD/MM/YY',
                                label: 'Rent Commencement Date',
                                borderColor: Colors.grey,
                                //: Icons.date_range,

                                readOnly: true,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Apartment Type',
                                hint: "Select apartment type",
                                selectedValue: selectedApartmentType,
                                initialValue: selectedApartmentType,
                                items: const [
                                  "1 Room Self Contain",
                                  "2 Bedroom Flat",
                                  "3 Bedroom Flat",
                                  "Studio Apartment",
                                  "Office Space",
                                  "Shop Space",
                                  "Warehouse",
                                  "Shared Apartment",
                                  "Penthouse",
                                  "Serviced Apartment",
                                  "Luxury Flat",
                                  "Mini Flat",
                                  "Detached House",
                                  "Semi-Detached House",
                                  "Bungalow",
                                  "Duplex",
                                  "Mansion",
                                  "Condo",
                                  "Townhouse"
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedApartmentType = value;
                                  });
                                },
                              ),
                              // CustomTextFormField(
                              //   controller: apartmentTypeController,
                              //   hint: 'Enter Apartment type',
                              //   label: 'Apartment Type',
                              //   textInputType: TextInputType.text,
                              //   borderColor: Colors.grey,
                              //   backgroundColor: theme.isDark
                              //       ? AppColors.darkCardBackgroundColor
                              //       : AppColors.white,
                              //   hintColor: !theme.isDark
                              //       ? AppColors.darkCardBackgroundColor
                              //       : AppColors.grey,
                              //   borderRadius: 10,
                              // ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: roomNumberController,
                                hint: 'Enter room number',
                                label: 'Room Number',
                                textInputType: TextInputType.number,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: cautionFeeController,
                                hint: '',
                                label: 'Mess/Caution Bill Paid',
                                textInputType: TextInputType.number,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 1,
                          stepStyle: StepStyle(
                              color: _currentStep >= 1
                                  ? AppColors.mainAppColor
                                  : null)),
                      Step(
                          title: const CustomText(
                            text: 'Overview',
                            size: 12,
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              profileContainer(context: context),
                              const SizedBox(
                                height: 15,
                              ),
                              moreDetailsContainer(context: context)
                            ],
                          ),
                          isActive: _currentStep >= 2,
                          stepStyle: StepStyle(
                              color: _currentStep >= 2
                                  ? AppColors.mainAppColor
                                  : null)),
                    ],
                  );

                case const (PropertyLoadingState):
                  return const Column(
                    children: [
                      AppLoadingPage("Uploading Occupant detail..."),
                    ],
                  );
                default:
                  return Stepper(
                    type: StepperType.horizontal,
                    currentStep: _currentStep,
                    onStepTapped: (int step) {
                      setState(() {
                        _currentStep = step;
                      });
                    },
                    onStepContinue: () {
                      if (_currentStep < 2) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        // Final step: Save property
                        _saveOccupant();
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep -= 1;
                        });
                      }
                    },
                    steps: <Step>[
                      Step(
                        title: const CustomText(
                          text: 'Occupant Details',
                          size: 12,
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _showPickerDialog,
                                child: Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.save_alt_rounded),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: TextStyles.richTexts(
                                          text1: 'Click to select image',
                                          text2: '',
                                          size: 14,
                                          color: Colors.purple,
                                          color2: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16), // Add spacing
                              if (imageFileList!.isNotEmpty)
                                SizedBox(
                                  height: 250, // Fixed height for image display
                                  child: imageFileList?.isEmpty ?? true
                                      ? const Center(
                                          child: Text("No Image Selected"))
                                      : Image.file(
                                          File(imageFileList![0].path),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              const SizedBox(height: 16), // Add spacing
                              CustomTextFormField(
                                controller: occupantNameController,
                                hint: "Enter Occupant's name",
                                label: 'Full Name',
                                borderRadius: 10,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: occupantEmailController,
                                hint: "Enter Occupant's email",
                                label: 'Email',
                                borderRadius: 10,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: occupantPhoneNumberController,
                                hint: 'Enter phone number',
                                label: 'Mobile Phone Number',
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: dobController,
                                hint: 'DD/MM/YY',
                                label: 'Date Of Birth',
                                borderColor: Colors.grey,
                                //: Icons.date_range,
                                readOnly: true,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Gender',
                                hint: "Status",
                                selectedValue: selectedGender,
                                initialValue: selectedGender,
                                items: const ['Male', 'Female', 'Others'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Relationship Status Type',
                                hint: "Status",
                                initialValue: selectedMaritalStatus,
                                selectedValue: selectedMaritalStatus,
                                items: const ['Married', 'Single', 'Divorced'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedMaritalStatus = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Employment Status Type',
                                hint: "Status",
                                selectedValue: selectedEmploymentStatus,
                                initialValue: selectedEmploymentStatus,
                                items: const [
                                  'Employed',
                                  'Self-Employed',
                                  'Unemployed'
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedEmploymentStatus = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'State',
                                hint: "Select state",
                                selectedValue: selectedState,
                                initialValue: selectedState,
                                items: const [
                                  "Abia",
                                  "Adamawa",
                                  "Akwa Ibom",
                                  "Anambra",
                                  "Bauchi",
                                  "Bayelsa",
                                  "Benue",
                                  "Borno",
                                  "Cross River",
                                  "Delta",
                                  "Ebonyi",
                                  "Edo",
                                  "Ekiti",
                                  "Enugu",
                                  "FCT - Abuja",
                                  "Gombe",
                                  "Imo",
                                  "Jigawa",
                                  "Kaduna",
                                  "Kano",
                                  "Katsina",
                                  "Kebbi",
                                  "Kogi",
                                  "Kwara",
                                  "Lagos",
                                  "Nasarawa",
                                  "Niger",
                                  "Ogun",
                                  "Ondo",
                                  "Osun",
                                  "Oyo",
                                  "Plateau",
                                  "Rivers",
                                  "Sokoto",
                                  "Taraba",
                                  "Yobe",
                                  "Zamfara"
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedState = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: lgaController,
                                hint: 'Enter LGA',
                                label: 'LGA',
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep == 0
                            ? StepState.editing
                            : StepState.complete,
                      ),
                      Step(
                          title: const CustomText(
                            text: 'Rent Information',
                            size: 12,
                          ),
                          content: Column(
                            children: [
                              DropDown(
                                label: 'Rent Due Timeline',
                                hint: "Select Rent Due Timeline",
                                selectedValue: selectedPaymnetDueTimeline,
                                initialValue: selectedPaymnetDueTimeline,
                                items: const ['Weekly', 'Monthly', "Yearly"],
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymnetDueTimeline = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Rent Payment Status',
                                hint: "Select Rent Payment Status",
                                selectedValue: selectedPaymnetStatus,
                                initialValue: selectedPaymnetStatus,
                                items: const ['Paid', 'Pending'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymnetStatus = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: amtPaidController,
                                hint: 'Enter amount paid',
                                label: 'Amount Paid',
                                textInputType: TextInputType.number,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: rentCommencementController,
                                hint: 'DD/MM/YY',
                                label: 'Rent Commencement Date',
                                borderColor: Colors.grey,
                                //: Icons.date_range,

                                readOnly: true,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              DropDown(
                                label: 'Apartment Type',
                                hint: "Select apartment type",
                                selectedValue: selectedApartmentType,
                                initialValue: selectedApartmentType,
                                items: const [
                                  "1 Room Self Contain",
                                  "2 Bedroom Flat",
                                  "3 Bedroom Flat",
                                  "Studio Apartment",
                                  "Office Space",
                                  "Shop Space",
                                  "Warehouse",
                                  "Shared Apartment",
                                  "Penthouse",
                                  "Serviced Apartment",
                                  "Luxury Flat",
                                  "Mini Flat",
                                  "Detached House",
                                  "Semi-Detached House",
                                  "Bungalow",
                                  "Duplex",
                                  "Mansion",
                                  "Condo",
                                  "Townhouse"
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedApartmentType = value;
                                  });
                                },
                              ),
                              // CustomTextFormField(
                              //   controller: apartmentTypeController,
                              //   hint: 'Enter Apartment type',
                              //   label: 'Apartment Type',
                              //   textInputType: TextInputType.text,
                              //   borderColor: Colors.grey,
                              //   backgroundColor: theme.isDark
                              //       ? AppColors.darkCardBackgroundColor
                              //       : AppColors.white,
                              //   hintColor: !theme.isDark
                              //       ? AppColors.darkCardBackgroundColor
                              //       : AppColors.grey,
                              //   borderRadius: 10,
                              // ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: roomNumberController,
                                hint: 'Enter room number',
                                label: 'Room Number',
                                textInputType: TextInputType.text,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                              const SizedBox(height: 16),
                              CustomTextFormField(
                                controller: cautionFeeController,
                                hint: '',
                                label: 'Mess/Caution Bill Paid',
                                textInputType: TextInputType.text,
                                borderColor: Colors.grey,
                                backgroundColor: theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.white,
                                hintColor: !theme.isDark
                                    ? AppColors.darkCardBackgroundColor
                                    : AppColors.grey,
                                borderRadius: 10,
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 1,
                          stepStyle: StepStyle(
                              color: _currentStep >= 1
                                  ? AppColors.mainAppColor
                                  : null)),
                      Step(
                          title: const CustomText(
                            text: 'Overview',
                            size: 12,
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              profileContainer(context: context),
                              const SizedBox(
                                height: 15,
                              ),
                              moreDetailsContainer(context: context)
                            ],
                          ),
                          isActive: _currentStep >= 2,
                          stepStyle: StepStyle(
                              color: _currentStep >= 2
                                  ? AppColors.mainAppColor
                                  : null)),
                    ],
                  );
              }
            }));
  }

  Widget profileContainer({required context}) {
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
              if (imageFileList!.isNotEmpty)
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
                        image: FileImage(File(imageFileList![0].path)),
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
                    text: occupantNameController.text,
                    color: AppColors.black,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
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
                      CustomText(
                        text: "Marital status:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${selectedMaritalStatus}  ',
                        size: 13,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Employment Status:",
                        color: AppColors.black,
                        size: 13,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${selectedEmploymentStatus}',
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

  Widget moreDetailsContainer({required context}) {
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
                      CustomText(
                        text: "Room Number:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${roomNumberController.text}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     const CustomText(
                  //       text: "Rent Due In:",
                  //       color: AppColors.black,
                  //       size: 14,
                  //       weight: FontWeight.bold,
                  //     ),
                  //     CustomText(
                  //       text: '  ${rentExpirationController.text}',
                  //       size: 14,
                  //       maxLines: 3,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                        text: "DOB:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${dobController.text}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Gender:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${selectedGender}',
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
                      CustomText(
                        text: "LGA:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' ${lgaController.text}  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "State:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  ${selectedState}',
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

  Widget _overviewRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            //style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: CustomText(
              text: value.isNotEmpty ? value : '-',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget lodgeContainer({required String lodge, required context}) {
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
                  image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.crowdspring.com/blog/wp-content/uploads/2017/08/23163415/pexels-binyamin-mellish-106399.jpg",
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
                    TextStyles.textHeadings(
                      textValue: "NGN 200,000",
                      textSize: 18,
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

  void _saveOccupant() {
    if (occupantNameController.text.isEmpty ||
        occupantEmailController.text.isEmpty ||
        occupantPhoneNumberController.text.isEmpty ||
        dobController.text.isEmpty ||
        rentCommencementController.text.isEmpty ||
        lgaController.text.isEmpty ||
        amtPaidController.text.isEmpty ||
        roomNumberController.text.isEmpty ||
        cautionFeeController.text.isEmpty ||
        selectedGender.isEmpty ||
        selectedState.isEmpty ||
        selectedEmploymentStatus.isEmpty ||
        selectedMaritalStatus.isEmpty ||
        selectedPaymnetStatus.isEmpty ||
        selectedPaymnetDueTimeline.isEmpty ||
        selectedApartmentType.isEmpty ||
        imageFileList == null ||
        imageFileList!.isEmpty) {
      MSG.warningSnackBar(context, 'Please fill in all required fields.');
    } else {
      final Map<String, String> formData = {
        'full_name': occupantNameController.text,
        'email': occupantEmailController.text,
        'title': 'mr',
        'dob': dobController.text,
        'mobile_phone': '+234${occupantPhoneNumberController.text}',
        'state': selectedState,
        'local_government': lgaController.text,
        'country': 'Nigeria',
        'room_number': roomNumberController.text,
        'rent_commencement_date': rentCommencementController.text,
        //'rent_expiration_date': rentExpirationController.text,
        'rent_paid': amtPaidController.text,
        'mesh_bill_paid': cautionFeeController.text,
        'relationship': selectedMaritalStatus,
        'occupation_status': selectedEmploymentStatus,
        'rent_timeline': selectedPaymnetDueTimeline.toLowerCase(),
        'apartment_type': selectedApartmentType,
        'payment_status': selectedPaymnetStatus,
        'gender': selectedGender,
      };
      print(formData);
      if (widget.isEdit) {
        propertyBloc.add(UpdateOccupantEvent(formData, imageFileList![0],
            widget.property.id.toString(), widget.occupant!.id.toString()));
      } else {
        propertyBloc.add(AddOccupantEvent(
            formData, imageFileList![0], widget.property.id.toString()));
      }
    }
  }
}
extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
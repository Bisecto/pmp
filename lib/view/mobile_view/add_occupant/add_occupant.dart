import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/view/widgets/drop_down.dart';
import 'package:provider/provider.dart';

import '../../../res/app_colors.dart';
import '../../../res/app_images.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_input.dart';

class AddOccupantScreen extends StatefulWidget {
  @override
  _AddOccupantScreenState createState() => _AddOccupantScreenState();
}

class _AddOccupantScreenState extends State<AddOccupantScreen> {
  int _currentStep = 0;

  // Controllers to capture form input
  final TextEditingController occupantNameController = TextEditingController();
  final TextEditingController occupantPhoneNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController lgaController = TextEditingController();
  final TextEditingController amtPaidController =
  TextEditingController();
  final TextEditingController occupiedRoomsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedGender = '';
  String selectedState = '';
  String selectedEmploymentStatus = '';
  String selectedMaritalStatus = '';
  String selectedPaymnetStatus = '';
  String selectedPaymnetDueTimeline = '';
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectSingleImage() async {
    final XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      imageFileList = [selectedImage]; // Replace the list with the newly selected image
      print("Selected Image Path: ${selectedImage.path}");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomText(text: 'Add Occupant'),
        backgroundColor: Colors.white,
      ),
      body: Stepper(
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
                    onTap: selectSingleImage,
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
                              text1: 'Click to upload',
                              text2: ' or drag and drop',
                              color: Colors.purple,
                              color2: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Add spacing
                  if(imageFileList!=null)
                  SizedBox(
                    height: 250, // Fixed height for image display
                    child: imageFileList?.isEmpty ?? true
                        ? const Center(child: Text("No Image Selected"))
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
                  DropDown(
                    label: 'Relationship Status Type',
                    hint: "Status",
                    selectedValue: selectedMaritalStatus,
                    items: const ['Married', 'Single', 'Others'],
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
                    items: const ['Employed', 'Self Employed', 'Unemployed'],
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
                    items: const ['Abia', 'Anambra', 'Enugu'],
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
                    items: const ['Monthly', 'Quarterly',"Yearly"],
                    onChanged: (value) {
                      setState(() {
                        selectedPaymnetDueTimeline = value;
                      });
                    },
                  ),DropDown(
                    label: 'Rent Payment Status',
                    hint: "Select Rent Payment Status",
                    selectedValue: selectedPaymnetStatus,
                    items: const ['Paid', 'Unpaid'],
                    onChanged: (value) {
                      setState(() {
                        selectedPaymnetStatus = value;
                      });
                    },
                  ),
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
                  // CustomTextFormField(
                  //   controller: availableRoomsController,
                  //   hint: 'Enter number of available rooms',
                  //   label: 'Number of Available Rooms',
                  //   textInputType: TextInputType.number,
                  //   borderColor: Colors.grey,
                  //   borderRadius: 10,
                  //   backgroundColor: theme.isDark
                  //       ? AppColors.darkCardBackgroundColor
                  //       : AppColors.white,
                  //   hintColor: !theme.isDark
                  //       ? AppColors.darkCardBackgroundColor
                  //       : AppColors.grey,
                  // ),
                  // CustomTextFormField(
                  //   controller: occupiedRoomsController,
                  //   hint: 'Enter number of occupied rooms',
                  //   label: 'Number of Occupied Rooms',
                  //   textInputType: TextInputType.number,
                  //   borderColor: Colors.grey,
                  //   borderRadius: 10,
                  //   backgroundColor: theme.isDark
                  //       ? AppColors.darkCardBackgroundColor
                  //       : AppColors.white,
                  //   hintColor: !theme.isDark
                  //       ? AppColors.darkCardBackgroundColor
                  //       : AppColors.grey,
                  // ),
                  // CustomTextFormField(
                  //   controller: descriptionController,
                  //   hint: 'Write about this property',
                  //   label: 'Description',
                  //   maxLines: 3,
                  //   borderColor: Colors.grey,
                  //   borderRadius: 10,
                  //   backgroundColor: theme.isDark
                  //       ? AppColors.darkCardBackgroundColor
                  //       : AppColors.white,
                  //   hintColor: !theme.isDark
                  //       ? AppColors.darkCardBackgroundColor
                  //       : AppColors.grey,
                  // ),
                ],
              ),
              isActive: _currentStep >= 1,
              stepStyle:  StepStyle(color:_currentStep >= 1? AppColors.mainAppColor:null)),
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
              stepStyle:  StepStyle(color:_currentStep >= 2? AppColors.mainAppColor:null)),
        ],
      ),
    );
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
                  image:  const DecorationImage(
                      image: AssetImage(
                        AppImages.occupant,
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Okpara Mark Eze",
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
              const Row(
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
                        text: ' Married  ',
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
                        text: '  Employed',
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
        child: const Center(
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
                        text: ' B12  ',
                        size: 14,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(
                        text: "Rent Due In:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: '  2nd Jan,2025.',
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
                        text: "DOB:",
                        color: AppColors.black,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                      CustomText(
                        text: ' 03-04-1970  ',
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
                        text: '  Male',
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
                        text: ' Aguata  ',
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
                        text: '  Anambra',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText(text: 'Occupant Added'),
        content: const CustomText(
            text: 'Your property has been added successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(text: 'OK'),
          )
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/view/widgets/drop_down.dart';
import 'package:provider/provider.dart';

import '../../../res/app_colors.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_input.dart';

class AddPropertyScreen extends StatefulWidget {
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  int _currentStep = 0;

  // Controllers to capture form input
  final TextEditingController propertyNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController availableRoomsController =
      TextEditingController();
  final TextEditingController occupiedRoomsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedPropertyType = '';
  String selectedState = '';
  String selectedPriceType = 'Static';
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      // Combine the existing and newly selected images
      int totalImages = (imageFileList?.length ?? 0) + selectedImages.length;

      if (totalImages > 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can only select up to 4 images.')),
        );
        // Add only the remaining allowed images to the list
        int remainingSlots = 4 - (imageFileList?.length ?? 0);
        imageFileList!.addAll(selectedImages.take(remainingSlots));
      } else {
        // Add all selected images if within the limit
        imageFileList!.addAll(selectedImages);
      }

      print("Image List Length: ${imageFileList!.length}");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomText(text: 'Add Property'),
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
            _saveProperty();
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
                text: 'Property Details',
                size: 12,
              ),
              content: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: selectImages,
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save_alt_rounded),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: TextStyles.richTexts(
                                    text1: 'Click to upload',
                                    text2: ' or drag and drop',
                                    color: Colors.purple,
                                    color2: AppColors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (imageFileList!.isNotEmpty)
                        SizedBox(
                          height: 100,
                          // Set an appropriate height for the GridView
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: imageFileList!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Image.file(
                                  File(imageFileList![index].path),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      DropDown(
                        label: 'Property Type',
                        hint: "Select Property type",
                        selectedValue: selectedPropertyType,
                        items: const ['Apartment', 'Hotel', 'Lodge'],
                        onChanged: (value) {
                          setState(() {
                            selectedPropertyType = value;
                          });
                        },
                      ),
                      CustomTextFormField(
                        controller: propertyNameController,
                        hint: 'Enter property name',
                        label: 'Property Name',
                        borderRadius: 10,
                        borderColor: Colors.grey,
                        backgroundColor: theme.isDark
                            ? AppColors.darkCardBackgroundColor
                            : AppColors.white,
                        hintColor: !theme.isDark
                            ? AppColors.darkCardBackgroundColor
                            : AppColors.grey,
                      ),
                      CustomTextFormField(
                        controller: addressController,
                        hint: 'Enter address',
                        label: 'Address',
                        borderColor: Colors.grey,
                        backgroundColor: theme.isDark
                            ? AppColors.darkCardBackgroundColor
                            : AppColors.white,
                        hintColor: !theme.isDark
                            ? AppColors.darkCardBackgroundColor
                            : AppColors.grey,
                        borderRadius: 10,
                      ),
                      CustomTextFormField(
                        controller: townController,
                        hint: 'Enter town',
                        label: 'Town',
                        borderColor: Colors.grey,
                        backgroundColor: theme.isDark
                            ? AppColors.darkCardBackgroundColor
                            : AppColors.white,
                        hintColor: !theme.isDark
                            ? AppColors.darkCardBackgroundColor
                            : AppColors.grey,
                        borderRadius: 10,
                      ),
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
                    ],
                  ),
                ),
              ),
              isActive: _currentStep >= 0,
              stepStyle:  StepStyle(color:_currentStep >= 0? AppColors.mainAppColor:null)),
          Step(
              title: const CustomText(
                text: 'Rent Information',
                size: 12,
              ),
              content: Column(
                children: [
                  DropDown(
                    label: 'Price Type',
                    hint: "Select price Type",
                    initialValue: 'Static',
                    selectedValue: selectedPriceType,
                    items: const ['Static', 'Dynamic'],
                    onChanged: (value) {
                      setState(() {
                        selectedPriceType = value;
                      });
                    },
                  ),
                  // Row(
                  //   children: [
                  //     CustomTextFormField(
                  //       controller: priceController,
                  //       hint: 'From',
                  //       label: 'From',
                  //
                  //       textInputType: TextInputType.number,
                  //       borderColor: Colors.grey,
                  //       backgroundColor: theme.isDark
                  //           ? AppColors.darkCardBackgroundColor
                  //           : AppColors.white,
                  //       hintColor: !theme.isDark
                  //           ? AppColors.darkCardBackgroundColor
                  //           : AppColors.grey,
                  //       borderRadius: 10,
                  //     ),
                  //     CustomTextFormField(
                  //       controller: priceController,
                  //       hint: 'Enter price',
                  //       label: 'Price',
                  //       textInputType: TextInputType.number,
                  //       borderColor: Colors.grey,
                  //       backgroundColor: theme.isDark
                  //           ? AppColors.darkCardBackgroundColor
                  //           : AppColors.white,
                  //       hintColor: !theme.isDark
                  //           ? AppColors.darkCardBackgroundColor
                  //           : AppColors.grey,
                  //       borderRadius: 10,
                  //     ),
                  //
                  //   ],
                  // ),
                  if(selectedPriceType.toLowerCase()=='static')
                  CustomTextFormField(
                    controller: priceController,
                    hint: 'Enter price',
                    label: 'Price',
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
                  CustomTextFormField(
                    controller: availableRoomsController,
                    hint: 'Enter number of available rooms',
                    label: 'Number of Available Rooms',
                    textInputType: TextInputType.number,
                    borderColor: Colors.grey,
                    borderRadius: 10,
                    backgroundColor: theme.isDark
                        ? AppColors.darkCardBackgroundColor
                        : AppColors.white,
                    hintColor: !theme.isDark
                        ? AppColors.darkCardBackgroundColor
                        : AppColors.grey,
                  ),
                  CustomTextFormField(
                    controller: occupiedRoomsController,
                    hint: 'Enter number of occupied rooms',
                    label: 'Number of Occupied Rooms',
                    textInputType: TextInputType.number,
                    borderColor: Colors.grey,
                    borderRadius: 10,
                    backgroundColor: theme.isDark
                        ? AppColors.darkCardBackgroundColor
                        : AppColors.white,
                    hintColor: !theme.isDark
                        ? AppColors.darkCardBackgroundColor
                        : AppColors.grey,
                  ),
                  CustomTextFormField(
                    controller: descriptionController,
                    hint: 'Write about this property',
                    label: 'Description',
                    maxLines: 3,
                    borderColor: Colors.grey,
                    borderRadius: 10,
                    backgroundColor: theme.isDark
                        ? AppColors.darkCardBackgroundColor
                        : AppColors.white,
                    hintColor: !theme.isDark
                        ? AppColors.darkCardBackgroundColor
                        : AppColors.grey,
                  ),
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
                  lodgeContainer(lodge: propertyNameController.text, context: context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Status",
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          Container(
                            height: 45,
                            width: AppUtils.deviceScreenSize(context).width / 2.5,
                            decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                                child: CustomText(
                                  text: "Fully Booked",
                                  color: AppColors.white,
                                  weight: FontWeight.bold,
                                )),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            text: "Available rooms",
                            size: 18,
                            weight: FontWeight.w600,
                          ),
                          Container(
                            height: 45,
                            width: AppUtils.deviceScreenSize(context).width / 2.5,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child:  Center(
                                child: CustomText(
                                  text: availableRoomsController.text,
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
                  _overviewRow('Property Type', selectedPropertyType),
                  _overviewRow('Property Name', propertyNameController.text),
                  _overviewRow('Address', addressController.text),
                  _overviewRow('Town', townController.text),
                  _overviewRow('State', selectedState),
                  _overviewRow('Price', priceController.text),
                  _overviewRow(
                      'Available Rooms', availableRoomsController.text),
                  _overviewRow('Occupied Rooms', occupiedRoomsController.text),
                  _overviewRow('Description', descriptionController.text),

                ],
              ),
              isActive: _currentStep >= 2,
              stepStyle:  StepStyle(color:_currentStep >= 2? AppColors.mainAppColor:null)),
        ],
      ),
    );
  }

  // Widget buildGridView() {
  //   return _GridView.count(
  //     crossAxisCount: 3,
  //     children: List.generate(images.length, (index) {
  //       Asset asset = images[index];
  //       return AssetThumb(
  //         asset: asset,
  //         width: 300,
  //         height: 300,
  //       );
  //     }),
  //   );
  // }
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

  void _saveProperty() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const CustomText(text: 'Property Added'),
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

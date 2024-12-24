import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pim/bloc/property_bloc/property_bloc.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/res/apis.dart';
import 'package:pim/view/widgets/drop_down.dart';
import 'package:provider/provider.dart';

import '../../../model/user_model.dart';
import '../../../res/app_colors.dart';
import '../../../utills/app_navigator.dart';
import '../../../utills/app_utils.dart';
import '../../../utills/custom_theme.dart';
import '../../important_pages/dialog_box.dart';
import '../../important_pages/not_found_page.dart';
import '../../widgets/app_custom_text.dart';
import '../../widgets/form_input.dart';
import '../landing_page.dart';

class AddPropertyScreen extends StatefulWidget {
  UserModel userModel;
  bool isEdit;
  Property property;

  AddPropertyScreen(
      {super.key,
      required this.userModel,
      required this.isEdit,
      required this.property});

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
  final TextEditingController fromPriceController = TextEditingController();
  final TextEditingController toPriceController = TextEditingController();
  final TextEditingController availableRoomsController =
      TextEditingController();
  final TextEditingController occupiedRoomsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  PropertyBloc propertyBloc = PropertyBloc();
  final TextEditingController selectedPropertyType =
      TextEditingController(text: '');
  final TextEditingController selectedState = TextEditingController(text: '');
  final TextEditingController selectedPriceType =
      TextEditingController(text: 'Static');
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  //Property? property;
  void handleUpdate() async {
    print('Updating property details...');

    // Update controllers outside setState
    propertyNameController.text = widget.property.propertyName;
    selectedPropertyType.text = widget.property.propertyType;
    selectedState.text = widget.property.location;
    addressController.text = widget.property.address;
    townController.text = widget.property.city;
    selectedPriceType.text = widget.property.priceType;
    priceController.text = widget.property.price?.toString() ?? '';
    fromPriceController.text = widget.property.priceRangeStart?.toString() ?? '';
    toPriceController.text = widget.property.priceRangeStop?.toString() ?? '';
    availableRoomsController.text =
        widget.property.availableFlatsRooms.toString();
    occupiedRoomsController.text =
        widget.property.occupiedFlatsRooms.toString();
    descriptionController.text = widget.property.description;

    print('Image URLs: ${widget.property.imageUrls}');
    List<String> urls = widget.property.imageUrls
        .map((imageUrl) => AppApis.appBaseUrl+imageUrl.url)
        .toList() ??
        [];
    print('Extracted URLs: $urls');

    // Download images
    for (String imageUrl in urls) {
      print('Downloading image from: $imageUrl');
      try {
        File imageFile = await downloadImage(imageUrl);
        setState(() {
          imageFileList ??= []; // Initialize if null
          imageFileList!.add(XFile(imageFile.path));
        });
      } catch (e) {
        print('Error downloading image: $e');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.property.propertyName);
    print(widget.property.propertyType);
    if (widget.isEdit) {
      handleUpdate();
    }
    super.initState();
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      int totalImages = imageFileList!.length + selectedImages.length;

      if (totalImages > 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only select up to 4 images.')),
        );
        int remainingSlots = 4 - imageFileList!.length;

        imageFileList!.addAll(selectedImages
            .take(remainingSlots)
            .map((xFile) => XFile(xFile.path)));
      } else {
        imageFileList!.addAll(selectedImages.map((xFile) => XFile(xFile.path)));
      }

      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomText(
              text: widget.isEdit ? 'Update Property' : 'Add Property'),
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer<PropertyBloc, PropertyState>(
            bloc: propertyBloc,
            listenWhen: (previous, current) => current is! PropertyInitial,
            buildWhen: (previous, current) => current is! PropertyInitial,
            listener: (context, state) {
              if (state is AddPropertySuccessState) {
                setState(() {
                  selectedPropertyType.text = '';
                  selectedState.text = '';
                  selectedPriceType.text = 'Static';
                  imageFileList!.clear();
                  propertyNameController.text = '';
                  addressController.text = '';
                  townController.text = '';
                  priceController.text = '';
                  fromPriceController.text = '';
                  toPriceController.text = '';
                  availableRoomsController.text = '';
                  occupiedRoomsController.text = '';
                  descriptionController.text = '';
                  //PropertyBloc propertyBloc = PropertyBloc();
                });
                MSG.snackBar(context, "Property Upload Successful");

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
                        if (widget.isEdit) {
                          _updateProduct();
                        } else {
                          _saveProperty();
                        }
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
                          content: SizedBox(
                            height: imageFileList!.isNotEmpty ? 850 : 750,
                            //-500,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: selectImages,
                                          child: Container(
                                            height: 250,
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.save_alt_rounded),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Center(
                                                  child: TextStyles.richTexts(
                                                      text1:
                                                          '    Click to select images   ',
                                                      text2:
                                                          '\n(only 4 images are allowed)',
                                                      color: Colors.purple,
                                                      size: 13,
                                                      color2: AppColors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (imageFileList!.isNotEmpty)
                                          SizedBox(
                                            height: 100,
                                            child: GridView.builder(
                                              itemCount: imageFileList!.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Stack(
                                                  children: [
                                                    Image.file(
                                                      File(imageFileList![index]
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        onPressed: () {
                                                          setState(() {
                                                            imageFileList!
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DropDown(
                                          label: 'Property Type',
                                          hint: "Select Property type",
                                          initialValue:
                                              selectedPropertyType.text,
                                          selectedValue:
                                              selectedPropertyType.text,
                                          items: const [
                                            'Student Hostel',
                                            'Apartment/Flat',
                                            'Bungalow',
                                            'Duplex',
                                            'Shop',
                                            'Offices'
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              selectedPropertyType.text = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomTextFormField(
                                          controller: propertyNameController,
                                          hint: 'Enter property name',
                                          label: 'Property Name',
                                          borderRadius: 10,
                                          borderColor: Colors.grey,
                                          backgroundColor: theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.white,
                                          hintColor: !theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.grey,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomTextFormField(
                                          controller: addressController,
                                          hint: 'Enter address',
                                          maxLines: 3,
                                          label: 'Address',
                                          borderColor: Colors.grey,
                                          backgroundColor: theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.white,
                                          hintColor: !theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.grey,
                                          borderRadius: 10,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomTextFormField(
                                          controller: townController,
                                          hint: 'Enter town',
                                          label: 'Town',
                                          borderColor: Colors.grey,
                                          backgroundColor: theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.white,
                                          hintColor: !theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.grey,
                                          borderRadius: 10,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DropDown(
                                          label: 'State',
                                          hint: "Select state",
                                          selectedValue: selectedState.text,
                                          initialValue: selectedState.text,
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
                                              selectedState.text = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isActive: _currentStep >= 0,
                          stepStyle: StepStyle(
                              color: _currentStep >= 0
                                  ? AppColors.mainAppColor
                                  : null)),
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
                                selectedValue: selectedPriceType.text,
                                items: const ['Static', 'Dynamic'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedPriceType.text = value;
                                  });
                                },
                              ),
                              if (selectedPriceType.text.toLowerCase() ==
                                  'dynamic')
                                Row(
                                  children: [
                                    // 'From' Input Field
                                    Expanded(
                                      child: CustomTextFormField(
                                        controller: fromPriceController,
                                        hint: 'From',
                                        label: 'From',
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
                                    ),
                                    const SizedBox(width: 10),
                                    // Add spacing between fields
                                    // 'To' Input Field
                                    Expanded(
                                      child: CustomTextFormField(
                                        controller: toPriceController,
                                        hint: 'To',
                                        label: 'To',
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
                                    ),
                                  ],
                                ),
                              if (selectedPriceType.text.toLowerCase() ==
                                  'static')
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
                              lodgeContainer(
                                  lodge: propertyNameController.text,
                                  context: context),
                              const SizedBox(
                                height: 20,
                              ),
                              _overviewRow(
                                  'Property Type', selectedPropertyType.text),
                              _overviewRow(
                                  'Property Name', propertyNameController.text),
                              _overviewRow('Address', addressController.text),
                              _overviewRow('Town', townController.text),
                              _overviewRow('State', selectedState.text),
                              _overviewRow('Price', priceController.text),
                              _overviewRow('Available Rooms',
                                  availableRoomsController.text),
                              _overviewRow('Occupied Rooms',
                                  occupiedRoomsController.text),
                              _overviewRow(
                                  'Description', descriptionController.text),
                            ],
                          ),
                          isActive: _currentStep >= 2,
                          stepStyle: StepStyle(
                              color: _currentStep >= 2
                                  ? AppColors.mainAppColor
                                  : null)),
                    ],
                  );

                case PropertyLoadingState:
                  return const Column(
                    children: [
                      AppLoadingPage("Uploading property..."),
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
                        if (widget.isEdit) {
                          _updateProduct();
                        } else {
                          _saveProperty();
                        }
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.save_alt_rounded),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: TextStyles.richTexts(
                                                text1:
                                                    '    Click to select images   ',
                                                text2:
                                                    '\n(only 4 images are allowed)',
                                                color: Colors.purple,
                                                size: 13,
                                                color2: AppColors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (imageFileList!.isNotEmpty)
                                    SizedBox(
                                      height: 100,
                                      child: GridView.builder(
                                        itemCount: imageFileList!.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Stack(
                                            children: [
                                              Image.file(
                                                File(
                                                    imageFileList![index].path),
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    setState(() {
                                                      imageFileList!
                                                          .removeAt(index);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DropDown(
                                    label: 'Property Type',
                                    hint: "Select Property type",
                                    initialValue: selectedPropertyType.text,
                                    selectedValue: selectedPropertyType.text,
                                    items: const [
                                      'Student Hostel',
                                      'Apartment/Flat',
                                      'Bungalow',
                                      'Duplex',
                                      'Shop',
                                      'Offices'
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPropertyType.text = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextFormField(
                                    controller: addressController,
                                    hint: 'Enter address',
                                    maxLines: 3,
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
                                  const SizedBox(
                                    height: 10,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DropDown(
                                    label: 'State',
                                    hint: "Select state",
                                    selectedValue: selectedState.text,
                                    initialValue: selectedState.text,
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
                                        selectedState.text = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          isActive: _currentStep >= 0,
                          stepStyle: StepStyle(
                              color: _currentStep >= 0
                                  ? AppColors.mainAppColor
                                  : null)),
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
                                selectedValue: selectedPriceType.text,
                                items: const ['Static', 'Dynamic'],
                                onChanged: (value) {
                                  setState(() {
                                    selectedPriceType.text = value;
                                  });
                                },
                              ),
                              if (selectedPriceType.text.toLowerCase() ==
                                  'dynamic')
                                Row(
                                  children: [
                                    // 'From' Input Field
                                    Expanded(
                                      child: CustomTextFormField(
                                        controller: fromPriceController,
                                        hint: 'From',
                                        label: 'From',
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
                                    ),
                                    const SizedBox(width: 10),
                                    // Add spacing between fields
                                    // 'To' Input Field
                                    Expanded(
                                      child: CustomTextFormField(
                                        controller: toPriceController,
                                        hint: 'To',
                                        label: 'To',
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
                                    ),
                                  ],
                                ),
                              if (selectedPriceType.text.toLowerCase() ==
                                  'static')
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
                              lodgeContainer(
                                  lodge: propertyNameController.text,
                                  context: context),
                              const SizedBox(
                                height: 20,
                              ),
                              _overviewRow(
                                  'Property Type', selectedPropertyType.text),
                              _overviewRow(
                                  'Property Name', propertyNameController.text),
                              _overviewRow('Address', addressController.text),
                              _overviewRow('Town', townController.text),
                              _overviewRow('State', selectedState.text),
                              _overviewRow('Price', priceController.text),
                              _overviewRow('Available Rooms',
                                  availableRoomsController.text),
                              _overviewRow('Occupied Rooms',
                                  occupiedRoomsController.text),
                              _overviewRow(
                                  'Description', descriptionController.text),
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
        height: 120,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: AppColors.white,

          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // if (imageFileList!.isNotEmpty)
              //   Container(
              //     height: 200,
              //     width: AppUtils.deviceScreenSize(context).width,
              //     decoration: BoxDecoration(
              //       //color: AppColors.red,
              //       // boxShadow: [
              //       //   BoxShadow(
              //       //     color: Colors.black.withOpacity(0.15),
              //       //     spreadRadius: 0,
              //       //     blurRadius: 10,
              //       //     offset: const Offset(0, 4),
              //       //   ),
              //       // ],
              //       image: DecorationImage(
              //           image: FileImage(
              //             File(imageFileList![0].path),
              //           ),
              //           fit: BoxFit.cover),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
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
              // const SizedBox(
              //   height: 10,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(0.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       const Row(
              //         children: [
              //           Icon(
              //             Icons.location_on,
              //             color: AppColors.red,
              //           ),
              //           CustomText(text: 'Dublin,ireland', size: 14),
              //         ],
              //       ),
              //       TextStyles.textHeadings(
              //         textValue: "NGN 200,000",
              //         textSize: 18,
              //       ),
              //     ],
              //   ),
              // ),
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
    if (imageFileList!.isNotEmpty) {
      if (selectedPropertyType.text.isNotEmpty) {
        if (propertyNameController.text.isNotEmpty) {
          if (addressController.text.isNotEmpty) {
            if (townController.text.isNotEmpty) {
              if (selectedState.text.isNotEmpty) {
                if (selectedPriceType.text.toLowerCase() == 'static') {
                  if (priceController.text.isNotEmpty) {
                    if (availableRoomsController.text.isNotEmpty) {
                      if (occupiedRoomsController.text.isNotEmpty) {
                        if (descriptionController.text.isNotEmpty) {
                          propertyBloc.add(AddPropertyEvent(
                              propertyNameController.text,
                              selectedPropertyType.text,
                              availableRoomsController.text,
                              addressController.text,
                              townController.text,
                              descriptionController.text,
                              selectedState.text,
                              imageFileList!,
                              selectedPriceType.text,
                              priceController.text,
                              fromPriceController.text,
                              toPriceController.text,
                              occupiedRoomsController.text));
                        } else {
                          MSG.warningSnackBar(
                              context, 'Property description field is empty');
                        }
                      } else {
                        MSG.warningSnackBar(
                            context, 'Occupied room field is empty');
                      }
                    } else {
                      MSG.warningSnackBar(
                          context, 'Available room field is empty');
                    }
                  } else {
                    MSG.warningSnackBar(context, 'Price field is empty');
                  }
                } else {
                  if (fromPriceController.text.isNotEmpty) {
                    if (toPriceController.text.isNotEmpty) {
                      if (availableRoomsController.text.isNotEmpty) {
                        if (occupiedRoomsController.text.isNotEmpty) {
                          if (descriptionController.text.isNotEmpty) {
                            propertyBloc.add(AddPropertyEvent(
                                propertyNameController.text,
                                selectedPropertyType.text,
                                availableRoomsController.text,
                                addressController.text,
                                townController.text,
                                descriptionController.text,
                                selectedState.text,
                                imageFileList!,
                                selectedPriceType.text,
                                priceController.text,
                                fromPriceController.text,
                                toPriceController.text,
                                occupiedRoomsController.text));
                          } else {
                            MSG.warningSnackBar(
                                context, 'Property description field is empty');
                          }
                        } else {
                          MSG.warningSnackBar(
                              context, 'Occupied room field is empty');
                        }
                      } else {
                        MSG.warningSnackBar(
                            context, 'Available room field is empty');
                      }
                    } else {
                      MSG.warningSnackBar(context, 'To price field is empty');
                    }
                  } else {
                    MSG.warningSnackBar(context, 'From price field is empty');
                  }
                }
              } else {
                MSG.warningSnackBar(context, 'Select a valid state');
              }
            } else {
              MSG.warningSnackBar(context, 'Town field field is empty');
            }
          } else {
            MSG.warningSnackBar(context, 'Address field is empty');
          }
        } else {
          MSG.warningSnackBar(context, 'Property Name field is empty');
        }
      } else {
        MSG.warningSnackBar(context, 'Please Select property type');
      }
    } else {
      MSG.warningSnackBar(
          context, 'Property image is needed to complete upload');
    }
  }

  void _updateProduct() {
    if (imageFileList!.isNotEmpty) {
      if (selectedPropertyType.text.isNotEmpty) {
        if (propertyNameController.text.isNotEmpty) {
          if (addressController.text.isNotEmpty) {
            if (townController.text.isNotEmpty) {
              if (selectedState.text.isNotEmpty) {
                if (selectedPriceType.text.toLowerCase() == 'static') {
                  if (priceController.text.isNotEmpty) {
                    if (availableRoomsController.text.isNotEmpty) {
                      if (occupiedRoomsController.text.isNotEmpty) {
                        if (descriptionController.text.isNotEmpty) {
                          propertyBloc.add(UpdatePropertyEvent(
                              propertyNameController.text,
                              selectedPropertyType.text,
                              availableRoomsController.text,
                              addressController.text,
                              townController.text,
                              descriptionController.text,
                              selectedState.text,
                              imageFileList!,
                              selectedPriceType.text,
                              priceController.text,
                              fromPriceController.text,
                              toPriceController.text,
                              occupiedRoomsController.text,
                              widget.property.id.toString()));
                        } else {
                          MSG.warningSnackBar(
                              context, 'Property description field is empty');
                        }
                      } else {
                        MSG.warningSnackBar(
                            context, 'Occupied room field is empty');
                      }
                    } else {
                      MSG.warningSnackBar(
                          context, 'Available room field is empty');
                    }
                  } else {
                    MSG.warningSnackBar(context, 'Price field is empty');
                  }
                } else {
                  if (fromPriceController.text.isNotEmpty) {
                    if (toPriceController.text.isNotEmpty) {
                      if (availableRoomsController.text.isNotEmpty) {
                        if (occupiedRoomsController.text.isNotEmpty) {
                          if (descriptionController.text.isNotEmpty) {
                            propertyBloc.add(UpdatePropertyEvent(
                                propertyNameController.text,
                                selectedPropertyType.text,
                                availableRoomsController.text,
                                addressController.text,
                                townController.text,
                                descriptionController.text,
                                selectedState.text,
                                imageFileList!,
                                selectedPriceType.text,
                                priceController.text,
                                fromPriceController.text,
                                toPriceController.text,
                                occupiedRoomsController.text,
                                widget.property.id.toString()));
                          } else {
                            MSG.warningSnackBar(
                                context, 'Property description field is empty');
                          }
                        } else {
                          MSG.warningSnackBar(
                              context, 'Occupied room field is empty');
                        }
                      } else {
                        MSG.warningSnackBar(
                            context, 'Available room field is empty');
                      }
                    } else {
                      MSG.warningSnackBar(context, 'To price field is empty');
                    }
                  } else {
                    MSG.warningSnackBar(context, 'From price field is empty');
                  }
                }
              } else {
                MSG.warningSnackBar(context, 'Select a valid state');
              }
            } else {
              MSG.warningSnackBar(context, 'Town field field is empty');
            }
          } else {
            MSG.warningSnackBar(context, 'Address field is empty');
          }
        } else {
          MSG.warningSnackBar(context, 'Property Name field is empty');
        }
      } else {
        MSG.warningSnackBar(context, 'Please Select property type');
      }
    } else {
      MSG.warningSnackBar(
          context, 'Property image is needed to complete upload');
    }
  }
}

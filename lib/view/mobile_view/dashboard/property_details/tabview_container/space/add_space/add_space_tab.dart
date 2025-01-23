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

import '../../../../../../../model/space_model.dart';
import '../../../../../../../model/user_model.dart';
import '../../../../../../../res/app_colors.dart';
import '../../../../../../../utills/app_navigator.dart';
import '../../../../../../../utills/app_utils.dart';
import '../../../../../../../utills/custom_theme.dart';
import '../../../../../../important_pages/dialog_box.dart';
import '../../../../../../important_pages/not_found_page.dart';
import '../../../../../../widgets/app_custom_text.dart';
import '../../../../../../widgets/form_input.dart';
import '../../../../../landing_page.dart';

class AddSpace extends StatefulWidget {
  UserModel userModel;
  final Property property;
  bool isEdit;
  Space space;

  AddSpace(
      {super.key,
      required this.userModel,
      required this.isEdit,
      required this.space,
      required this.property});

  @override
  _AddSpaceState createState() => _AddSpaceState();
}

class _AddSpaceState extends State<AddSpace> {
  int _currentStep = 0;
  bool isToggled = false;

  //bool isOccupied = false;

  // Controllers to capture form input
  final TextEditingController spaceNumberController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  PropertyBloc propertyBloc = PropertyBloc();
  final TextEditingController selectedPropertyType =
      TextEditingController(text: '');
  bool isImagesDownloaded=true;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  //Property? property;
  void handleUpdate() async {
    AppUtils().debuglog('Updating property details...');

    // Update controllers outside setState
    spaceNumberController.text = widget.space.spaceNumber;
    selectedPropertyType.text = widget.space.spaceType;

    priceController.text = widget.space.price.toString() ?? '';

    descriptionController.text = widget.space.description;
    isToggled = widget.space.advertise;
    // isOccupied = widget.space.isOccupied;
    AppUtils().debuglog('Image URLs: ${widget.space.imageUrls}');
    List<String> urls = widget.space.imageUrls;
    AppUtils().debuglog('Extracted URLs: $urls');

    // Download images
    for (String imageUrl in urls) {
      isImagesDownloaded=false;
      AppUtils().debuglog('Downloading image from: $imageUrl');
      try {
        File imageFile = await downloadImage(AppApis.appBaseUrl +imageUrl);
        setState(() {
          imageFileList ??= []; // Initialize if null
          imageFileList!.add(XFile(imageFile.path));
        });
      } catch (e) {
        AppUtils().debuglog('Error downloading image: $e');
      }
    }
    isImagesDownloaded=true;
  }

  @override
  void initState() {
    // TODO: implement initState

    if (widget.isEdit) {
      handleUpdate();
    }
    super.initState();
  }

  void selectImages() async {
    final List<XFile>? selectedImages =
        await imagePicker.pickMultiImage(imageQuality: 50, limit: 4);

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

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Select from Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final List<XFile>? selectedImages =
                    await imagePicker.pickMultiImage(
                  imageQuality: 50,
                  maxWidth: 800,
                );

                if (selectedImages != null && selectedImages.isNotEmpty) {
                  int totalImages =
                      imageFileList!.length + selectedImages.length;

                  if (totalImages > 4) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('You can only select up to 4 images.')),
                    );
                    int remainingSlots = 4 - imageFileList!.length;

                    imageFileList!.addAll(
                      selectedImages
                          .take(remainingSlots)
                          .map((xFile) => XFile(xFile.path)),
                    );
                  } else {
                    imageFileList!.addAll(
                      selectedImages.map((xFile) => XFile(xFile.path)),
                    );
                  }

                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture with Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? capturedImage = await imagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxWidth: 800,
                );

                if (capturedImage != null) {
                  if (imageFileList!.length < 4) {
                    imageFileList!.add(capturedImage);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('You can only select up to 4 images.')),
                    );
                  }
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomText(text: widget.isEdit ? 'Update Space' : 'Add Space'),
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

                  imageFileList!.clear();
                  spaceNumberController.text = '';

                  priceController.text = '';

                  descriptionController.text = '';
                  //PropertyBloc propertyBloc = PropertyBloc();
                });
                MSG.snackBar(context, "Space edit Successful");

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
                      if (_currentStep < 1) {
                        // Adjust to 1 since there are only two steps: index 0 and 1
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        // Final step: Save property
                        // if (widget.isEdit) {
                        //   _updateProduct();
                        // } else {
                        if(isImagesDownloaded){
                          _saveSpace();

                        }else{
                          MSG.warningSnackBar(context, 'Images are been synchronized');
                        }
                        // }
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
                            text: 'Space Details',
                            size: 10,
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
                                          onTap: () =>
                                              _showImagePickerOptions(),
                                          child: Container(
                                            height: 250,
                                            width: AppUtils.deviceScreenSize(
                                                    context)
                                                .width,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.save_alt_rounded,
                                                    size: 50,
                                                    color: Colors.purple),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Click to select or capture images',
                                                  style: TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '(Only 4 images are allowed)',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (imageFileList != null &&
                                            imageFileList!.isNotEmpty)
                                          SizedBox(
                                            height: 100,
                                            child: GridView.builder(
                                              itemCount: imageFileList!.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                crossAxisSpacing: 4.0,
                                                mainAxisSpacing: 4.0,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.file(
                                                        File(imageFileList![
                                                                index]
                                                            .path),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            imageFileList!
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                              size: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        DropDown(
                                          label: 'Property Type',
                                          hint: "Select Property type",
                                          initialValue:
                                              selectedPropertyType.text,
                                          selectedValue:
                                              selectedPropertyType.text,
                                          items: [
                                            'Select Space Type',
                                            '1 Room Self Contain',
                                            '2 Bedroom Flat',
                                            '3 Bedroom Flat',
                                            'Studio Apartment',
                                            'Duplex',
                                            'Shop',
                                            'Office',
                                            'Single Room',
                                            'Warehouse Space',
                                            'Penthouse',
                                            'Shared Apartment',
                                            'Loft',
                                            'Townhouse',
                                            'Condominium',
                                            'Villa',
                                            'Cottage',
                                            'Retail Space',
                                            'Coworking Space',
                                            'Conference Room',
                                            'Serviced Apartment',
                                            'Terraced House',
                                            'Bungalow',
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
                                          controller: spaceNumberController,
                                          hint: 'Enter space name',
                                          label: 'Space Name',
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
                                        CustomTextFormField(
                                          controller: priceController,
                                          hint: 'Enter price',
                                          label: 'Price',
                                          textInputType: TextInputType.number,
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
                                        CustomTextFormField(
                                          controller: descriptionController,
                                          hint: 'Write about this property',
                                          label: 'Description',
                                          maxLines: 3,
                                          borderColor: Colors.grey,
                                          borderRadius: 10,
                                          backgroundColor: theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.white,
                                          hintColor: !theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.grey,
                                        )
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
                            text: 'Overview',
                            size: 10,
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              if (widget.isEdit)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: CustomText(
                                        text: 'Advertise Property?',
                                        size: 15,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: isToggled,
                                      onChanged: (value) {
                                        setState(() {
                                          isToggled = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              // const SizedBox(
                              //   height: 15,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     const Padding(
                              //       padding:
                              //           EdgeInsets.symmetric(horizontal: 16.0),
                              //       child: CustomText(
                              //         text: 'Is Property Occupied',
                              //         size: 14,
                              //         weight: FontWeight.bold,
                              //       ),
                              //     ),
                              //     Switch(
                              //       value: isOccupied,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           isOccupied = value;
                              //         });
                              //       },
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 15,
                              ),
                              lodgeContainer(
                                  lodge: spaceNumberController.text,
                                  context: context),
                              const SizedBox(
                                height: 20,
                              ),
                              _overviewRow(
                                  'Space Type', selectedPropertyType.text),
                              _overviewRow(
                                  'Property Name', spaceNumberController.text),

                              _overviewRow('Price', "₦${priceController.text}"),

                              // _overviewRow('Occupied Rooms',
                              //     occupiedRoomsController.text),
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
                      AppLoadingPage("Uploading space..."),
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
                      if (_currentStep < 1) {
                        // Adjust to 1 since there are only two steps: index 0 and 1
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        // Final step: Save property
                        // if (widget.isEdit) {
                        //   _updateProduct();
                        // } else {
                        if(isImagesDownloaded){
                          _saveSpace();

                        }else{
                          MSG.warningSnackBar(context, 'Images are been synchronized');
                        }
                        // }
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
                            size: 10,
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
                                          onTap: () =>
                                              _showImagePickerOptions(),
                                          child: Container(
                                            height: 250,
                                            width: AppUtils.deviceScreenSize(
                                                    context)
                                                .width,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                    Icons.save_alt_rounded,
                                                    size: 50,
                                                    color: Colors.purple),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Click to select or capture images',
                                                  style: TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  '(Only 4 images are allowed)',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if (imageFileList != null &&
                                            imageFileList!.isNotEmpty)
                                          SizedBox(
                                            height: 100,
                                            child: GridView.builder(
                                              itemCount: imageFileList!.length,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                crossAxisSpacing: 4.0,
                                                mainAxisSpacing: 4.0,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.file(
                                                        File(imageFileList![
                                                                index]
                                                            .path),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            imageFileList!
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                              Icons.close,
                                                              color: Colors.red,
                                                              size: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        DropDown(
                                          label: 'Property Type',
                                          hint: "Select Property type",
                                          initialValue:
                                              selectedPropertyType.text,
                                          selectedValue:
                                              selectedPropertyType.text,
                                          items: const [
                                            'Select Space Type',
                                            '1 Room Self Contain',
                                            '2 Bedroom Flat',
                                            '3 Bedroom Flat',
                                            'Studio Apartment',
                                            'Duplex',
                                            'Shop',
                                            'Office',
                                            'Single Room',
                                            'Warehouse Space',
                                            'Penthouse',
                                            'Shared Apartment',
                                            'Loft',
                                            'Townhouse',
                                            'Condominium',
                                            'Villa',
                                            'Cottage',
                                            'Retail Space',
                                            'Coworking Space',
                                            'Conference Room',
                                            'Serviced Apartment',
                                            'Terraced House',
                                            'Bungalow',
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
                                          controller: spaceNumberController,
                                          hint: 'Enter space name',
                                          label: 'Space Name',
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
                                        CustomTextFormField(
                                          controller: priceController,
                                          hint: 'Enter price',
                                          label: 'Price',
                                          textInputType: TextInputType.number,
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
                                        CustomTextFormField(
                                          controller: descriptionController,
                                          hint: 'Write about this property',
                                          label: 'Description',
                                          maxLines: 3,
                                          borderColor: Colors.grey,
                                          borderRadius: 10,
                                          backgroundColor: theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.white,
                                          hintColor: !theme.isDark
                                              ? AppColors
                                                  .darkCardBackgroundColor
                                              : AppColors.grey,
                                        )
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
                            text: 'Overview',
                            size: 10,
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              if (widget.isEdit)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: CustomText(
                                        text: 'Advertise Property?',
                                        size: 14,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: isToggled,
                                      onChanged: (value) {
                                        setState(() {
                                          isToggled = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              // const SizedBox(
                              //   height: 15,
                              // ),
                              //   Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       const Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 16.0),
                              //         child: CustomText(
                              //           text: 'Is Property Occupied',
                              //           size: 14,
                              //           weight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       Switch(
                              //         value: isOccupied,
                              //         onChanged: (value) {
                              //           setState(() {
                              //             isOccupied = value;
                              //           });
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              const SizedBox(
                                height: 15,
                              ),
                              lodgeContainer(
                                  lodge: spaceNumberController.text,
                                  context: context),
                              const SizedBox(
                                height: 20,
                              ),
                              _overviewRow(
                                  'Space Type', selectedPropertyType.text),
                              _overviewRow(
                                  'Property Name', spaceNumberController.text),

                              _overviewRow('Price', "₦${priceController.text}"),

                              // _overviewRow('Occupied Rooms',
                              //     occupiedRoomsController.text),
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

  void _saveSpace() {
    // Check if required fields are empty
    if (spaceNumberController.text.isEmpty) {
      MSG.warningSnackBar(context, 'Space number is required.');
      return;
    }

    if (selectedPropertyType.text.isEmpty) {
      MSG.warningSnackBar(context, 'Property type is required.');
      return;
    }

    if (priceController.text.isEmpty ||
        double.tryParse(priceController.text) == null) {
      MSG.warningSnackBar(context, 'Please provide a valid price.');
      return;
    }

    if (descriptionController.text.isEmpty) {
      MSG.warningSnackBar(context, 'Description is required.');
      return;
    }

    if (imageFileList == null || imageFileList!.isEmpty) {
      MSG.warningSnackBar(context, 'Please upload at least one image.');
      return;
    }

    // Prepare form data
    Map<String, dynamic> formData = {
      "space_number": spaceNumberController.text,
      "space_type": selectedPropertyType.text,
      //"is_occupied": isOccupied,
      "description": descriptionController.text,
      "price": double.parse(priceController.text),
      "advertise": isToggled,
    };

    AppUtils().debuglog('Form Data: $formData');

    // Dispatch the appropriate event
    if (widget.isEdit) {
      propertyBloc.add(UpdateSpaceEvent(
        formData,
        imageFileList!, // Use the first image for update
        widget.property.id.toString(),
        widget.space.id.toString() ?? '',
      ));
    } else {
      propertyBloc.add(AddSpaceEvent(
        formData,
        imageFileList!, // Use the first image for new space
        widget.property.id.toString(),
      ));
    }
  }
}

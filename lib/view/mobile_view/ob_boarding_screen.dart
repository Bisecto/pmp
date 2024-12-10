import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import '../../res/app_colors.dart';
import '../../res/app_images.dart';
import '../../utills/app_navigator.dart';
import '../../utills/app_utils.dart';
import '../important_pages/dialog_box.dart';
import '../important_pages/not_found_page.dart';
import '../widgets/app_custom_text.dart';

import 'auth/existin_signin.dart';

class DisplayPrincipleOfficersScreen extends StatefulWidget {
  const DisplayPrincipleOfficersScreen({super.key});

  @override
  State<DisplayPrincipleOfficersScreen> createState() =>
      _DisplayPrincipleOfficersScreenState();
}

class _DisplayPrincipleOfficersScreenState
    extends State<DisplayPrincipleOfficersScreen> {
  // final List<String> DisplayPrincipleOfficersImages = [
  //   "https://nau-slc.s3.eu-west-2.amazonaws.com/media/officers/vc.png",
  //   "https://nau-slc.s3.eu-west-2.amazonaws.com/media/officers/vc.png",
  //   "https://nau-slc.s3.eu-west-2.amazonaws.com/media/officers/vc.png",
  // ];
  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  final GlobalKey _sliderKey = GlobalKey();
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.dark,
    //   //color set to transperent or set your own color
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 0),
        child: SizedBox(
          //height: AppUtils.deviceScreenSize(context).height/2+50,
          //width: AppUtils.deviceScreenSize(context).width,

          child: Container(),
        ),
      ),
    );
  }
}

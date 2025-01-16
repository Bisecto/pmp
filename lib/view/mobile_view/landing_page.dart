import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pim/model/property_model.dart';
import 'package:pim/model/user_model.dart';
import 'package:pim/view/mobile_view/profile/profile_tab.dart';
import 'package:provider/provider.dart';
import 'package:pim/res/app_colors.dart';
import '../../utills/custom_theme.dart';
import 'add_property/add_property_tab.dart';
import 'dashboard/dashboard.dart';

class LandingPage extends StatefulWidget {
  int selectedIndex;
  UserModel userModel;

  LandingPage(
      {super.key, required this.selectedIndex, required this.userModel});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Widget> views = const [];
  int selectedIndex = 0;

  //int selectedIndex = 0;
  bool isNotification = false;

  void _onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedIndex = widget.selectedIndex;
    //topicInitialization();

    views = [
      Dashboard(
        onPageChanged: _onPageChanged,
        userModel: widget.userModel,
      ),
      AddPropertyScreen(
        userModel: widget.userModel,
        isEdit: false,
        property: Property(
            id: 0,
            propertyName: '',
            address: '',
            location: '',
            city: '',
            description: '',
            propertyType: '',
            price: '',
            priceType: '',
            priceRangeStart: '',
            priceRangeStop: '',
            totalSpace: 0,
            occupiedSpace: 0,
            status: '',
            occupants: [],
            firstImage: '',
            imageUrls: [ImageUrl(id: 0, url: '')],
            advertise: false,
            spaces: []),
      ),
      ProfileTab(
        userModel: widget.userModel,
      )
    ];
    super.initState();
  }

  final _androidAppRetain = const MethodChannel("android_app_retain");

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return Future.value(true);
          } else {
            _androidAppRetain.invokeMethod("sendToBackground");
            return Future.value(false);
          }
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: views,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.white,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          selectedItemColor: AppColors.mainAppColor,
          unselectedItemColor:
              theme.isDark ? AppColors.lightPrimary : AppColors.lightDivider,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
                color: selectedIndex == 0
                    ? AppColors.mainAppColor
                    : theme.isDark
                        ? AppColors.lightPrimary
                        : AppColors.lightDivider,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box,
                color: selectedIndex == 1
                    ? AppColors.mainAppColor
                    : theme.isDark
                        ? AppColors.lightPrimary
                        : AppColors.lightDivider,
              ),
              label: 'Add Property',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: selectedIndex == 2
                    ? AppColors.mainAppColor
                    : theme.isDark
                        ? AppColors.lightPrimary
                        : AppColors.lightDivider,
              ), //Icon(Icons.home),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

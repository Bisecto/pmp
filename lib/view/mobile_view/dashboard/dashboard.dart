import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_svg_images.dart';
import '../../../utills/custom_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_custom_text.dart';
import 'cafe_list.dart';

class Dashboard extends StatefulWidget {
  final Function(int) onPageChanged;

  Dashboard({super.key, required this.onPageChanged});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  int semesterId = 0;
  bool isImageNull = false;
  bool isImageAccessible = true;
  String currentSemester = 'uuu';
  List<String> topics = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Provider.of<CustomThemeState>(context);
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Scaffold(
      backgroundColor:
          theme.isDark ? AppColors.darkBackgroundColor : AppColors.lightPrimary,
      body:  SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const CustomAppBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SvgPicture.asset(
                  AppSvgImages.finger,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                TextStyles.textSubHeadings(textValue: 'Welcome Precious!',textSize: 20),

              ],
            ),
            Container(

            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LodgeList(),
            ),
          ],
        ),
      )),
    );
  }

  Set active = {};
  bool isLoading = true;

  void _handleTap(index) {
    setState(() {
      active.contains(index) ? active.remove(index) : active.add(index);
    });
  }

  Widget analyticsContainer() {
    return Container();
  }
}

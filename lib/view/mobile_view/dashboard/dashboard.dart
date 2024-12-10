import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../res/app_colors.dart';
import '../../../utills/custom_theme.dart';

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
      body: Container(),
    );
  }

  Set active = {};
  bool isLoading = true;

  void _handleTap(index) {
    setState(() {
      active.contains(index) ? active.remove(index) : active.add(index);
    });
  }
}

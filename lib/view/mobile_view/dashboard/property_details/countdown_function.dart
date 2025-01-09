import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';
import '../../../widgets/app_custom_text.dart';

class Countdown {
  late Timer _timer;
  final DateTime targetDate;
  final Function(String) onUpdate; // Callback to return the updated text

  Countdown({required this.targetDate, required this.onUpdate});

  void start() {
    _updateCountdown();

    // Schedule a timer to update every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    DateTime now = DateTime.now();

    if (targetDate.isBefore(now)) {
      onUpdate("Rent has expired!");
      //_timer.cancel();
      return;
    }

    int years = targetDate.year - now.year;
    int months = targetDate.month - now.month;
    int days = targetDate.day - now.day;

    if (days < 0) {
      months -= 1;
      DateTime previousMonth = DateTime(targetDate.year, targetDate.month - 1);
      days += DateTime(previousMonth.year, previousMonth.month + 1, 0).day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    Duration difference = targetDate.difference(now);

    final countdownText = "${years > 0 ? "$years years, " : ""}"
        "${months > 0 ? "$months months, " : ""}"
        "${difference.inDays.remainder(30)}days, "
        "${difference.inHours.remainder(24)}hrs, "
        "${difference.inMinutes.remainder(60)}mins, and "
        "${difference.inSeconds.remainder(60)}s";

    onUpdate(countdownText);
  }


  void stop() {
    _timer.cancel(); // Stop the timer when no longer needed
  }
}

class CountdownWidget extends StatefulWidget {
  final DateTime targetDate;

  const CountdownWidget({required this.targetDate});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  String _countdownText = "";

  @override
  void initState() {
    super.initState();

    // Start the countdown
    Countdown(
      targetDate: widget.targetDate,
      onUpdate: (text) {
        setState(() {
          _countdownText = text;
        });
      },
    ).start();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.justify,
        textDirection: TextDirection.ltr,
        softWrap: true,
        text: TextSpan(children: [

         // if(_countdownText!='Rent has expired!')

          TextSpan(
            text: _countdownText=='Rent has expired!'?'':'Rent Due In: ',
            style: TextStyle(
                fontStyle: FontStyle.normal,
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: _countdownText,
            style: TextStyle(
                //decoration: decoration,
                fontStyle: FontStyle.normal,
                color: AppColors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ]));

    //   TextStyles.richTexts(
    //   text1: "",
    //   text2: _countdownText,
    //   color2: AppColors.red
    // );

    //   CustomText(
    //   text: "Rent Due In: $_countdownText",
    //   size: 12,
    //   maxLines: 3,
    // );
  }
}

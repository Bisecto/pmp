import 'package:flutter/material.dart';

import '../../../../../res/app_colors.dart';
import '../widgets/app_custom_text.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: "Notification",
            size: 20,
            weight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: TextStyles.richTexts(
            text1: "No notification yet \n",
            // text2: "Make order",
            centerText: true,
            // onPress2: (){
            //   MSG.infoSnackBar(context, "Go to Homepage to start ordering.");
            // }
          ),
        )
        // ListView.builder(
        //   scrollDirection: Axis.vertical,
        //   physics: const ScrollPhysics(),
        //   shrinkWrap: true,
        //   itemCount: 5,
        //   itemBuilder: (BuildContext context, int index) {
        //     return _notificationConatiner();
        //   },
        //)
        );
  }

//       .mnp-mid-header{
//   background-color: #ff0000;
//   color: #ffffff;
// }
  Widget _notificationConatiner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
      child: Container(
        //height: 300,
        decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.grey, width: 1.5, style: BorderStyle.solid),
          //color: AppColors.lightPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: "Title of announcement",
                weight: FontWeight.bold,
                size: 18,
              ),
              TextStyles.richTexts(
                text1: "Lorem ipsum",
                text2: " dolor sit amet consectetur. "
                    "Non sed tempor pellentesque pharetra enim penatibus "
                    "euismod erat. Nisi est ac mi dictum odio nisl. "
                    "In ullamcorper "
                    "magna tortor eget tempor non.\n\nLorem "
                    "ipsum dolor sit amet consectetur. Non sed tempor "
                    "pellentesque pharetra enim penatibus euismod erat. Nisi "
                    "est ac mi dictum odio nisl. In ullamcorper magna tortor"
                    " eget tempor non.\n\nLorem ipsum dolor sit amet consectetur. "
                    "Non sed tempor pellentesque pharetra enim penatibus euismod "
                    "erat. Nisi est ac mi dictum odio nisl. In ullamcorper magna "
                    "tortor eget tempor non.",

                color: AppColors.blue,
                color2: AppColors.textColor,
                weight: FontWeight.w400,
                size: 16,
                // maxLines: 50,
                // textAlign: TextAlign.justify
              ),
            ],
          ),
        ),
      ),
    );
  }
}

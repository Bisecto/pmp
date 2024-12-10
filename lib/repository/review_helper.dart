import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class ReviewHelper {
  // static const String reviewKey = 'review_prompt_counts';
  // static const String reviewShownKey = 'review_prompt_showns';
  //static const int triggerCount = 2;

  final InAppReview inAppReview = InAppReview.instance;
  // Future<void> resetReviewPromptFlag() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(reviewShownKey, false); // Reset the review shown flag to false
  //   await prefs.setInt(reviewKey, 0); // Optionally reset the app opens count as well
  // }

  Future<void> checkAndRequestReview() async {
   // final prefs = await SharedPreferences.getInstance();

    // Check if the review prompt has already been shown
   // bool reviewShown = prefs.getBool(reviewShownKey) ?? false;
    // if (reviewShown) {
    //   resetReviewPromptFlag();
    //   return; // Exit if the review has already been shown
    // }

    // Get and increment the app opens count
   // int appOpens = prefs.getInt(reviewKey) ?? 0;
   //  print(appOpens);
   //  print(appOpens);
   //  print(appOpens);
   //  print(appOpens);
   //  print(appOpens);
   //  print(appOpens);
   // appOpens += 1;
    // print(appOpens);
    // print(appOpens);
    // print(appOpens);
    // print(appOpens);
    // print(appOpens);
    // print(appOpens);
    //await prefs.setInt(reviewKey, appOpens);

    // Check if app opens have reached the trigger count
   // if (appOpens >= triggerCount) {
      // print(triggerCount);
      // print(triggerCount);
      // print(triggerCount);
      // print(triggerCount);
      // print(triggerCount);
      // print(triggerCount);
      // print(triggerCount);
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing(); // Fallback if review dialog isn't available
      }

      // Mark that the review prompt has been shown
     // await prefs.setBool(reviewShownKey, true);

      // Reset the app opens count (optional, based on how often you want the prompt to appear)
      //await prefs.setInt(reviewKey, 0);
    }
  //}
}

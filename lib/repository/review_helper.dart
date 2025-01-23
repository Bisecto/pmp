import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

import '../utills/app_utils.dart';

class ReviewHelper {
  static const String reviewKey = 'review_prompt_counts';
  static const String reviewShownKey = 'review_prompt_showns';
  static const int triggerCount = 5;

  final InAppReview inAppReview = InAppReview.instance;
  Future<void> resetReviewPromptFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(reviewShownKey, false);
    await prefs.setInt(reviewKey, 0);
  }

  Future<void> checkAndRequestReview() async {
   final prefs = await SharedPreferences.getInstance();

   bool reviewShown = prefs.getBool(reviewShownKey) ?? false;
    if (reviewShown) {
      resetReviewPromptFlag();
      return;
    }

   int appOpens = prefs.getInt(reviewKey) ?? 0;
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
   appOpens += 1;
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    AppUtils().debuglog(appOpens);
    await prefs.setInt(reviewKey, appOpens);

   if (appOpens >= triggerCount) {
      AppUtils().debuglog(triggerCount);
      AppUtils().debuglog(triggerCount);
      AppUtils().debuglog(triggerCount);
      AppUtils().debuglog(triggerCount);
      AppUtils().debuglog(triggerCount);
      AppUtils().debuglog(triggerCount);
      AppUtils().debuglog(triggerCount);
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing(); // Fallback if review dialog isn't available
      }

      // Mark that the review prompt has been shown
     await prefs.setBool(reviewShownKey, true);

      // Reset the app opens count (optional, based on how often you want the prompt to appear)
      await prefs.setInt(reviewKey, 0);
    }
  }
}

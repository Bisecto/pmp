// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:school_portal/model/student_profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../utills/app_utils.dart';
//
// class SubscribedTopicsManager {
//
//   static const String _subscribedTopicsKey = 'SubscribedTopics';
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//
//   Future<List<String>> getSubscribedTopics() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(_subscribedTopicsKey) ?? [];
//   }
//
//   Future<void> saveSubscribedTopics(List<String> topics) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(_subscribedTopicsKey, topics);
//   }
//
//   Future<void> removeSubscribedTopic(String topicToRemove) async {
//     AppUtils().debuglog("Topics to remove");
//     AppUtils().debuglog(topicToRemove);
//     List<String> topics = await getSubscribedTopics();
//
//     topics.remove(topicToRemove);
//     await saveSubscribedTopics(topics);
//   }
//
//   Future<void> unsubscribeFromTopics(List<String> topics) async {
//     AppUtils().debuglog("Topics to unscuscribe");
//     AppUtils().debuglog(topics);
//     for(int i=0;i<topics.length;i++){
//       await _firebaseMessaging.unsubscribeFromTopic(topics[i]);
//
//     }
//   }
//   Future<void> removeSubscribe4rdTopic(String topic, String userId) async {
//     final topicsRef = _firestore.collection('users').doc(userId).collection('topics');
//
//     // Fetch the current list of subscribed topics
//     final documentSnapshot = await topicsRef.doc('subscribed_topics').get();
//
//     // If the document exists and the topic is in the list, remove it
//     if (documentSnapshot.exists) {
//       List<String> topics = List<String>.from(documentSnapshot.get('topics'));
//       if (topics.contains(topic)) {
//         topics.remove(topic);
//         // Save the updated list of subscribed topics
//         await topicsRef.doc('subscribed_topics').set({'topics': topics});
//       }
//     }
//   }
//
//   Future<List<String>> fetchTopicsFromFirestore(String userId) async {
//     try {
//       AppUtils().debuglog(userId);
//       // Fetch document from Firestore
//       final topicsRef = _firestore.collection('users').doc(userId).collection('topics');
//
//       // Fetch the current list of subscribed topics
//       final documentSnapshot = await topicsRef.doc('subscribed_topics').get();
//
//       // Check if the document exists
//       if (documentSnapshot.exists) {
//         List<String> firestoreTopics = List<String>.from(documentSnapshot.get('topics'));
//
//         //Map<String, dynamic> data = documentSnapshot.data()!;
//
//         // Extract topics from the document data
//         //List<String> firestoreTopics = List<String>.from(data['topics']);
//
//         // AppUtils().debuglog topics for debugging
//         AppUtils().debuglog("Firestore topics: $firestoreTopics");
//
//         return firestoreTopics;
//       } else {
//         AppUtils().debuglog("Document does not exist.");
//         return []; // Return an empty list if the document does not exist
//       }
//     } catch (e) {
//       AppUtils().debuglog("Error fetching topics: $e");
//       return []; // Return an empty list in case of error
//     }
//   }
//
//   // Future<List<String>> fetchTopicsFromFirestore(userId) async {
//   //   List<String> firestoreTopics = [];
//   //
//   //   // Fetch topics from Firestore
//   //   AppUtils().debuglog(userId);
//   //   DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(userId).collection('topics').doc("subscribed_topics").get();
//   //   AppUtils().debuglog(snapshot);
//   //   AppUtils().debuglog(snapshot);
//   //   AppUtils().debuglog(snapshot.data());
//   //   AppUtils().debuglog(snapshot.data());
//   //   AppUtils().debuglog(snapshot.data());
//   //   AppUtils().debuglog(snapshot.data());
//   //   AppUtils().debuglog(snapshot.data());
//   //   if (snapshot.exists) {
//   //     Map<String, dynamic> data = snapshot.data()!;
//   //     AppUtils().debuglog(data);
//   //
//   //     List<String> firestoreTopics = [];
//   //     // Extract topics from the document
//   //     data.forEach((key, value) {
//   //       firestoreTopics.add(key); // Assuming keys are the topics
//   //       AppUtils().debuglog("Firestore topic: $key");
//   //     });
//   //
//   //     AppUtils().debuglog("Firestore topics: $firestoreTopics");
//   //   } else {
//   //     AppUtils().debuglog("Document does not exist.");
//   //   }
//   //   // for (QueryDocumentSnapshot doc in snapshot.data()) {
//   //   //   firestoreTopics.add(doc.id);
//   //   //   AppUtils().debuglog("Firestore topics");
//   //   //   AppUtils().debuglog(doc.id);
//   //   // }
//   //   AppUtils().debuglog(firestoreTopics);
//   //   return firestoreTopics;
//   // }
//
//   Future<void> subscribeToTopics(List<String> topics) async {
//     AppUtils().debuglog("Subscribed topics ");
//     AppUtils().debuglog(topics);
//     for(int i=0;i<topics.length;i++){
//
//       await _firebaseMessaging.subscribeToTopic(topics[i]);}
//   }
//
//   Future<void> synchronizeTopics(String userId,StudentProfile studentprofile) async {
//     List<String> savedTopics = await getSubscribedTopics();
//
//     // Unsubscribe user from saved topics
//     await unsubscribeFromTopics(savedTopics);
//
//     // Fetch topics from Firestore
//     List<String> firestoreTopics = await fetchTopicsFromFirestore(userId);
//     firestoreTopics.add(studentprofile.program);
//     firestoreTopics.add("${studentprofile.program}_${studentprofile.faculty.name}");
//     firestoreTopics.add("${studentprofile.program}_${studentprofile.department.name}");
//     firestoreTopics.add(studentprofile.faculty.name);
//     firestoreTopics.add(studentprofile.department.name);
//     firestoreTopics.add("${studentprofile.registrationNumber}_${studentprofile.id}");
//     // Subscribe user to Firestore topics
//     await subscribeToTopics(firestoreTopics);
//
//     // Save fetched topics to SharedPreferences
//     await saveSubscribedTopics(firestoreTopics);
//   }
//
//   Future<void> saveFetchedTopicsToSharedPref(List<String> topics) async {
//     // Save fetched topics to SharedPreferences
//     AppUtils().debuglog("Save fetched topics to SharedPreferences");
//     AppUtils().debuglog(topics);
//     await saveSubscribedTopics(topics);
//   }
// }
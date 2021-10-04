import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<void> getNotification(time, notificationSent) async {
    String token = await firebaseMessaging.getToken();
    await firebaseFirestore.collection('Notifications').doc(token).set({
      'token': token,
      'time': time,
      'notificationSent': notificationSent,
    });
  }
}

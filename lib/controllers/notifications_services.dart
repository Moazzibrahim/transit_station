import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'  as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

Future<void> handleBackGoroundMessage(RemoteMessage message) async{
  log('message: ${message.notification!.title}');
}

class NotificationsServices with ChangeNotifier {
  String accessToken = '';

  Future<void> sendNotification(String title, String message,String role) async {
  try {
    if(role == 'admin'){
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('admins').get();

    // List to keep track of the users that received the notification
    List<String> tokens = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String? token = data['fcm_token'];

        if (token != null) {
          tokens.add(token); // Add token to the list
          await sendPushNotification(accessToken, token, title, message);
        }
      }
    }

    // Store the notification message in Firestore only once
    if (tokens.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('messages').add({
        'title': title,
        'body': message,
        'role' : 'admin',
        'createdAt': FieldValue.serverTimestamp(),
        'sentToCount': tokens.length,
      });
    }
    }else if(role == 'user'){
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

    // List to keep track of the users that received the notification
    List<String> tokens = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String? token = data['fcm_token'];

        if (token != null) {
          tokens.add(token); // Add token to the list
          await sendPushNotification(accessToken, token, title, message);
        }
      }
    }

    // Store the notification message in Firestore only once
    if (tokens.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('messages').add({
        'title': title,
        'body': message,
        'role' : 'user',
        'timestamp': FieldValue.serverTimestamp(),
        'sentToCount': tokens.length,
      });
    }
    }else{
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('drivers').get();

    // List to keep track of the users that received the notification
    List<String> tokens = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String? token = data['fcm_token'];

        if (token != null) {
          tokens.add(token); // Add token to the list
          await sendPushNotification(accessToken, token, title, message);
        }
      }
    }

    // Store the notification message in Firestore only once
    if (tokens.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('messages').add({
        'title': title,
        'body': message,
        'role' : 'driver',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    }
  } catch (e) {
    log('Error sending notification: $e');
  }
}

  Future<void> sendPushNotification(
    String accessToken, String fcmToken, String title, String body) async {
  final Uri url =
      Uri.parse('https://fcm.googleapis.com/v1/projects/transit-station-4c763/messages:send');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(
      <String, dynamic>{
        'message': <String, dynamic>{
          'token': fcmToken,
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
          },
          'android': <String, dynamic>{
            'priority': 'high',
          },
        },
      },
    ),
  );

  if (response.statusCode == 200) {
    log('Notification sent successfully');
  } else {
    log('Failed to send notification: ${response.body}');
  }
}

  Future<void> getAccessToken() async {
    final serviceAccountJson = {
  "type": "service_account",
  "project_id": "transit-station-4c763",
  "private_key_id": "5ae14cc1997fe01e79d70db184a730a5f7d8cf83",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDSoDI7mDuGfZP/\nSSXUbI9AwhN28+s+SKKRGvVLmZiYYcpOkaLNeHIyTotAgYgOHy/gcFlZbadMntln\n/1V8ilMIsAi+46wWZzIVaVHhvdxPpgtyTGSt1Afy9NuD+rfNsTAEj3NQHcwGJIjQ\nu0cZYqZFj8TL/T0zcmRmwF/j8Fwy+rXEOVH1tew+Y04+elIB0apAl4HIRjUvDsGT\nA0+stFnxwwJwtOk1HcvCqT31Y0nggQNAgl7Gc//YVq/X5unl3AyDMH2LThaGgILD\nnOtTjcmiCQtS7ETo9CBx2QYuxnQRZy1DMWwwGp9KrK/NR3J32c5/Smh+UT8BOw+4\ntLU9e20vAgMBAAECggEAYu4guhIuf2Szo5h5ftXA0ZN27gvyxi36wbpOVgSegpCI\nJDBOrkDxLoTq7lEJFUz7wWkz5ofVKW2BQ1JQlm8oQi/g47xvg5RUF2+BKM1zUiv1\nO2n7bhRl6W2uP8b/F0uu+K1iZdKhFo+JfbVBV4CZBZpaPtBDM0t7MjIQuDEZNU3n\nWgt7RxI1QGJXg4sg01L2oh6FpHNYOXiIOpK6WNzVRRA6kYkh3lMuPTVV0w0nw7aO\nV0X2qeYTyOupUOmpPRdF+JhF1I2yG7SoDlQyFG8jI0VcAqxjDSjh8NamsdfpUYUH\nPYudQmnLJnUs3+CbvDDDmoX6GIxlGyIduybJRKnmEQKBgQD6XI6bS/RiYxSy/JXK\nLuS6jop8jPQ9++MJ9KCWf/9Zt2XLkQRaiT0HOx3lhxGSlDk5NPHIDVsMg0HysROz\nk/PO0WnqpZpEJZ3H870BMO8jB/x9XTs6ANOH+6bZHhknH/tnq99qD/aBnor3mOPs\nMUi97wnQKsEYLl1njXtZRVdk3wKBgQDXXouNq8ssrtaifl5UZlgSpyJf85hqqqAn\nWU0ybEwHrzwUpkixxWvkdyXcJsGyszj02vceQbvwL0InIIm8RCOnJt1WIoUoNGUS\nGejRbRQ09F6V1clYb6Xi00KTYtzvhWzhQlpOOHMTWHDhd1HEnf4y1DFN5xJG/Lhz\nTadj5kAxsQKBgEvdTi1K19QUeApAtdcdXJwXY2mYgM5jjInQwfS49pSmGUeVOv+A\nRKjzRfzub+m91pU6MOXQ/j0NbSdwdyrcc23BUVoUMmniCCy19BjvTheMbPtEDBVo\neLDlFcsG7tJHQ7RHhZyrF6RxeWTLxI0m5gb/7zZQLlD4g79ERRNpCrF7AoGAQYwK\n2SFSAtVriaUAPJuxbmvjsGRJHR21BITPU+tV8HjKxlYdhc1aGvyQT0KUbTjSuuLx\nlwnWkzEu5w2mHeB3IWZYsuBqumPH5wxvqV2TatJ8/wlD8GB6kmBNwOGz8EohayVw\nqqHPlDG0mUphXn/fX8TpBJaxH13HHYCi02q+WuECgYBf1TRprlVmjjjZv1OMf7R2\nvgpi64A54vir2lmIsYE9cZHZm06SkyTcYJzCkdHjgkw4AdHTMSQcH8N0BKgICWOa\nMd9MyvwOdIdFLismByzWuMgZxuHl8kOrxgQTLggAwyZqKZFoufE9Eyq+7P8IYZ6r\n9vOuGIPMF/zHZMf5+bpdyw==\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-gkeba@transit-station-4c763.iam.gserviceaccount.com",
  "client_id": "104152838167956917028",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-gkeba%40transit-station-4c763.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();
      log("Access Token: ${credentials.accessToken.data}");
      accessToken = credentials.accessToken.data;
      notifyListeners();
    } catch (e) {
      log("Error getting access token: $e");
    }
  }

  Future<void> initFCMToken(int userId, String role) async {
    FirebaseMessaging.onBackgroundMessage(handleBackGoroundMessage);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the FCM token
    String? token = await messaging.getToken();

    if (token != null) {
      if(role == 'admin'){
        await FirebaseFirestore.instance.collection('admins').doc(userId.toString()).set({
        'fcm_token': token,
      });

      log("FCM Token stored for admin $userId: $token");
      }else if(role == 'user'){
        await FirebaseFirestore.instance.collection('users').doc(userId.toString()).set({
        'fcm_token': token,
      });

      log("FCM Token stored for user $userId: $token");
      }else{
        await FirebaseFirestore.instance.collection('drivers').doc(userId.toString()).set({
        'fcm_token': token,
      });

      log("FCM Token stored for driver $userId: $token");
      }
    } else {
      log("Failed to get FCM token");
    }

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log('App opened from terminated state by notification: ${message.notification?.title}');
        // Handle the data message here
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Received message in foreground: ${message.notification?.title}');
      // Handle foreground message
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App opened by notification: ${message.notification?.title}');
      // Handle the case when the app is opened by tapping a notification
    });

  }


  Future<List<Map<String, dynamic>>> fetchMessagesByRole(String role) async {
  try {
    // Reference to the Firestore collection 'messages'
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('role', isEqualTo: role)
        .get();

    // Extracting documents and converting them to a list of maps
    List<Map<String, dynamic>> messages = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return messages;
  } catch (e) {
    log('Error fetching messages: $e');
    return [];
  }
}

  }

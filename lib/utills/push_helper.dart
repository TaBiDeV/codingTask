// ignore_for_file: await_only_futures, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PusherHelper {
  static PusherHelper? _this;
  PusherHelper? instance;
  static FirebaseMessaging? _messaging;

  static PusherHelper? getInstance() {
    if (_this == null) {
      _this = PusherHelper();
      _this?.instance = PusherHelper();
      _messaging = FirebaseMessaging.instance;
    }
    return _this;
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app

    // 2. Instantiate Firebase Messaging

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings? settings = await _messaging?.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings?.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(openApp);
      // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(openApp);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void openApp(RemoteMessage message) {
    message.notification?.title;
    message.notification?.body;

    print(
        "notification test: ${message.notification?.title} ${message.notification?.body}");
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  subscribe(String id) async {
    debugPrint('subscribe >>><<< ${id}');
    return await _messaging?.subscribeToTopic("${id}");
  }

  unSubscribe(String id) async {
    return await _messaging?.unsubscribeFromTopic("${id}");
  }

  getFcmToken() async {
    return await _messaging?.getToken();
  }

  onTokenRef() async {
    return await _messaging?.onTokenRefresh.listen((event) {
      print("refreshed_token: ,$event");
    });
  }
}

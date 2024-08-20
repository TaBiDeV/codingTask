import 'dart:developer';
import 'dart:io' show Platform;

import 'package:coding_task/firebase_options.dart';
import 'package:coding_task/state_management/cubit/login_cubit.dart';
import 'package:coding_task/ui/login_screen.dart';
import 'package:coding_task/utills/push_helper.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  final fcmToken =
      await FirebaseMessaging.instance.getToken().then((value) async {
    PusherHelper.getInstance()?.registerNotification();
    if (Platform.isAndroid) {
      final fcmToken = await PusherHelper.getInstance()?.getFcmToken();
      log("fcm_token_android  $fcmToken");
    }
  });

  log("FCMToken_ios $fcmToken");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}

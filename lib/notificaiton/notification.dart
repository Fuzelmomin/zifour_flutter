import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'deviceModel.dart';

///notification step need to follow
///1  add this below section in your android manifest file
/// <meta-data
///                 android:name="com.google.firebase.messaging.default_notification_icon"
///                 android:resource="@drawable/ic_notification" />
///
///             <meta-data
///                 android:name="com.google.firebase.messaging.default_notification_channel_id"
///                 android:resource="@string/default_notification_channel_id" />
///
/// 2 add black end white icon in drawable folder with ic_notification.png
/// 3 past this file in your code



class PushNotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  Logger logger = Logger();

  Future initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'fcm_fallback_notification_channel', // id
        'Miscellaneous', // title
        // 'This channel is used for important notifications.', // description
        importance: Importance.high,
        ledColor: Colors.orange);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_notification');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
          final message = RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
          print('onDidReceiveNotificationResponse: $message');
          //navigatorKey.currentState?.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
          /*navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          );*/
        });

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    const topic = 'app_promotion';
    await _fcm.subscribeToTopic(topic);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.w("NOTIFICATION SERVICE Local Notification = ${message.toMap()}");
      _showLocalNotification(message);
      // onTapNotification(message.data);
    });

    //await getDeviceData();

    // Get the token
  }

  Future<void> backgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
  }

  void _showLocalNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fcm_fallback_notification_channel',
      'Miscellaneous',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification',
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
      fullScreenIntent: true,
      timeoutAfter: 30000,
      ongoing: true,
      visibility: NotificationVisibility.public,
    );

    DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  /*Future getDeviceData() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    String? token = await _fcm.getToken() ?? '';
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.toMap();
    print('All Info ${allInfo.toString()}');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String? osVersion;
    String? deviceCompany;
    String? model;
    String? deviceId;
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        osVersion = build.version.sdkInt.toString(); //UUID for Android
        deviceCompany = '${build.manufacturer} - ${build.brand}';
        model = build.model;
        deviceId = build.id;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        osVersion = data.systemVersion;
        deviceCompany = 'Apple - ${data.utsname.machine!.iOSProductName}';
        model = data.model;
        deviceId = data.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    Map<String, dynamic> data = {"deviceId": deviceId, "fcmToken": token, "deviceCompany": deviceCompany, "deviceName": model, "os": Platform.isAndroid ? 'android' : 'ios', "appVersion": packageInfo.version.toString(), "osVersion": osVersion};
    final logger = Logger();
    logger.d(data);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String deviceData = jsonEncode(data);
    await pref.setString(AppConstants.deviceData, deviceData);
    marketFcmApi();
  }*/

}

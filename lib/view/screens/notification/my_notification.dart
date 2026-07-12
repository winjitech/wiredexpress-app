import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wired_express/main.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:path_provider/path_provider.dart';

class MyNotification {
  BuildContext? contextBuilder;

  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      ) async {
    var androidInitialize = AndroidInitializationSettings('notification_icon');
    var iosInitialize = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print('Notification payload 1: ${response.payload}');
        if (response.payload != null) {
          print('Notification payload: ${response.payload}');
          String? pageID = response.payload;
          // Handle navigation based on pageID
        }
      },
    );

    // Listening to Firebase messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      // if (navigatorKey.currentContext != null) {
      MyNotification.showNotification(
        message.data,
        flutterLocalNotificationsPlugin,
        // navigatorKey.currentContext!,
      );
      // } else {
      //   print("Navigator context is null. Unable to show notification.");
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App Opened');
    });
  }

  static Future<void> showNotification(
      Map<String, dynamic> message,
      FlutterLocalNotificationsPlugin fln,
      // BuildContext context,
      ) async {
    print("message['screen_type'] === ${message['screen_type']}");

    // Existing notification logic
    if (message['image'] != null && message['image'].isNotEmpty) {
      try {
        await showBigPictureNotificationHiddenLargeIcon(message, fln);
      } catch (e) {
        await showBigTextNotification(message, fln);
      }
    } else {
      await showBigTextNotification(message, fln);
    }
  }

  // static Future<void> showNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
  //   print('message here: ${message}');
  //
  //   // Logic to show notification based on message data
  //   if (message['image'] != null && message['image'].isNotEmpty) {
  //     try {
  //       await showBigPictureNotificationHiddenLargeIcon(message, fln);
  //     } catch (e) {
  //       await showBigTextNotification(message, fln);
  //     }
  //   } else {
  //     await showBigTextNotification(message, fln);
  //   }
  // }

  static Future<void> showTextNotification(
      Map<String, dynamic> message,
      FlutterLocalNotificationsPlugin fln,
      ) async {
    String _title = message['title'];
    String _body = message['description'];
    String _pageId = message['screen_type'];

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await fln.show(
      0,
      _title,
      _body,
      platformChannelSpecifics,
      payload: _pageId,
    );
  }

  static Future<void> showBigTextNotification(
      Map<String, dynamic> message,
      FlutterLocalNotificationsPlugin fln,
      ) async {
    String _title = message['title'];
    String _body = message['description'];
    String _pageId = message['screen_type'].toString();

    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body,
      htmlFormatBigText: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      importance: Importance.max,
      icon: 'notification_icon',
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await fln.show(
      0,
      _title,
      _body,
      platformChannelSpecifics,
      payload: _pageId,
    );
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
      Map<String, dynamic> message,
      FlutterLocalNotificationsPlugin fln,
      ) async {
    String _title = message['title'];
    String _body = message['description'];
    String _pageId = message['screen_type'].toString();

    String _image =
    message['image'].startsWith('http')
        ? message['image']
        : '${AppConstants.baseUrl}/public/storage/notifications/${message['image']}';

    final String largeIconPath = await _downloadAndSaveFile(
      _image,
      'largeIcon',
    );
    final String bigPicturePath = await _downloadAndSaveFile(
      _image,
      'bigPicture',
    );

    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
      summaryText: _body,
      htmlFormatSummaryText: true,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      icon: 'notification_icon',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await fln.show(
      0,
      _title,
      _body,
      platformChannelSpecifics,
      payload: _pageId,
    );
  }

  static Future<String> _downloadAndSaveFile(
      String url,
      String fileName,
      ) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print('background: ${message.data}');
  var androidInitialize = AndroidInitializationSettings('notification_icon');
  var iosInitialize = DarwinInitializationSettings();
  var initializationsSettings = InitializationSettings(
    android: androidInitialize,
    iOS: iosInitialize,
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  MyNotification.showNotification(
    message.data,
    flutterLocalNotificationsPlugin,
  );

  if (message.data['screen_type'] != null) {
    String pageID = message.data['screen_type'];

    if (navigatorKey.currentState != null) {
      // navigatorKey.currentState?.push(
      //   MaterialPageRoute(builder: (context) => DashboardScreen(pageIndex: 2)),
      // );
    }
  }
}

void showCustomNotification(RemoteMessage message) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'notification_icon',
  );

  final platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title,
    message.notification!.body,
    platformChannelSpecifics,
    payload: message.data['screen_type'], // Use appropriate key
  );
}

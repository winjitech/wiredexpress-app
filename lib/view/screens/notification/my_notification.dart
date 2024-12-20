import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wired_express/utill/app_constants.dart';
import 'package:path_provider/path_provider.dart';

class MyNotification {
  BuildContext? contextBuilder;
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = new AndroidInitializationSettings('notification_icon');
  //  var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize);
    var screenPageNotify;
    var notificationType;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("onMessage: ${message.data}");
      MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
      screenPageNotify = message.data['screen'];
      notificationType = message.data['type'];
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      var screenPage = message.data['screen'];
    //  searchProvider.searchProduct('$_searchType' + '$_searchProblem' + 'moist', context);
      print("onMessageApp: ${message.data['type']}");
      if(message.data['type'] == 'admin_notification'){
        print('Is admin notification');
        var box = Hive.box('myBox');
        box.put('notification_type', 'admin_notification');
        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> NotificationScreen()));
      }
      
      var data = jsonDecode(message.data['message']);
      print("data 1: ${data}");
      var data2 = data['title'];
     
      print("data 2: ${data2}");
      print(screenPage);
    });
  }

  static Future<void> showNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    print('message here: ${message}');
   // Map<String, dynamic> messageA = jsonDecode(message['message']);
    if(message['image'] != null && message['image'].isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(message, fln);
      }catch(e) {
        await showBigTextNotification(message, fln);
      }
    }else {
      await showBigTextNotification(message, fln);
    }
  }

  static Future<void> showTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'] ;

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: _orderID);

  }

  static Future<void> showBigTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {

   // Map<String, dynamic> messageA = jsonDecode(message['message']);

    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'].toString();

    print("onMessage: ${message['title']} ---  ${message['body']} ----  ${message['order_id']}");
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body, htmlFormatBigText: true,
      contentTitle: _title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name', importance: Importance.max, icon: 'notification_icon',
      styleInformation: bigTextStyleInformation, priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    print('testt ${platformChannelSpecifics.android!.channelId}'); // why this value is always null, even when i added icon path
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: _orderID);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    print("image notification:");
   // Map<String, dynamic> messageA = jsonDecode(message['message']);
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = '0';
    // String _image = 'http://localhost/tiejet/public/storage/notifications/${messageA['image']}';
    String _image = message['image'].startsWith('http') ? message['image']
        : '${AppConstants.BASE_URL}/public/storage/notifications/${message['image']}';
    final String largeIconPath = await _downloadAndSaveFile(_image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(_image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: _title, htmlFormatContentTitle: true,
      summaryText: _body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name', icon: 'notification_icon',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: _orderID);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
     return filePath;
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print('background: ${message.data}');

  var androidInitialize = new AndroidInitializationSettings('notification_icon');
 // var iOSInitialize = new IOSInitializationSettings();
  var initializationsSettings = new InitializationSettings(android: androidInitialize);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  MyNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
}


void showCustomNotification(RemoteMessage message) async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'notification_icon'
  );

  final platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title,
    message.notification!.body,
    platformChannelSpecifics,
    payload: message.data['screen'], // Use appropriate key
  );
}
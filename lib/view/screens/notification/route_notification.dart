// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'package:path_provider/path_provider.dart';
//
// class RouteNotification {
//
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = new AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = new IOSInitializationSettings();
//     var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//     var screenPageNotify;
//     var notificationType;
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: ${message.data}");
//       RouteNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
//       screenPageNotify = message.data['screen'];
//       notificationType = message.data['type'];
//     });
//
//
//     flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) async {
//
//       print('first one :' + payload!);
//       if (notificationType == '0'){
//
//         try{
//           if(payload != null && payload.isNotEmpty) {
//             MyApp.navigatorKey.currentState!.push(
//                 MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderModel: null!, orderId: int.parse(payload))));
//           }
//         }catch (e) {
//
//         }
//         print('The type number is:' + notificationType);
//         return;
//
//       } else if (notificationType == '1'){
//         try{
//
//           MyApp.navigatorKey.currentState!.push(
//             //   MaterialPageRoute(builder: (context) => SearchResultScreen()));
//               MaterialPageRoute(builder: (context) => NotificationTargeting(route_id: screenPageNotify,)));
//           print(payload);
//           print('the screen page is: ' + screenPageNotify);
//           //   print(message.data['screen']);
//
//         }catch (e) {
//
//         }
//         print('The type number is:' + notificationType);
//         return;
//       }
//     });
//
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//
//       var screenPage = message.data['screen'];
//       //  searchProvider.searchProduct('$_searchType' + '$_searchProblem' + 'moist', context);
//
//
//       print("onMessageApp: ${message.data}");
//       print(screenPage);
//     });
//
//
//   }
//
//
//
//   static Future<void> showNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//     if(message['image'] != null && message['image'].isNotEmpty) {
//       try{
//         await showBigPictureNotificationHiddenLargeIcon(message, fln);
//       }catch(e) {
//         await showBigTextNotification(message, fln);
//       }
//     }else {
//       await showBigTextNotification(message, fln);
//     }
//   }
//
//
//   static Future<void> showTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//     String _title = message['title'];
//     String _body = message['body'];
//     String _screenID = message['screen'] ;
//
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'your channel id', 'your channel name', sound: RawResourceAndroidNotificationSound('notification'),
//       importance: Importance.max, priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, _title, _body, platformChannelSpecifics, payload: _screenID);
//
//   }
//
//   static Future<void> showBigTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//     String _title = message['title'];
//     String _body = message['body'];
//     String _screenID = message['screen'];
//     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//       _body, htmlFormatBigText: true,
//       contentTitle: _title, htmlFormatContentTitle: true,
//     );
//     AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'big text channel id', 'big text channel name', importance: Importance.max,
//       styleInformation: bigTextStyleInformation, priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, _title, _body, platformChannelSpecifics, payload: _screenID);
//   }
//
//   static Future<void> showBigPictureNotificationHiddenLargeIcon(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
//     String _title = message['title'];
//     String _body = message['body'];
//     String _screenID = message['screen'];
//     String _image = message['image'].startsWith('http') ? message['image']
//         : '${AppConstants.BASE_URL}/storage/app/public/notification/${message['image']}';
//     final String largeIconPath = await _downloadAndSaveFile(_image, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(_image, 'bigPicture');
//     final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
//       contentTitle: _title, htmlFormatContentTitle: true,
//       summaryText: _body, htmlFormatSummaryText: true,
//     );
//     final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'big text channel id', 'big text channel name',
//       largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
//       styleInformation: bigPictureStyleInformation, importance: Importance.max,
//     );
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, _title, _body, platformChannelSpecifics, payload: _screenID);
//   }
//
//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentosDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.data);
//     return filePath;
//   }
//
// }
//
// Future<dynamic> myBackgroundMessageHandlerRoute(RemoteMessage message) async {
//   print('background: ${message.data}');
//
//   var androidInitialize = new AndroidInitializationSettings('notification_icon');
//   var iOSInitialize = new IOSInitializationSettings();
//   var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   flutterLocalNotificationsPlugin.initialize(initializationsSettings);
//   RouteNotification.showNotification(message.data, flutterLocalNotificationsPlugin);
// }

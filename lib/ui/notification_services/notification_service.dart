import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:home_hub_services/getstorage/StorageClass.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  StorageService _storageService = StorageService();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  getFCMToken() async {
    try {
      String? token = await messaging.getToken();
      log('FCM::::::>>>> $token');
      //getStorage
      await _storageService.updateServices(token!);
      return token;
      // PreferenceManager.setFCM(token.toString());
    } catch (e) {
      log('ERROR:::WHILE:::GETTING:::FCM::::::>>>> $e');
    }
  }

  static void showMsgHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      // RemoteNotification? notification = message!.notification;
      // AndroidNotification? android = message.notification?.android;
      log("notification>>>>> BODY : ${message?.notification?.body} , TITLE : ${message?.notification?.title} , DATA : ${message?.data}");
      showMsg(message!);
    });
  }

  /// handle notification when app in fore ground..///close app
  static void getInitialMsg() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        //  FlutterRingtonePlayer.stop();
        // _singleListingMainTrailController.setSlugName(
        //     slugName: '${message?.data['slug_name']}');
      }
    });
  }

  ///show notification msg
  static void showMsg(RemoteMessage message) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      '${message.notification?.title}',
      '${message.notification?.body}',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(presentSound: true, presentAlert: true),
      ),
      payload: jsonEncode(message.data),
    );
  }

  ///background notification handler..
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log('Handling a background message ${message.data}');
    RemoteNotification? notification = message.notification;
  }

  ///call when click on notification back
  static void onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log('listen->${message.data}');
    });
  }

  static Future<bool?> sendMessage({
    String? receiverFcmToken,
    String? msg,
    String? title,
  }) async {
    var serverKey =
        'AAAAwC0qATY:APA91bEZEi7emQUNGXXSkGRqMfnd-hspactqORS6huARMRU4FQbFH_bWwcPop4Dxt3uLLpdZ51uD7wrLh2zlt6peYPewGgYOnyI3NvibHnrnpOBEn-fJLRoVk2dObeI_tOzefsivJD-G';
    try {
      // for (String token in receiverFcmToken) {
      log("RESPONSE TOKEN  $receiverFcmToken");

      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': msg ?? 'msg',
              'title': title ?? '',
              'bodyLocKey': 'true'
            },
            'priority': 'high',
            'to': receiverFcmToken,
          },
        ),
      );
      log("RESPONSE CODE ${response.statusCode}");

      log("RESPONSE BODY ${response.body}");
      // return true}
    } catch (e) {
      print("error push notification");
      // return false;
    }
    return null;
  }
}

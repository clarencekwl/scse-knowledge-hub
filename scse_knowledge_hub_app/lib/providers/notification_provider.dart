import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scse_knowledge_hub_app/providers/question_provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:provider/provider.dart';
import 'package:scse_knowledge_hub_app/utils/styles.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationProvider();
  static BuildContext? _context;
  static void setContext(BuildContext context) => _context = context;

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late QuestionProvider _questionProvider;
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'Question Notifications', 'Question Notifications',
            color: Styles.primaryBlueColor,
            // playSound: true,
            // sound: RawResourceAndroidNotificationSound('notification'),
            importance: Importance.max,
            priority: Priority.high);

    var not = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    await _localNotificationsPlugin.show(0, title, body, not, payload: payload);
  }

  static Future<void> addNotification(
      {required String title,
      required String body,
      required int endTime,
      required String channel,
      String? payload}) async {
    //* 1
    tzData.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    //* 2
    final androidDetail = AndroidNotificationDetails(
      channel, // channel Id
      channel, // channel Name
      importance: Importance.max,
      priority: Priority.high,
      // ledColor: Colors.red,
      // ledOnMs: 5000,
      // ledOffMs: 6000,
      // enableLights: true,
      tag: 'THIS IS TAG',
      subText: 'THIS IS SUBTEXT',
    );

    final iosDetail = DarwinNotificationDetails(
      // subtitle: 'SUB TITLEEEEEE',
      interruptionLevel: InterruptionLevel.critical,
    );

    final notifDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    //* 3
    final id = 0;

    //* 4
    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      notifDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'XDDDDDDDDDDD',
    );
  }

  static Future<void> cancelScheduledNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }

  Future<void> setup() async {
    //! NOTIFICATION
    const androidSetting = AndroidInitializationSettings('');
    const iosSetting = DarwinInitializationSettings(
      requestCriticalPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const initSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );

    await _localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onTapNotification);
    // onDidReceiveBackgroundNotificationResponse: (details) {
    //   log('RECEIVE NOTIFICATION: ${details.payload}');
    // },

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(AndroidNotificationChannel(
          'Question Notifications', // id
          'Question Notifications', // title
          description: 'Notifications for question updates',
          importance: Importance.max,
        ));
  }

  Future<void> onTapNotification(NotificationResponse? response) async {
    if (null == _context || null == response || null == response.payload) {
      log("no payload");
      return;
    }
    log('Notification payload: ${response.payload}');
    // _caseProvider = Provider.of<CaseProvider>(_context!, listen: false);
    // String caseID = response.payload!;
    // await _caseProvider.getCaseDetailsNotification(caseID);

    // Navigator.of(_context!)
    //     .push(MaterialPageRoute(
    //         builder: (context) =>
    //             CaseDetailsPage(item: _caseProvider.currentCase!)))
    //     .then((value) => _caseProvider.getCases(onRefresh: true));
  }
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  log('RECEIVE NOTIFICATION: $id');
}

import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notification/helper/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool status = false;
  int hours = 0;
  int minutes = 0;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(
      onMessage: (message) async {
        print('On Message  : $message');
      },
      onLaunch: (message) async {
        print('On Launch : $message');
      },
      onResume: (message) async {
        print('On Resume : $message');
      },
    );
    notification();
  }

  notification() async {
    print('Notification method called.!');
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  notificationDetails() async {
    Time time = Time(hours, minutes, 1);
    var currentHour = DateTime.now().hour;
    var currentMinute = DateTime.now().minute;
    var currentDate = DateTime.now().day;
    print('Current time : $currentHour : $currentMinute : $currentDate');
    // Time currentTime = Time(currentHour, currentMinute, 1);
    print(
        'Time at notification Details : ${time.hour} : ${time.minute} : ${time.second}');
    print('Notification details method called.!');
    int bodyMessage = Random().nextInt(20);
    print('Body message value : $bodyMessage');
    var androidNotification = AndroidNotificationDetails(
      'CHANNEL ID',
      "CHANNLE NAME",
      "channelDescription",
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      playSound: true,
    );
    var iosNotification = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformNotification =
        NotificationDetails(android: androidNotification, iOS: iosNotification);
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Title : $hours $minutes',
        'Body : body',
        platformNotification,
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Title : $hours $minutes',
        'Body : body',
        platformNotification,
      );
      // ignore: deprecated_member_use
      await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'My daily quotes',
        // 'Test Title at ${time.hour}:${time.minute}.${time.second}',
        'Title : $hours $minutes', //null
        time,
        platformNotification,
        payload: 'Test Payload',
      );
      // ignore: deprecated_member_use
      await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Message Quotes',
          'Message value : $bodyMessage', time, platformNotification);
      for (var i = DateTime.now().day; i <= 30; i++) {
        print('Value : $i');
        var timed = tz.TZDateTime.from(
          DateTime.utc(2021, DateTime.now().month, i, time.hour, time.minute),
          tz.UTC,
        );
        print('On $i:${DateTime.now().month} : $timed');
        try {
          await flutterLocalNotificationsPlugin.zonedSchedule(
              0,
              'Message Quotes',
              'Message value : $bodyMessage',
              timed,
              platformNotification,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
        } catch (e) {
          print('Exception : $e');
        }
      }
      var timeind = tz.TZDateTime.from(
        DateTime.utc(2021, 7, 1, time.hour, time.minute),
        tz.UTC,
      );
      print('On 30:${DateTime.now().month} : $timeind');
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Message Quotes',
            'Message value demo : $bodyMessage', timeind, platformNotification,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      } catch (e) {
        print('Exception : $e');
      }
      var timeing = tz.TZDateTime.from(
        DateTime.utc(2021, 7, 2, time.hour, time.minute),
        tz.UTC,
      );
      print('On 02:${DateTime.now().month} : $timeing');
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Message Quotes',
            'Message value  02 : $bodyMessage', timeing, platformNotification,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      } catch (e) {
        print('Exception : $e');
      }
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Message Quotes',
            'Message value  02 : $bodyMessage', timeing, platformNotification,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      } catch (e) {
        print('Exception : $e');
      }
    }
  }

  timeDialog() async {
    print('Time Dialog method called.!');
    print('Before Change of Time  : $selectedTime');
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        print(selectedTime);
        hours = selectedTime.hour;
        minutes = selectedTime.minute;
      });
    }
    print('After Change of Time  : $selectedTime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: InkWell(
          onTap: timeDialog,
          child: Container(
            height: 50,
            padding: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 0, left: 10, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reminder Notification',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "$hours : $minutes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: status,
                  trackColor: Colors.black,
                  activeColor: Colors.grey,
                  onChanged: (value) {
                    print('During change switch : $selectedTime');
                    print("VALUE : $value");
                    setState(() {
                      status = value;
                    });
                    if (value) {
                      notificationDetails();
                      NotificationService().getNotification(
                        '$hours : $minutes',
                        status,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

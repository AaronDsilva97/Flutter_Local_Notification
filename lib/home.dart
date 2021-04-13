import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettings =
        new InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  tz.TZDateTime _scheduleWeekly10AM() {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.minute,
      10,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(
        const Duration(days: 1),
      );
    }
    return scheduleDate;
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      "channelId",
      "channelName",
      "channelDescription",
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      "Trial",
      "My Body",
      platformChannelSpecifics,
      payload: "This is  notification detail text",
    );
  }

  Future _showNotification5sec() async {
    var scheduleNotificationDateTime =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      "channelId1",
      "channelName1",
      "channelDescription1",
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      "Trial",
      "My Body",
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "This is  notification detail text",
    );
  }

  Future _periodicNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      "channelId2",
      "channelName2",
      "channelDescription2",
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      "Trial",
      "My Body",
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      payload: "This is  notification detail text",
    );
  }

  Future _scheduleWeeklyNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      "channelId3",
      "channelName3",
      "channelDescription3",
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      "Trial",
      "My Body",
      _scheduleWeekly10AM(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "This is  notification detail text",
    );
  }

  Future<void> _showNotificationCustomSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      "channelId4",
      "channelName4",
      "channelDescription4",
      sound: RawResourceAndroidNotificationSound('dogbarking'),
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'custom sound notification title',
      'custom sound notification body',
      platformChannelSpecifics,
    );
  }

  Future _cancelPeriodicNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }

  Future onSelectNotification(String? payload) async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Your notification detail"),
            content: Text("payload : $payload"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: _showNotification,
              child: Text("Trigger Notification Instantly"),
            ),
            ElevatedButton(
              onPressed: _showNotification5sec,
              child: Text("Trigger Notification in 5 seconds"),
            ),
            ElevatedButton(
              onPressed: _periodicNotification,
              child: Text("Periodic Notification every minute"),
            ),
            ElevatedButton(
              onPressed: _scheduleWeeklyNotification,
              child: Text("10 AM Weekly"),
            ),
            ElevatedButton(
              onPressed: _showNotificationCustomSound,
              child: Text("Notification with sound"),
            ),
            ElevatedButton(
              onPressed: _cancelPeriodicNotification,
              child: Text("Cancel Notification"),
            )
          ],
        ),
      ),
    );
  }
}

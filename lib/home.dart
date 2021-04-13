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
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettings =
        new InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
              onPressed: _cancelPeriodicNotification,
              child: Text("Cancel Notification"),
            )
          ],
        ),
      ),
    );
  }
}

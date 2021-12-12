import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlitetry/alarm.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlitetry/pages/add_edit_alarm_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlitetry/sqflite.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Alarm> alarmList = [];
  DateTime _time = DateTime.now();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initDb() async {
    await DbProvider.setDb();
    alarmList = await DbProvider.getData();
    setState(() {});
  }

  Future<void> reBuild() async {
    alarmList = await DbProvider.getData();
    alarmList.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
    setState(() {});
  }

  void initializeNotification() {
    _flutterLocalNotificationsPlugin.initialize(InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: IOSInitializationSettings(),
    ));
  }

  void setNotification(int id, DateTime alarmTime) {
    _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "アラーム",
        '時間になりました。',
        tz.TZDateTime.from(alarmTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails('id', 'name',
              importance: Importance.max, priority: Priority.high),
          iOS: IOSNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  void notification() async {
    await _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher'),
        iOS: IOSInitializationSettings(),
      ),
    );
    _flutterLocalNotificationsPlugin.show(
        1,
        'アラーム',
        "時間になりました。",
        NotificationDetails(
          android: AndroidNotificationDetails('id', 'name',
              importance: Importance.max, priority: Priority.high),
          iOS: IOSNotificationDetails(),
        ));
  }

  @override
  void initState() {
    super.initState();
    initDb();
    initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    // Flutter_Slidable 1.0.0 not implement controller? not controll exclusive?
    // SlidableController _slidableController = SlidableController(this);
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Colors.black,
            largeTitle: Text(
              "アラーム",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: GestureDetector(
                child: Icon(Icons.add, color: Colors.orange),
                onTap: () async {
                  Alarm result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddEditAlarmPage(alarmList: alarmList)));
                  if (result != null) {
                    reBuild();
                    setNotification(result.id, result.alarmTime);
                  }
                  // setState(() {
                  //   alarmList
                  //       .sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
                  // });
                }),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Alarm alarm = alarmList[index];
                return Column(
                  children: [
                    if (index == 0)
                      Divider(
                        color: Colors.grey,
                        height: 1,
                      ),
                    Slidable(
                      endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          icon: Icons.delete,
                          label: "削除",
                          backgroundColor: Colors.red,
                          onPressed: (context) async {
                            await DbProvider.deleteData(alarm.id);
                            reBuild();
                          },
                        )
                      ]),
                      child: ListTile(
                        title: Text(
                          DateFormat("H:mm").format(alarm.alarmTime),
                          style: TextStyle(color: Colors.white, fontSize: 50),
                        ),
                        trailing: CupertinoSwitch(
                            value: alarm.isActive,
                            onChanged: (newValue) async {
                              alarm.isActive = newValue;
                              await DbProvider.updateData(alarm);
                              reBuild();
                            }),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEditAlarmPage(
                                      alarmList: alarmList, index: index)));
                          reBuild();
                          // setState(() {
                          //   alarmList.sort(
                          //       (a, b) => a.alarmTime.compareTo(b.alarmTime));
                          // });
                        },
                      ),
                    ),
                    Divider(color: Colors.grey, height: 0),
                  ],
                );
              },
              childCount: alarmList.length,
            ),
          ),
        ],
      ),
    );
  }
}

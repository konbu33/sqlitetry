import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlitetry/alarm.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sqlitetry/pages/add_edit_alarm_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Alarm> alarmList = [];

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
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddEditAlarmPage(alarmList: alarmList)));
                  setState(() {
                    alarmList
                        .sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
                  });
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
                          onPressed: (context) {
                            alarmList.removeAt(index);
                            setState(() {});
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
                            onChanged: (newValue) {
                              setState(() {
                                alarm.isActive = newValue;
                              });
                            }),
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEditAlarmPage(
                                      alarmList: alarmList, index: index)));
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

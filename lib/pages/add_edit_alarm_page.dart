import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlitetry/alarm.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlitetry/sqflite.dart';

class AddEditAlarmPage extends StatefulWidget {
  AddEditAlarmPage({Key? key, required this.alarmList, this.index})
      : super(key: key);

  List<Alarm> alarmList;
  final int? index;
  @override
  _AddEditAlarmPageState createState() => _AddEditAlarmPageState();
}

class _AddEditAlarmPageState extends State<AddEditAlarmPage> {
  TextEditingController _controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void initEditAlarm() {
    if (widget.index != null) {
      selectedDate = widget.alarmList[widget.index!].alarmTime;
      _controller.text = DateFormat("H:mm").format(selectedDate);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initEditAlarm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "アラーム追加",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        leadingWidth: 100,
        leading: GestureDetector(
          child: Container(
              alignment: Alignment.center,
              child: Text(
                "キャンセル",
                style: TextStyle(color: Colors.orange),
              )),
          onTap: () => Navigator.pop(context),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              Alarm alarm = Alarm(
                  alarmTime: DateTime(
                      2000, 1, 1, selectedDate.hour, selectedDate.minute));
              if (widget.index != null) {
                alarm.id = widget.alarmList[widget.index!].id;
                await DbProvider.updateData(alarm);
              } else {
                await DbProvider.insertData(alarm);
              }
              // setState(() {});
              widget.alarmList
                  .sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text(
                "保存",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("時間", style: TextStyle(color: Colors.white)),
                  Container(
                    width: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
                      readOnly: true,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return CupertinoDatePicker(
                              initialDateTime: selectedDate,
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (newDate) {
                                // print("${newDate.toString()}");
                                String time =
                                    DateFormat("H:mm").format(newDate);
                                // print("${time.toString()}");
                                // print("${_controller.value.toString()}");
                                selectedDate = newDate;
                                _controller.text = time;
                                setState(() {});
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

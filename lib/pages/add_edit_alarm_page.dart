import 'package:flutter/material.dart';

class AddEditAlarmPage extends StatefulWidget {
  const AddEditAlarmPage({Key? key}) : super(key: key);

  @override
  _AddEditAlarmPageState createState() => _AddEditAlarmPageState();
}

class _AddEditAlarmPageState extends State<AddEditAlarmPage> {
  TextEditingController _controller = TextEditingController();
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
            onTap: () => Navigator.pop(context),
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
                      onTap: () {},
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

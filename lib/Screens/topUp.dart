import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:durianmeter/Models/creditModel.dart';

class TopUpScreen extends StatefulWidget {
  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  List<Credit> credits = Credit.getCredit();

  bool _value = false;
  int val = -1;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).copyWith().size.height;
    double _width = MediaQuery.of(context).copyWith().size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.teal),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'เติมเครดิต',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          height: _height,
          width: _width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text('CREDIT : 35/TIMES'),
                ),
                Container(
                  color: Colors.black54,
                  height: 0.5,
                ),
                Column(
                  children: [
                    ListTile(
                      title: Text("15฿"),
                      subtitle: Text("เติม 30 เครดิต"),
                      leading: Radio(
                        value: 1,
                        groupValue: val,
                        onChanged: (value) {
                          setState(() {
                            _value = true;
                            String a = value.toString();
                            val = int.parse(a);
                            print(val);
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                    ),
                    ListTile(
                      title: Text("30฿"),
                      subtitle: Text("เติม 60 เครดิต"),
                      leading: Radio(
                        value: 2,
                        groupValue: val,
                        onChanged: (value) {
                          setState(() {
                            _value = true;
                            String a = value.toString();
                            val = int.parse(a);
                            print(val);
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                    ),
                    ListTile(
                      title: Text("45฿"),
                      subtitle: Text("เติม 90+5 เครดิต"),
                      leading: Radio(
                        value: 3,
                        groupValue: val,
                        onChanged: (value) {
                          setState(() {
                            _value = true;
                            String a = value.toString();
                            val = int.parse(a);
                            print(val);
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                    ),
                    ListTile(
                      title: Text("60฿"),
                      subtitle: Text("เติม 120+12 เครดิต"),
                      leading: Radio(
                        value: 4,
                        groupValue: val,
                        onChanged: (value) {
                          setState(() {
                            _value = true;
                            String a = value.toString();
                            val = int.parse(a);
                            print(val);
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: _value ? Colors.teal : Colors.white, // background
                    onPrimary: _value ? Colors.white : Colors.black,
                    // foreground
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: _width,
                    child: Text(
                      'ยืนยัน',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  onPressed: () {
                    if (val != -1) {
                      print('เติมได้');
                    } else {
                      print('เติมไม่ได้');
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}

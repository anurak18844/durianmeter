import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:durianmeter/Screens/spashSccreen.dart';
import 'package:flutter/material.dart';

import 'homeTabs.dart';

class NullScreen extends StatefulWidget {
  @override
  _NullScreenState createState() => _NullScreenState();
}

class _NullScreenState extends State<NullScreen> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).copyWith().size.height;
    double _width = MediaQuery.of(context).copyWith().size.width;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(5),
          height: _height,
          width: _width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'DURIANMETER',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ],
          )),
    );
  }
}

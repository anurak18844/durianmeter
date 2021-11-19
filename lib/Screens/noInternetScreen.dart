import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:durianmeter/Screens/spashSccreen.dart';
import 'package:flutter/material.dart';

import 'homeTabs.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
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
              // Text(
              //   'DURIANMETER',
              //   style: TextStyle(
              //       fontSize: 30,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.teal),
              // ),
              Image(
                image: AssetImage('assets/logo.png'),
                width: _width * 0.8,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Your device is not connected with internet.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                  child: Text('Retry'),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return SpashScreen();
                    }));
                  })
            ],
          )),
    );
  }
}

import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:durianmeter/Screens/loginScreen.dart';
import 'package:flutter/material.dart';

import 'homeTabs.dart';
import 'noInternetScreen.dart';

class SpashScreen extends StatefulWidget {
  @override
  _SpashScreenState createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() async {
    if (await checkInternet()) {
      //open app
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      });
    }
    if (await checkInternet() == false) {
      Timer(Duration(seconds: 4), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return NoInternetScreen();
        }));
      });
    }
  }

  Future<bool> checkInternet() async {
    var connectivityReult = await (Connectivity().checkConnectivity());
    if (connectivityReult == ConnectivityResult.mobile ||
        connectivityReult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).copyWith().size.height;
    double _width = MediaQuery.of(context).copyWith().size.width;
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(5),
      child: FutureBuilder(
        future: checkInternet(),
        builder: (BuildContext c, snap) {
          if (snap.data == null || snap.data == false || snap.data == true) {
            return Container(
                color: Colors.white,
                height: _height,
                width: _width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/logo.png'),
                      width: _width * 0.8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(
                      color: Colors.teal,
                    )
                  ],
                ));
          } else {
            return Column(
              children: [
                Text(
                  'Ohh. has error!!',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue),
                ),
              ],
            );
          }
        },
      ),
    ));
  }
}

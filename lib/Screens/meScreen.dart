import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginScreen.dart';

class MeScreenPage extends StatefulWidget {
  const MeScreenPage({Key? key}) : super(key: key);

  @override
  _MeScreenPageState createState() => _MeScreenPageState();
}

class _MeScreenPageState extends State<MeScreenPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {

              },
            )
          ],
        ),
      ),
    );
  }
}

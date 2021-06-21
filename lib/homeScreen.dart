import 'package:durianmeter/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;
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
            Text(
              '${auth.currentUser?.email}',
              style: TextStyle(fontSize: 20.0),
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                auth.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}

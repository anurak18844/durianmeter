import 'package:durianmeter/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'audioPredict.dart';

class HomeMenuPage extends StatefulWidget {
  const HomeMenuPage({Key? key}) : super(key: key);

  @override
  _HomeMenuPageState createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> {

  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: Text('Home Page'),
    //   ),
    //   body: Center(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           '${auth.currentUser?.email}',
    //           style: TextStyle(fontSize: 20.0),
    //         ),
    //         ElevatedButton(
    //           child: Text('Logout'),
    //           onPressed: () {
    //             auth.signOut();
    //             Navigator.pushReplacement(context,
    //                 MaterialPageRoute(builder: (context) {
    //               return LoginScreen();
    //             }));
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    // );
    var _sizedIcon = 60.0;
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 50.0, left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.accessible_forward_outlined,color: Colors.green,
                size: 120.0,
              ),
              SizedBox(height: 15.0,),
              Text('Durian Meter Application',style: TextStyle(fontSize: 20.0,color: Colors.black),textAlign: TextAlign.center,),
              Text('t is a long by theLorem Ipsum is that it has a more-o.',style: TextStyle(fontSize: 15.0,color: Colors.black54),textAlign: TextAlign.center,),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 30.0,
                                    offset: Offset(5, 5)
                                )
                              ]
                          ),
                          child: GestureDetector(
                            child: Icon(Icons.account_circle_outlined,size: _sizedIcon,color: Colors.blue,),
                            onTap: (){
                              print('Tap Account');
                            },
                          )

                      ),
                      SizedBox(height: 15.0,),
                      Text('Profile.')
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 30.0,
                                    offset: Offset(5, 5)
                                )
                              ]
                          ),
                          child: GestureDetector(
                            child: Icon(Icons.multitrack_audio_outlined,size: _sizedIcon,color: Colors.green,),
                            onTap: (){
                              print('Tap Audio');
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return AudioPredict();
                              }));
                            },
                          )
                      ),
                      SizedBox(height: 15.0,),
                      Text('Record Audio.')
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 30.0,
                                    offset: Offset(5, 5)
                                )
                              ]
                          ),
                          child: GestureDetector(
                            child: Icon(Icons.location_on_outlined,size: _sizedIcon,color: Colors.red,),
                            onTap: (){
                              print('Tap Location');
                            },
                          )
                      ),
                      SizedBox(height: 15.0,),
                      Text('Durian shop near me.')
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 30.0,
                                    offset: Offset(5, 5)
                                )
                              ]
                          ),
                          child: GestureDetector(
                            child: Icon(Icons.settings_outlined,size: _sizedIcon,color: Colors.black,),
                            onTap: (){
                              print('Tap Setting');
                            },
                          )
                      ),
                      SizedBox(height: 15.0,),
                      Text('Setting Accout.')
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
  }
}

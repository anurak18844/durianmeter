import 'package:durianmeter/Screens/audioPredictOnly.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Screens/audioPredict.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Durain Meter',
      home: AudioPredict(),
    );
  }
}

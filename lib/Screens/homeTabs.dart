import 'package:durianmeter/Screens/audioPredict.dart';
import 'package:durianmeter/Screens/homeScreen.dart';
import 'package:durianmeter/Screens/datasetScreen.dart';
import 'package:durianmeter/Screens/nullScreen.dart';
import 'package:durianmeter/Screens/qrScanner.dart';
import 'package:flutter/material.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({Key? key}) : super(key: key);

  @override
  _HomeTabsState createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).copyWith().size.width;
    double height = MediaQuery.of(context).copyWith().size.height;
    Color colorTeal = Colors.teal;
    Color colorWhiteShade = Colors.white60;
    double fontSize = 10;
    Color colorBlackShade = Colors.black26;

    return Scaffold(
        body: TabBarView(
          children: [
            //DatasetScreen(),
            HomeScreen(),
            AudioPredictScreen(),
            NullScreen(),
          ],
          controller: _controller,
        ),
        bottomNavigationBar: Container(
            height: 75,
            child: DefaultTabController(
              length: 3,
              child: TabBar(
                indicatorColor: colorTeal,
                unselectedLabelColor: Colors.black26,
                labelColor: colorTeal,
                controller: _controller,
                tabs: [
                  Tab(
                    child: Text(
                      'HOME',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    child: Text(
                      'PREDICT',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    icon: Icon(Icons.mic_none_rounded),
                  ),
                  Tab(
                    child: Text(
                      'SETTING',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    icon: Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: colorBlackShade,
                  offset: Offset(-3, 0),
                  blurRadius: 4,
                  spreadRadius: 1)
            ])));
  }
}

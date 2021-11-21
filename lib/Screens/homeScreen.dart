import 'package:durianmeter/Models/authResponse.dart';
// import 'package:durianmeter/Models/authUser.dart';
import 'package:durianmeter/Network/restApi.dart';
import 'package:durianmeter/Screens/qrScanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utils/globalVariables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // AuthUser user = AuthUser();
  late AuthUserResponse? authRsp = AuthUserResponse(id: 1, recentDurians: []);

  @override
  void initState() {
    CallApi().getAuthUser(userId).then((resp) {
      setState(() {
        authRsp!.email = resp?.email;
        authRsp!.firstname = resp?.firstname;
        authRsp!.id = resp!.id;
        authRsp!.lastname = resp.lastname;
        authRsp!.quota = resp.quota;
        authRsp!.tel = resp.tel;
        authRsp!.username = resp.username;
        authRsp!.recentDurians = resp.recentDurians;

        print(resp.recentDurians[0].id);
        print(resp.recentDurians[0].maturityScore);
        print(resp.recentDurians[0].createdOn);
        print(resp.recentDurians[0].locationLat);
        print(resp.recentDurians[0].locationLng);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).copyWith().size.height;
    double _width = MediaQuery.of(context).copyWith().size.width;
    // return FutureBuilder(
    //   future: CallApi().getAuthUser(userId),
    //   builder: (BuildContext ctx, AsyncSnapshot snapshot) {

    //   },
    // );
    return Scaffold(
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF009688), Color(0xFF3d85c6)]),
            ),
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            height: _height,
            width: _width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _showProfile(),
                  SizedBox(
                    height: 10,
                  ),
                  _menu(),
                  SizedBox(
                    height: 10,
                  ),
                  _headHistory(),
                  Column(
                    children: authRsp!.recentDurians.map(
                      (rd) {
                        return _showHistory(rd);
                      },
                    ).toList(),
                  ),
                  _tailHistory(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _menu() {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.0), topRight: Radius.circular(3.0)),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 30, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เครดิตคงเหลือ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                width: 100,
                child: Row(
                  children: [
                    Text('${authRsp!.quota}'),
                    Image(
                      image: AssetImage('assets/logoicon.png'),
                      width: 35,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: 0.5,
          color: Colors.black54,
        ),
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3.0),
                bottomRight: Radius.circular(3.0)),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 30, right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เติมเครดิต',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.teal,
                  size: 38,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRScannerScreen()));
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _showProfile() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(3.0)),
      height: 100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
          radius: 30,
        ),
        trailing: Icon(
          Icons.settings,
          color: Colors.teal,
          size: 35,
        ),
        title: Text(
          '${authRsp!.username}',
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          '${authRsp!.email}',
          style: TextStyle(color: Colors.black87),
        ),
        isThreeLine: false,
        onTap: () {
          print('Tap Tap!');
        },
      ),
    );
  }

  Widget _showHistory(RecentDurian rd) {
    return rd.maturityScore == 0
        ? Container(
            height: 0,
          )
        : Container(
            height: 80,
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(top: BorderSide(width: 0.5, color: Colors.black54))),
            // padding: EdgeInsets.all(4.0),
            child: ListTile(
              leading: Container(
                alignment: Alignment.center,
                width: 60,
                height: 60,
                child: _textColorMaturity(rd.maturityScore),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios_outlined, color: Colors.black87),
              title: Text(
                'Location : ${rd.locationLat} : ${rd.locationLng}',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              subtitle: Text(
                'วันที่ : ${DateFormat("dd-MM-yyy hh:mm:ss").format(rd.createdOn)}',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              onTap: () {
                print('Tap Taps');
              },
            ),
          );
  }

  Widget _headHistory() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3.0), topRight: Radius.circular(3.0)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 30, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Prediction',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Text(
          //   'ALL',
          //   style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          // )
        ],
      ),
    );
  }

  Widget _tailHistory() {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(3.0),
            bottomRight: Radius.circular(3.0)),
        color: Colors.white,
      ),
    );
  }

  Widget _textColorMaturity(int? score) {
    Color c = Colors.teal;
    switch (score) {
      case 70:
        {
          c = Colors.teal;
          break;
        }
      case 75:
        {
          c = Color.fromARGB(255, 0, 150, 92);
          break;
        }
      case 80:
        {
          c = Color.fromARGB(255, 0, 150, 67);
          break;
        }
      case 85:
        {
          c = Color.fromARGB(255, 0, 150, 32);
          break;
        }
      case 85:
        {
          c = Color.fromARGB(255, 30, 150, 0);
          break;
        }
      case 90:
        {
          c = Color.fromARGB(255, 72, 150, 0);
          break;
        }
      case 95:
        {
          c = Color.fromARGB(255, 109, 167, 2);
          break;
        }
      case 100:
        {
          c = Color.fromARGB(255, 231, 228, 6);
        }
    }
    return Text(
      '${score}%',
      style: TextStyle(fontSize: 24, color: c, fontWeight: FontWeight.bold),
    );
  }
}

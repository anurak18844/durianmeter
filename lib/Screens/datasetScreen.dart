import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:durianmeter/Models/DatasetRequest.dart';
import 'package:durianmeter/Models/PredictResponse.dart';
import 'package:durianmeter/Network/restApi.dart';
import 'package:durianmeter/Screens/MaturityButton.dart';
import 'package:durianmeter/Screens/send_request.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/predictRequest.dart';

class DatasetScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  DatasetScreen({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _DatasetScreenState createState() => _DatasetScreenState();
}

class _DatasetScreenState extends State<DatasetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Pridict'),
          backgroundColor: Color(0xFF4CAF50),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: SafeArea(
        child: new RecorderExample(),
      ),
    );
  }
}

class RecorderExample extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  RecorderExample({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => new RecorderExampleState();
}

class RecorderExampleState extends State<RecorderExample> {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  Recording? current;
  var _chkRecord = false;
  int _maturityScore = 0;
  var _requestFile;
  var _chkRecordAudio = false;
  var _chkSelectScore = false;
  int count = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    List maturityList = [
      { "matScore": 70, "color": Color(0xFFFFFDE7) },
      { "matScore": 75, "color": Color(0xFFFFF9C4) },
      { "matScore": 80, "color": Color(0xFFFFF59D) },
      { "matScore": 85, "color": Color(0xFFFFF176) },
    ];
    List maturityList2 = [
      { "matScore": 90, "color": Color(0xFFFFCA28) },
      { "matScore": 95, "color": Color(0xFFFFB300) },
      { "matScore": 100, "color": Color(0xFFFFA000) },
    ];
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: new Column(children: <Widget>[
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  // Container(
                  //   child: Icon(
                  //     Icons.file_copy_outlined,
                  //     color: Colors.green,
                  //     size: 150.0,
                  //   ),
                  // ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('${count}',style: TextStyle(fontSize: 70),),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_chkRecordAudio ?
                            Icons.check_box : Icons.check_box_outline_blank  ,
                            color: Colors.green,
                            size: 35.0,
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Record Audio.',
                          style: TextStyle(fontSize: 40.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_chkSelectScore ?
                            Icons.check_box:  Icons.check_box_outline_blank,
                            color: Colors.green,
                            size: 35.0,
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          'Select Score.',
                          style: TextStyle(fontSize: 40.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  ElevatedButton(
                    onPressed: () {
                    setState(() {
                      count = 0;
                    });
                    },
                    child: Text('Recount',style: TextStyle(fontSize: 40.0),),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.green,
                        )),
                  ),
                ],
              ),
              height: 300.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 30.0,
                        offset: Offset(5, 5))
                  ]),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              height: 70.0,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton(
                onPressed: () {
                  print("Status after pressed");
                  print(_currentStatus);
                  //Check mode
                  switch (_currentStatus) {
                    case RecordingStatus.Initialized:
                      {
                        _start();
                        break;
                      }
                    case RecordingStatus.Recording:
                      {
                        _stop();
                        _init();
                        setState(() {
                          _chkRecordAudio = true;
                        });
                        break;
                      }
                    // case RecordingStatus.Stopped:
                    //   {
                    //
                    //
                    //     break;
                    //   }
                    default:
                      break;
                  }
                },
                child: _buildText(_currentStatus),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green,
                )),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for(var m in maturityList)
                    MaturityButton(
                      maturityScore: m['matScore'],
                      color: m['color'],
                      onPress: () {
                        Fluttertoast.showToast(
                          msg: 'SELECT ${m['matScore']} SCORE!!!!',
                          gravity: ToastGravity.CENTER,
                        );
                        setState(() {
                          _maturityScore=m['matScore'];
                          _chkSelectScore = true;
                        });
                      },
                    ),
                    // Container(
                  //   height: 70.0,
                  //   width: 65.0,
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: ElevatedButton(
                  //     onPressed: (){
                  //       print("5555555");
                  //     },
                  //     child: Text(
                  //       '70%',
                  //       style: TextStyle(fontSize: 15.0, color: Colors.black),
                  //     ),
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color?>(
                  //       Colors.yellow[50],
                  //     )),
                  //   ),
                  // ),
                  // Container(
                  //   height: 70.0,
                  //   width: 65.0,
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: ElevatedButton(
                  //     onPressed: (){
                  //       print("5555555");
                  //     },
                  //     child: Text(
                  //       '75%',
                  //       style: TextStyle(fontSize: 15.0, color: Colors.black),
                  //     ),
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color?>(
                  //       Colors.yellow[100],
                  //     )),
                  //   ),
                  // ),
                  // Container(
                  //   height: 70.0,
                  //   width: 65.0,
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: ElevatedButton(
                  //     onPressed: (){
                  //       print("5555555");
                  //     },
                  //     child: Text(
                  //       '80%',
                  //       style: TextStyle(fontSize: 15.0, color: Colors.black),
                  //     ),
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color?>(
                  //       Colors.yellow[200],
                  //     )),
                  //   ),
                  // ),
                  // Container(
                  //   height: 70.0,
                  //   width: 65.0,
                  //   padding: const EdgeInsets.only(top: 8.0),
                  //   child: ElevatedButton(
                  //     onPressed: (){
                  //       print("5555555");
                  //     },
                  //     child: Text(
                  //       '85%',
                  //       style: TextStyle(fontSize: 15.0, color: Colors.black),
                  //     ),
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all<Color?>(
                  //       Colors.yellow[300],
                  //     )),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for(var m in maturityList2)
                    MaturityButton(
                      maturityScore: m['matScore'],
                      color: m['color'],
                      onPress: () {
                        Fluttertoast.showToast(
                          msg: 'SELECT ${m['matScore']} SCORE!!!!',
                          gravity: ToastGravity.CENTER,
                        );
                        setState(() {
                          _maturityScore=m['matScore'];
                          _chkSelectScore = true;
                        });
                      },
                    ),
                  Container(
                    width: 65.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 50.0,
                        color: Colors.yellow[900],
                      ),
                      onPressed: () {
                        _sendDatasetRequest();
                        setState(() {
                          _chkRecordAudio = false;
                          _chkSelectScore = false;
                          count++;
                          // Fluttertoast.showToast(
                          //   msg: 'SEND DATA!!',
                          //   gravity: ToastGravity.CENTER,
                          // );
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  _init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;

      if (hasPermission) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString()+"_"+(count+1).toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.AAC);

        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder!.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder!.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder!.stop();
    print("Stop recording: ${result!.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    _requestFile = file;
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
   onPlayAudio();
    // PredictRequest p = PredictRequest(
    //     userId: "1",
    //     knockSound: file,
    //     locationLat: "7444444",
    //     locationLong: "8787878");
    // CallApi().getPrediction(p).then((resp) {
    //   print("Here I am!!!!!!!");
    //   print(resp!.maturityScore.toString());
    // }
    // );
    print("After stopped");
    print(_currentStatus);
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Unset:{
        text = "Preparing...";
        break;
      }
      case RecordingStatus.Initialized:
      case RecordingStatus.Stopped:
        {
          text = 'START';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'STOP';
          break;
        }
    }
    return Text(text, style: TextStyle(color: Colors.white, fontSize: 40.0));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current!.path!, isLocal: true);
  }

  void _sendDatasetRequest() {
      DatasetRequest dataset = DatasetRequest(
          knockSound: _requestFile,
          maturityScore: _maturityScore,
      );
      CallApi().getDatasetResponse(dataset).then((resp) {
        Fluttertoast.showToast(
          msg: 'SET MATURITY SCORE : ${resp!.maturityScore.toString()}',
          gravity: ToastGravity.CENTER,
        );
        print("Here I am!!!!!!!");
        print(resp!.maturityScore.toString());
      });
  }
}

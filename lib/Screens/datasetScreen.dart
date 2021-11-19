import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:durianmeter/Models/DatasetRequest.dart';
import 'package:durianmeter/Models/PredictResponse.dart';
import 'package:durianmeter/Network/restApi.dart';
import 'package:durianmeter/Screens/send_request.dart';
import 'package:durianmeter/Utils/globalVariables.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/predictRequest.dart';
import 'Utils/Slider/sliderForResponse.dart';
import 'Utils/globalVariable.dart';

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

class RecorderExampleState extends State<RecorderExample> with SingleTickerProviderStateMixin {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  Recording? current;
  var predictData = '0%';
  var record = true;
  var statusText = "กำลังรอรับเสียง";
  var firstPredict = true;
  var _requestFile;
  var waitSend = true;
  int testi = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).copyWith().size.width;
    return new Center(
      child: new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 0,bottom: 20,left: 10),
                width: _width,
                child: Text('ค่าความสุกที่ทำนายได้',style: TextStyle(color: Colors.black54,fontSize: 14),textAlign: TextAlign.start,),
              ),
              SliderForResponse(),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Text(
                  "สถานะ : " + statusText,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                width: 270,
                height: 75,
                child: RaisedButton(
                  onPressed: () {
                    if(waitSend){
                      setState(() {
                        record = !record;
                      });
                      switch (_currentStatus) {
                        case RecordingStatus.Initialized:
                          {
                            _start();
                            break;
                          }
                        case RecordingStatus.Recording:
                          {
                            _stop();
                            setState(() {
                              waitSend =! waitSend;
                            });
                            _init();
                            break;
                          }
                        default:
                          break;
                      }
                    }
                  },
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: waitSend ? Colors.teal : Colors.black54,
                        border: Border.all(color: Colors.teal, width: 1)),
                    child: Container(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: 60.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: 50,
                              child: Icon(
                                record
                                    ? Icons.fiber_manual_record_rounded
                                    : Icons.stop,
                                color: Colors.white,
                                size: 40,
                              )),
                          Container(
                              alignment: Alignment.center,
                              width: 150,
                              child: Text(
                                record ? "RECORD" : "STOP",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: 270,
                height: 75,
                child: RaisedButton(
                  onPressed: () {
                    if(!waitSend){
                      setState(() {
                        waitSend = !waitSend;
                      });
                      _sendDatasetRequest();
                    }
                    // switch (_currentStatus) {
                    //   case RecordingStatus.Initialized:
                    //     {
                    //       _start();
                    //       break;
                    //     }
                    //   case RecordingStatus.Recording:
                    //     {
                    //       _stop();
                    //       setState(() {
                    //         firstPredict = false;
                    //       });
                    //       _init();
                    //       break;
                    //     }
                    //   default:
                    //     break;
                    // }
                  },
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: waitSend ? Colors.black54 : Colors.teal,
                        border: Border.all(color: Colors.teal, width: 1)),
                    child: Container(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: 60.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: 50,
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 35,
                              )),
                          Container(
                              alignment: Alignment.center,
                              width: 150,
                              child: Text(
                               "SEND DATA",
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }



  _init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;

      if (hasPermission) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;

        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

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
    setState(() {
      statusText = "กำลังบันทึกเสียง..";
    });
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
        print(current!.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    setState(() {
      statusText = "กำลังประมวลผล..";
    });
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
    PredictRequest p = PredictRequest(
      userId: "1",
      knockSound: file,
      locationLat: "7444444",
      locationLong: "8787878",
    );

    CallApi().getPrediction(p).then((resp) {
      setState(() {
        statusText = "รอการเซ็ตและส่งข้อมูล";
      });
      print("Here I am!!!!!!!");
      print(resp!.maturityScore.toString());
      if (resp.maturityScore == null) {
        setState(() {
          predictData = 'NULL';
          indexTopForShow = 0;
          Fluttertoast.showToast(
            msg: predictData,
            gravity: ToastGravity.CENTER,
          );
        });
      } else {
        setState(() {
          predictData = resp.maturityScore.toString() + "%";
          maturityScore = resp.maturityScore!;
          indexTopForShow = toIndex(resp.maturityScore!.toInt());
          Fluttertoast.showToast(
            msg: predictData,
            gravity: ToastGravity.CENTER,
          );
        });
      }
    });
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current!.path!, isLocal: true);
  }


  void _sendDatasetRequest() {
    DatasetRequest dataset = DatasetRequest(
      knockSound: _requestFile,
      maturityScore: maturityScore,
      no : 0,
      // do_prediction: null,
    );

    CallApi().getDatasetResponse(dataset).then((resp) {

      // setState(() {
      //   icheckToast = resp.predictMaturityScore ?? 40;
      //   indexTopForShow = toIndex(icheckToast);
      // });
      if(resp!.maturityScore == null){
        Fluttertoast.showToast(
          msg: "Set : ${resp.maturityScore}, SUCESS!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
        );
        print("THIS IS SET : " + resp.maturityScore.toString());
      } else{
        Fluttertoast.showToast(
          msg: "Set : ${resp.maturityScore}, SUCESS!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
        );
      }
      print('Index for show : '+ indexTopForShow.toString());
      setState(() {
        indexTopForShow = 0;
        maturityScore = 50;
        statusText = "บักทึกข้อมูลสำเร็จ";
      });
    });
  }

  int toIndex(int i){
    if(i==50){
      return 0;
    }
    else if(i==55){
      return 1;
    }
    else if(i==60){
      return 2;
    }
    else if(i==65){
      return 3;
    }
    else if(i==70){
      return 4;
    }
    else if(i==75){
      return 5;
    }
    else if(i==80){
      return 6;
    }
    else if(i==85){
      return 7;
    }
    else if(i==90){
      return 8;
    }
    else if(i==95){
      return 9;
    }
    else{
      return 10;
    }
  }
  void testStop(){
    setState(() {
      waitSend = !waitSend;
    });
  }
}




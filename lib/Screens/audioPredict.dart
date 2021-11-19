import 'dart:async';
import 'dart:io' as io;
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:durianmeter/Models/PredictResponse.dart';
import 'package:durianmeter/Network/restApi.dart';
import 'package:durianmeter/Screens/send_request.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/predictRequest.dart';

class AudioPredictScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  AudioPredictScreen({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _AudioPredictScreenState createState() => _AudioPredictScreenState();
}

class _AudioPredictScreenState extends State<AudioPredictScreen> {
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

class RecorderExampleState extends State<RecorderExample>
    with SingleTickerProviderStateMixin {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  Recording? current;
  var predictData = '0%';
  var record = true;
  var statusText = "กำลังรอรับเสียง";
  var firstPredict = true;

  AnimationController? progressController;
  Animation<double>? animation;
  double maturityValue = 0;
  double valueStart = 100;

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0, end: 0).animate(progressController!)
      ..addListener(() {
        setState(() {});
      });
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
              CustomPaint(
                foregroundPainter: CircleProgress(animation!.value),
                child: Container(
                  width: 300,
                  height: 300,
                  child: Center(
                      child: Text(
                    "${animation!.value.toInt()}%",
                    style: TextStyle(color: Colors.teal, fontSize: 24),
                  )),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              buildDescription(_width, maturityValue, firstPredict),
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
                width: 300,
                height: 75,
                child: RaisedButton(
                  onPressed: () {
                    progressController!.reverse();
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
                            firstPredict = false;
                          });
                          _init();
                          break;
                        }
                      default:
                        break;
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF66BB6A),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(80.0)),
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
                                color: Colors.redAccent,
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
              )
            ]),
      ),
    );
  }

  Widget buildDescription(
      double _width, double maturityValue, bool firstPrecit) {
    if (firstPredict) {
      return Container(
          child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                ),
                Container(
                  height: 26,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  width: _width * .1,
                  child: Icon(
                    Icons.arrow_right,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                  child: Text("${maturityValue.toInt()}% : Not predict.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                ),
                Container(
                  height: 26,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
        ],
      ));
    } else if (maturityValue <= 0 || maturityValue == 5) {
      return Container(
          child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                ),
                Container(
                  height: 26,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                  child: Icon(
                    Icons.arrow_right,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                  child: Text(
                      "${maturityValue.toInt()}% : ${_buildDescriptionText(maturityValue)}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                ),
                Container(
                  height: 26,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .6,
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
        ],
      ));
    } else {
      return Container(
          child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                ),
                Container(
                  height: 26,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                  child: Text(
                      "${maturityValue.toInt() - 5}% : ${_buildDescriptionText(maturityValue - 5)}",
                      style: TextStyle(fontSize: 16, color: Colors.black54)),
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                  child: Icon(
                    Icons.arrow_right,
                    size: 40,
                    color: Colors.teal,
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                  child: Text(
                      "${maturityValue.toInt()}% : ${_buildDescriptionText(maturityValue)}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: _width * .1,
                ),
                Container(
                  height: 26,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  alignment: Alignment.center,
                  width: _width * .7,
                  child: Text(
                      "${maturityValue.toInt() + 5}% : ${_buildDescriptionText(maturityValue + 5)}",
                      style: TextStyle(fontSize: 16, color: Colors.black54)),
                ),
                Container(
                  width: _width * .1,
                ),
              ],
            ),
          ),
        ],
      ));
    }
  }

  String _buildDescriptionText(double maturityValue) {
    String message = '';
    if (maturityValue <= 0 || maturityValue == 5) {
      message = "Can't predict try again.";
    } else {
      switch (maturityValue.toInt()) {
        //case 0: {message = "Can't predct try again.";}break;
        case 70:
          {
            message = "สุกแข็ง";
          }
          break;
        case 75:
          {
            message = "สุกห่าม";
          }
          break;
        case 80:
          {
            message = "สุกกรอบนอกนุ่มใน";
          }
          break;
        case 85:
          {
            message = "สุกนิ่ม";
          }
          break;
        case 90:
          {
            message = "สุกนิ่มมาก";
          }
          break;
        case 95:
          {
            message = "สุกเนื้อเริ่มเหลว";
          }
          break;
        case 100:
          {
            message = "สุกเนื้อเหลว";
          }
          break;
        default:
          {
            message = "ดิบ";
          }
          break;
      }
    }
    return message;
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
        statusText = "ประมวลผลเสร็จสิ้น";
      });
      print("Here I am!!!!!!!");
      print(resp!.maturityScore.toString());
      if (resp.maturityScore == null) {
        setState(() {
          maturityValue = 0;
          predictData = 'NULL';
          Fluttertoast.showToast(
            msg: predictData,
            gravity: ToastGravity.CENTER,
          );
        });
      } else {
        setState(() {
          predictData = resp.maturityScore.toString() + "%";
          maturityValue = resp.maturityScore!.toDouble();
          animation = Tween<double>(begin: 0, end: maturityValue)
              .animate(progressController!)
            ..addListener(() {
              setState(() {});
            });
          progressController!.forward();
          Fluttertoast.showToast(
            msg: predictData,
            gravity: ToastGravity.CENTER,
          );
        });
      }
    });
    print("After stopped");
    print(_currentStatus);
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current!.path!, isLocal: true);
  }
}

class CircleProgress extends CustomPainter {
  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = Colors.teal
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 7;

    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'dart:async';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:durianmeter/Network/restApi.dart';
import 'package:durianmeter/Utils/Progress/proGress.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Models/predictRequest.dart';

class AudioPredictOnly extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  AudioPredictOnly({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _AudioPredictOnlyState createState() => _AudioPredictOnlyState();
}

class _AudioPredictOnlyState extends State<AudioPredictOnly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularProgress(),
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
  var predictData = '0%';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              predictData,
              style: TextStyle(fontSize: 150.0),
            ),
            height: 500.0,
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
                      break;
                    }
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
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
        _recorder =
            FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.AAC);

        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        print(current);

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
        locationLong: "8787878");
    CallApi().getPrediction(p).then((resp) {
      print("Here I am!!!!!!!");
      print(resp!.maturityScore.toString());
      if (resp.maturityScore == null) {
        setState(() {
          predictData = 'Null.';
          Fluttertoast.showToast(
            msg: predictData,
            gravity: ToastGravity.CENTER,
          );
        });
      } else {
        setState(() {
          predictData = resp.maturityScore.toString() + '%';
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

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'START';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'PAUSE';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'RESUM';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'START';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white, fontSize: 40.0));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current!.path!, isLocal: true);
  }
}

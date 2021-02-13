import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_plugin/permissions_plugin.dart';

class ReadActivity extends StatefulWidget {
  @override
  _ReadActivityState createState() => _ReadActivityState();
}

class _ReadActivityState extends State<ReadActivity> {
  FlutterTts tts = FlutterTts();
  String dir;
  bool isRecording = false;
  @override
  Widget build(BuildContext context) {
    final Map<String, String> data = ModalRoute.of(context).settings.arguments;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          title: Row(
            children: [
              ImageIcon(AssetImage("assets/images/read.png"), size: 16.0),
              SizedBox(width: 5.0),
              Text('Read'),
            ],
          ),
          backgroundColor: Colors.red[400],
          titleSpacing: -2.0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings),
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      """${data['body']}
                        """,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black87, fontSize: 18.0, height: 2.0),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.red[400],
                width: width,
                height: width * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {
                        print(data['body']);
                        _speak(data['body']);
                      },
                      color: Colors.red[400],
                      textColor: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.volume_up, size: 30.0),
                          Text('speak')
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _record(data);
                      },
                      color: Colors.red[400],
                      textColor: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fiber_manual_record, size: 30.0),
                          Text('record')
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (isRecording) {
                          _stopRecording();
                        }
                        _stop();
                      },
                      color: Colors.red[400],
                      textColor: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.stop, size: 30.0), Text('stop')],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _speak(String data) async {
    await tts.setLanguage("en-NG");
    await tts.setVoice({'name': 'en-NG-language', 'locale': 'en-NG'});
    await tts.setPitch(1.0);
    await tts.setVolume(0.2);
    int size = data.length;
    int n = 0;
    List<String> dataArray = data.split(" ");
    List<String> aD;

    if (size <= 3000) {
      await tts.speak(data);
    } else {
      n = ((size ~/ 3000) + (size % 3000 > 0 ? 1 : 0));
      aD = List();
      int p = dataArray.elementAt(0).length + 1;
      String tempData = "${dataArray.elementAt(0)} "; //print(tempData);
      for (int i = 1; i < dataArray.length; i++) {
        print(p + dataArray.elementAt(i).length);
        if (p + dataArray.elementAt(i).length > 3000) {
          aD.add(tempData);
          tempData = "";
          p = 0;
        }
        tempData = "$tempData ${dataArray.elementAt(i)} ";
        if (i == dataArray.length - 1 && p != 0) {
          aD.add(tempData);
          break;
        }
        p += dataArray.elementAt(i).length + 1;
      }

      await tts.speak(aD.elementAt(0));
      print(size);
    }
    var counter = 1;
    tts.completionHandler = () async {
      if (counter < n) {
        await tts.speak(aD.elementAt(counter++));
      } else {
        if (isRecording) {
          _stopRecording();
        }
        _stop();
      }
    };
  }

  Future<void> _stop() async {
    await tts.stop();
  }

  Future<bool> _onBackPressed() async {
    _stop();
    return true;
  }

  Future<void> _record(final Map<String, String> data) async {
    isRecording = await AudioRecorder.isRecording;

    _grantPermissions();

    dir = await _createDirectory();

    if (isRecording) {
      _showToast('recording already in progress', Colors.yellowAccent);
      return;
    }
    if (dir != null) {
      _stop();
      _speak(data['body']);
      await AudioRecorder.start(
          path: '$dir/${data['title']}' + "**" + '${DateTime.now()}',
          audioOutputFormat: AudioOutputFormat.WAV);
      isRecording = await AudioRecorder.isRecording;
      _showToast('recording...', Colors.blueAccent);
    } else {
      _showToast('storage directory could not be created', Colors.red);
      return;
    }
  }

  Future<void> _stopRecording() async {
    if (isRecording) {
      Recording recording = await AudioRecorder.stop();
      _showToast(recording.path, Colors.blueAccent);
    } else {
      _showToast('not recording at the moment', Colors.yellowAccent);
    }
  }

  Future<String> _createDirectory() async {
    try {
      Directory dir = await getExternalStorageDirectory();
      String path = "Text2dio/Recording";
      path = join(dir.path, path);

      var directory = Directory(path);
      print(directory.path);
      bool exists = await directory.exists();
      if (!exists) {
        print(directory.path);
        directory.create(recursive: true);
      }
      return path;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  _showToast(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        textColor: color,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white);
  }

  void _grantPermissions() async {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.requestPermissions(
            [Permission.READ_EXTERNAL_STORAGE, Permission.RECORD_AUDIO]);
  }
}

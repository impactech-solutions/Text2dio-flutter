import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:just_audio/just_audio.dart';

class MediaPlayerActivity extends StatefulWidget {
  @override
  _MediaPlayerActivityState createState() => _MediaPlayerActivityState();
}

class _MediaPlayerActivityState extends State<MediaPlayerActivity> {
  Map<String, Object> data;
  int result;
  int duration = 100;
  AudioPlayer _player;
  bool isPlaying = false;
  bool _isReady = false;
  int currentValue = 0;

  _MediaPlayerActivityState() {
    //_loadData().then((value) => d);
  }

  @override
  initState() {
    super.initState();
    _player = AudioPlayer();
  }

  IconData playIcon;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    data = ModalRoute.of(context).settings.arguments;
    if (!_isReady) {
      _loadData(data['path']).then((value) => setState(() {
            this.duration = value.inSeconds;
            _isReady = true;
          }));
    }
    String title = data['path'];
    title = title.substring(
            title.lastIndexOf("/") + 1, title.lastIndexOf("*") - 1) +
        title.substring(title.lastIndexOf("."));

    playIcon = Icons.play_arrow;

    return Scaffold(
      appBar: AppBar(
          elevation: 10.0,
          titleSpacing: -2.0,
          backgroundColor: Colors.red[400],
          centerTitle: true,
          title: Row(
            children: [
              Icon(Icons.music_note, size: 16.0),
              SizedBox(width: 5.0),
              Text('Audio Player'),
            ],
          )),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  height: height * 0.60,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Image(
                            image: AssetImage("assets/images/logo.png"),
                            width: 156,
                            height: 156),
                      ),
                      Text('TEXT2DIO PLAYER',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: width,
                    height: height * 0.2738,
                    decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Row(
                              children: [
                                Text(
                                  "Now Playing: $title",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                )
                              ],
                            ),
                          ),
                          FAProgressBar(
                            currentValue: currentValue,
                            maxValue: duration,
                            size: 3,
                            backgroundColor: Colors.white,
                            progressColor: Colors.blueAccent,
                            animatedDuration: Duration(seconds: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _rewind(),
                                icon: Icon(
                                  Icons.skip_previous,
                                  size: 35.0,
                                  color: Colors.white,
                                ),
                              ),
                              isPlaying
                                  ? new IconButton(
                                      onPressed: () {
                                        _play();
                                        setState(() {
                                          isPlaying = !isPlaying;
                                        });
                                      },
                                      icon: new Icon(Icons.pause,
                                          size: 35, color: Colors.white),
                                    )
                                  : new Container(),
                              !isPlaying
                                  ? new IconButton(
                                      onPressed: () {
                                        _play();
                                        setState(() {
                                          isPlaying = !isPlaying;
                                        });
                                      },
                                      icon: new Icon(Icons.play_arrow,
                                          size: 35, color: Colors.white),
                                    )
                                  : new Container(),
                              IconButton(
                                onPressed: _forward(),
                                icon: Icon(
                                  Icons.skip_next,
                                  size: 35.0,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: _share(),
                                icon: Icon(
                                  Icons.share,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  _share() {}

  _forward() {}

  Future<Duration> _loadData(String path) async {
    Duration duration;
    if (data != null) duration = await _player.setFilePath(path);
    return duration;
  }

  _play() async {
    if (_isReady) {
      if (!isPlaying) {
        _player.play();
        print(isPlaying);
      } else {
        _player.pause();
      }
    }
    // } else {
    //   _loadData(data["path"]).then((value) {
    //     setState(() {
    //       this.duration = value.inSeconds;
    //       _isReady = true;
    //     });
    //   });
    // }
    // setState(() {
    //   isPlaying = !isPlaying;
    // });

    // Timer.periodic(Duration(seconds: 1), (timer) {
    //   if (timer.isActive && isPlaying) {
    //     timer.cancel();
    //   }
    //   setState(() {
    //     currentValue++; //= _player.position.inSeconds;
    //     print("$currentValue $duration");
    //   });
    //   print("Yes its ${currentValue}");
    // });

    _player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
          currentValue = 0;
          _isReady = false;
          //_player.stop();
        });
      }
    });
  }

  _pause() async {
    if (isPlaying) {
      await _player.pause();
      setState(() {
        isPlaying = false;
      });
    }
  }

  _rewind() {
    _player.pause();
    // int value =
    //     _player.position.inSeconds > 10 ? _player.position.inSeconds - 10 : 0;
    // _player.seek(Duration(seconds: value));
    // _player.play();
  }
}

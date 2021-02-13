import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class Audio extends StatefulWidget {
  @override
  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  List<File> path;

  Future<List<File>> _listOfFiles() async {
    Directory directory = (await getExternalStorageDirectory());
    directory = Directory("${directory.path}/Text2dio/Recording");
    List<File> paths = new List();
    directory.list().forEach((element) {
      File file = File(element.path);
      paths.add(file);
    });

    return paths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Audio'),
          titleSpacing: -2.0,
          leading: Icon(Icons.music_note),
          backgroundColor: Colors.red[800],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                Column(
                  children: [
                    Center(
                        child: FutureBuilder(
                      future: _listOfFiles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          path = snapshot.data;
                          final itemCount = path.length;
                          return itemCount > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: itemCount,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    File file = path[index];
                                    var title = file.path.substring(
                                        file.path.lastIndexOf("/") + 1);

                                    var dat =
                                        "${title.substring(title.lastIndexOf("*") + 1)}";
                                    dat = dat.substring(0, 16);
                                    title = title.substring(
                                            0, title.indexOf("*")) +
                                        title.substring(title.lastIndexOf("."));
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 8.0),
                                      child: Card(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 8.0,
                                                top: 0.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Icon(
                                                        Icons.music_note,
                                                        size: 30,
                                                        color: Colors.black54,
                                                      ),
                                                    )),
                                                Column(
                                                  children: [
                                                    Text(title,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                "Oswald")),
                                                    Text(dat,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12.0))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/mediaPlayerActivity",
                                                          arguments: {
                                                            'path': file.path
                                                          });
                                                      print(file.path);
                                                    },
                                                    icon:
                                                        Icon(Icons.play_arrow),
                                                    color: Colors.blueAccent,
                                                    iconSize: 30.0,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        _share(path[index].path,
                                                            title);
                                                      },
                                                      icon: Icon(Icons.share),
                                                      color: Colors.blue,
                                                      iconSize: 30.0),
                                                  IconButton(
                                                    onPressed: () {
                                                      file.delete(
                                                          recursive: true);
                                                      setState(() {
                                                        path.remove(index);
                                                      });
                                                    },
                                                    icon: Icon(Icons.delete),
                                                    iconSize: 30.0,
                                                    color:
                                                        Colors.redAccent[700],
                                                  )
                                                ]),
                                          ])
                                        ],
                                      )),
                                    );
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Image(
                                      image:
                                          AssetImage('assets/images/empty.png'),
                                      width: 100.0,
                                      height: 100.0,
                                    )),
                                    Center(child: Text("Nothing to show"))
                                  ],
                                );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50.0),
                            new CircularProgressIndicator(
                              backgroundColor: Colors.red[400],
                              strokeWidth: 2.0,
                            ),
                          ],
                        );
                      },
                    ))
                  ],
                )
              ],
            )));
  }

  _share(String path, String title) {
    Share.shareFiles([path], text: title);
  }
}

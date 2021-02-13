import 'package:Text2dio/databases/DbHelper.dart';
import 'package:Text2dio/model/TextModel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DbHelper db = new DbHelper();
  Icon searchIcon = new Icon(Icons.search);
  Widget searchBar = new Text('Dashboard');

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   searchIcon = new Icon(Icons.search);
    // });
    return Scaffold(
        appBar: AppBar(
          title: searchBar,
          titleSpacing: -2,
          leading: Icon(Icons.home),
          backgroundColor: Colors.red[800],
          actions: <Widget>[
            IconButton(
              icon: searchIcon,
              onPressed: () {
                setState(() {
                  if (this.searchIcon.icon == Icons.search) {
                    this.searchIcon = new Icon(Icons.cancel);
                    this.searchBar = new TextField();
                  }
                });
              },
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Extracted Text",
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontFamily: "Oswald")),
              ),
              Column(
                children: [
                  Center(
                    child: FutureBuilder(
                        future: db.getTextList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final textList = snapshot.data;
                            final itemCount = textList.length;
                            return itemCount > 0
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: itemCount,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      TextModel tm = textList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Card(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, bottom: 8.0),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Icon(
                                                          Icons.text_format,
                                                          size: 30.0),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          tm.title.length > 20
                                                              ? '${tm.title.substring(0, 20)}...'
                                                              : '${tm.title}',
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Oswald"),
                                                        ),
                                                        Text(
                                                            '${tm.date_created.substring(0, 16)}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    12.0)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/readActivity",
                                                              arguments: {
                                                                'title':
                                                                    tm.title,
                                                                'body': tm.body
                                                              });
                                                        },
                                                        icon: ImageIcon(
                                                            AssetImage(
                                                                'assets/images/read.png'),
                                                            size: 25.0,
                                                            color: Colors
                                                                .blueAccent),
                                                      ),
                                                      // Text('read'),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          db.deleteText(tm.id);
                                                          setState(() {
                                                            textList
                                                                .remove(tm.id);
                                                          });
                                                        },
                                                        icon: Icon(Icons.delete,
                                                            size: 25.0,
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ])
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Image(
                                        image: AssetImage(
                                            'assets/images/empty.png'),
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
                        }),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

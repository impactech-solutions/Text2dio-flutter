import 'package:Text2dio/view/MediaPlayerActivity.dart';
import 'package:Text2dio/view/ReadActivity.dart';
import 'package:flutter/material.dart';
import 'package:Text2dio/Dashboard.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "/dashboard": (_) => Dashboard(),
        "/readActivity": (_) => ReadActivity(),
        "/mediaPlayerActivity": (_) => MediaPlayerActivity(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, "/dashboard");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 160.0,
            height: 160.0,
          ) ),
          Text('Text2dio v 1.0.0',
              style: TextStyle(
                  fontFamily: 'Itim', fontSize: 20.0, color: Colors.red)),
          Text('Created by',
              style: TextStyle(
                fontFamily: 'lobster',
                color: Colors.black,
                fontSize: 16.0,
              )),
          Text(
            'Impact Solutions\nTechnologies',
            style: TextStyle(
              fontFamily: 'lobster',
              color: Colors.black,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

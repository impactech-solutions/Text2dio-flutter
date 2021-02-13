import 'package:Text2dio/view/Home.dart';
import 'package:Text2dio/view/Audio.dart';
import 'package:Text2dio/view/AddText.dart';
import 'package:Text2dio/view/Search.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static int _currentIndex = 0;
  final tabs = [new Home(), new Audio(), new AddText(), new Search()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 18,
          unselectedFontSize: 16,
          showUnselectedLabels: true,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.red[400],
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.red[400],
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.multitrack_audio),
              label: 'Audio',
              backgroundColor: Colors.red[400],
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_library_add), label: 'Add Text'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}

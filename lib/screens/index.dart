import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../module/dataModule.dart';
import '../screens/documentsScreen.dart';
import '../screens/imageScreen.dart';
import '../screens/videoScreen.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int _selectedIndex = 0;
  String title = "WhatsApp Saver";

  List<Widget> _list = <Widget>[
    ImagesScreen(),
    VideoScreen(),
    DocumentsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
@override
  void initState() {
    // TODO: implement initState
  DataModule().initServices();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text(
        title,
      )),
      body: Center(child: _list.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 6,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            tooltip: 'Images',
              icon: Icon(Icons.image),
              label: 'Images',
              activeIcon: FaIcon(FontAwesomeIcons.image)),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection),
              label: 'Video',
              backgroundColor: Colors.greenAccent,
              activeIcon: FaIcon(FontAwesomeIcons.video)),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_page_outlined),
              label: 'Documents',
              activeIcon: FaIcon(FontAwesomeIcons.file))
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        selectedFontSize: 15,
        onTap: _onItemTapped,
      ),
    );
  }
}

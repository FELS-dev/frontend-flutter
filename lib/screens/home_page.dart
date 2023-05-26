import 'package:flutter/material.dart';
import 'package:front_end/screens/interactive_map.dart';
import 'package:front_end/screens/qr_code.dart';
import 'package:front_end/screens/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  static final List<Widget> _pages = <Widget>[
    QRCodePage(),
    InteractiveMap(),
    QuizScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vivatech'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF0081),
                  Color(0xFFFF00E4),
                  Color(0xFFF15700),
                ],
              ),
            ),
          ),
        ),
        body: _pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color(0xFF5508A0),
          iconSize: 32,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_2),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.gamepad),
              label: '',
            ),
          ],
          currentIndex: currentIndex,
          onTap: onTabTapped,
        ),
      ),
    );
  }
}

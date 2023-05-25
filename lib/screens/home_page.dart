import 'package:flutter/material.dart';
import 'package:front_end/widgets/stand_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Map<String, String>> cardData = [
    {'title': 'Title 1', 'text': 'Lorem ipsum 1'},
    {'title': 'Title 2', 'text': 'Lorem ipsum 2'},
    {'title': 'Title 3', 'text': 'Lorem ipsum 3'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Toto'),
        ),
        body: Align(
          alignment: Alignment.bottomLeft,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: cardData.map((data) {
                      return ExpandableCard(
                        title: data['title']!,
                        text: data['text']!,
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
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
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

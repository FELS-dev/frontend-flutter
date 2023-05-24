import 'package:flutter/material.dart';
import 'package:front_end/widgets/stand_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
        body: Stack(
          children: [
            Positioned.fill(
              bottom: kBottomNavigationBarHeight,
              child: Container(
                  // Content of the screen
                  ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                height: 200,
                // Ajustez la hauteur en fonction de vos besoins
                child: ListView.builder(
                  clipBehavior: Clip.hardEdge,
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      5, // Remplacez par le nombre d'ExpandableCard souhaitées
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ExpandableCard(
                            maxWidth: constraints.maxWidth,
                            maxHeight: constraints.maxHeight,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final _widgetOptions = [
    Text('Index 0 : Nouvelles'),
    Text('Index 1 : Sondages'),
    Text('Index 2 : Propositions'),
    Text('Index 3 : Résultats'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.insert_drive_file), title: Text('Nouvelles')),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), title: Text('Sondages')),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), title: Text('Propositions')),
          BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('Résultats')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index){
      setState(() {
       _selectedIndex = index; 
      });
    }
}
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres', style: TextStyle(color: Theme.of(context).primaryColor)),
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
      ),
    );
  }
}
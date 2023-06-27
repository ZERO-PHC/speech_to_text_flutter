import 'package:flutter/material.dart';

class ActivitiesUI extends StatelessWidget {
  const ActivitiesUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades',
            style: TextStyle(color: Colors.lightGreenAccent)),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Actividades'),
      ),
    );
  }
}

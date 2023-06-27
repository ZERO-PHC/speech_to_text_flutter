import 'package:flutter/material.dart';

class ChatOptionsMessage extends StatelessWidget {
  final VoidCallback onPressed;

  const ChatOptionsMessage({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: onPressed, child: Text('Yes')),
          SizedBox(width: 30),
          ElevatedButton(onPressed: () {}, child: Text('No')),
        ],
      ),
    );
  }
}

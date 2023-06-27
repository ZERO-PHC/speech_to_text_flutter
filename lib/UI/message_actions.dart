// a stateless widget that renders a list view
// of message actions

import 'package:flutter/material.dart';

class MessageActions extends StatelessWidget {
  final List<String> actions;
  final Function(String) onActionSelected;

  const MessageActions({required this.actions, required this.onActionSelected})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                onActionSelected(actions[index]);
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(0, 3))
                    ]),
                child: Center(
                  child: Text(
                    actions[index],
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:learning/chat_options_message.dart';
import 'package:learning/models/pros_model.dart';
import 'package:provider/provider.dart';

class ProfessionalsChat extends StatefulWidget {
  @override
  _ProfessionalsChatState createState() => _ProfessionalsChatState();
}

class _ProfessionalsChatState extends State<ProfessionalsChat> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProsModel>(builder: (context, prosModel, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Profesionales chat',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.green,
                )),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: AnimatedList(
                key: prosModel.listKey,
                controller: prosModel
                    .scrollController, // Add the scroll controller here

                initialItemCount: prosModel.messages.length,
                itemBuilder: (BuildContext context, int index,
                    Animation<double> animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: _buildMessage(prosModel.messages[index]["content"],
                        prosModel.messages[index]["isBot"]),
                  );
                },
              ),
            ),
            prosModel.optionsActive
                ? ChatOptionsMessage(
                    onPressed: prosModel.handleIntentionConfirmation)
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        shape: ShapeBorder.lerp(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            1),
                        child: Row(
                          children: [
                            // IconButton(
                            //   icon:
                            //       Icon(Icons.mic_outlined, color: Colors.green),
                            //   onPressed: () {
                            //     // initRecorder();

                            //     // record();
                            //   },
                            // ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: TextField(
                                  controller: prosModel.messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Me gustaría...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: prosModel.isLoading
                                  ? CircularProgressIndicator()
                                  : Icon(Icons.send_outlined,
                                      color: Colors.green),
                              onPressed: () {
                                String message =
                                    prosModel.messageController.text.trim();
                                if (message.isNotEmpty) {
                                  prosModel.createChatCompletion(
                                      message, context);

                                  // setState(() {
                                  prosModel.insertMessage(message, false);
                                  prosModel.messageController.clear();
                                  // _showAudio = false;
                                  // });
                                }

                                FocusScope.of(context)
                                    .unfocus(); // Add this line to close the keyboard
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    });
  }

  Widget _buildMessage(String text, isBot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            width: double.maxFinite / 2,
            decoration: BoxDecoration(
              color: isBot
                  ? Color.fromARGB(37, 99, 230, 175)
                  : Color.fromARGB(77, 224, 226, 221),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text,
                  style: TextStyle(
                      color: isBot ? Colors.black : Colors.black,
                      fontSize: 16.0)),
            ),
            alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
          ),
          // Positioned(
          //   left: isBot ? 6 : null,
          //   right: isBot ? null : 6,
          //   child: Container(
          //     height: 30,
          //     width: 30,
          //     child: CircleAvatar(
          //       backgroundImage: AssetImage(isBot
          //           ? 'assets/images/terrabot.png'
          //           : 'assets/images/oscarAvatar.png'),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

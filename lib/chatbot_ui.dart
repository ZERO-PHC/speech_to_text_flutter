import 'package:flutter/material.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:learning/UI/message_actions.dart';
import 'package:learning/chat_options_message.dart';
import 'package:learning/models/general_model.dart';
import 'package:provider/provider.dart';

const theSource = AudioSource.microphone;

var actions = ['action1', 'action2'];

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GeneralModel>(builder: (context, generalModel, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // leading: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Image.asset('assets/images/TerraLogo.png')),
          title: Text('YoinUp',
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
                key: generalModel.listKey,
                controller: generalModel
                    .scrollController, // Add the scroll controller here

                initialItemCount: generalModel.messages.length,
                itemBuilder: (BuildContext context, int index,
                    Animation<double> animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: _buildMessage(
                      generalModel.messages[index]["content"],
                      generalModel.messages[index]["isBot"],
                      generalModel.messages[index]["isList"],
                    ),
                  );
                },
              ),
            ),
            generalModel.optionsActive
                ? ChatOptionsMessage(
                    onPressed: generalModel.handleIntentionConfirmation)
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
                                  controller: generalModel.messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Me gustaría...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: generalModel.isLoading
                                  ? CircularProgressIndicator()
                                  : Icon(Icons.send_outlined,
                                      color: Colors.green),
                              onPressed: () {
                                // navigate to push named professionals chat

                                String message =
                                    generalModel.messageController.text.trim();
                                if (message.isNotEmpty) {
                                  generalModel.createChatCompletion(
                                      message, context);

                                  // setState(() {
                                  generalModel.insertMessage(
                                      message, false, false);
                                  generalModel.messageController.clear();
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

  Widget _buildMessage(String text, isBot, isList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        width: double.maxFinite / 2,
        decoration: BoxDecoration(
          color: isBot
              ? Color.fromARGB(37, 99, 230, 175)
              : Color.fromARGB(77, 224, 226, 221),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: !isList
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text,
                    style: TextStyle(
                        color: isBot ? Colors.black : Colors.black,
                        fontSize: 16.0)),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(text,
                        style: TextStyle(
                            color: isBot ? Colors.black : Colors.black,
                            fontSize: 16.0)),
                  ),
                  MessageActions(
                      actions: actions,
                      onActionSelected: (action) {
                        print(action);
                      }),
                ],
              ),
        alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      ),
    );
  }
}

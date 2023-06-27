// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
// import 'package:learning/UI/create_interaction.dart';
// import 'package:learning/UI/create_project.dart';
// import 'package:learning/UI/interactions_ui.dart';
// import 'package:learning/activities_ui.dart';
// import 'package:learning/chat_message_model.dart';
// import 'package:learning/chat_options_message.dart';
// import 'package:learning/chatbot_ui.dart';
// import 'package:learning/gpt_response.dart';
// import 'package:learning/project_ui.dart';
// import 'package:learning/projects_page.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'dart:developer';

// import 'package:provider/provider.dart';

// typedef _Fn = void Function();

// const theSource = AudioSource.microphone;

// var functions = [
//   "View all functions",
//   "View all projects",
//   "View project",
//   "Create project",
//   "View all interactions",
//   "Create interaction",
//   // {
//   // "nombre": "Ver proyectos",
//   //   "disponible": true,
//   //   // "funcion": verfunctions,
//   // },
//   // {
//   //   "nombre": "Ver actividades",
//   //   "disponible": true,
//   //   // "funcion": verActividades,
//   // },
//   // {
//   //   "nombre": "Ver procesos de un proyecto",
//   //   "disponible": true,
//   //   "funcion": verActividades,
//   //   "procesos": ["Proceso 1", "Proceso 2", "Proceso 3"]
//   // },
// ];

// var projects = [
//   {
//     "name": "Project 1",
//     "available": true,
//     "processes": ["Process 1", "Process 2", "Process 3"]
//   },
//   {
//     "name": "Project 2",
//     "available": true,
//     "processes": ["Process 1", "Process 2", "Process 3"]
//   },
//   {
//     "name": "Project 3",
//     "available": true,
//     "processes": ["Process 1", "Process 2", "Process 3"]
//   },
// ];

// class ChatBotPage extends StatefulWidget {
//   @override
//   _ChatBotPageState createState() => _ChatBotPageState();
// }

// class _ChatBotPageState extends State<ChatBotPage> {
//   TextEditingController _messageController = TextEditingController();
//   bool _showAudio = false;
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   List<String> _messages = [];
//   String _transcriptionText = "";
//   GptResponse? _transcriptionWidget;
//   bool _isBotActive = false;
//   Codec _codec = Codec.aacADTS;
//   var _mPath = "";
//   FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
//   FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
//   bool _mPlayerIsInited = false;
//   bool _mRecorderIsInited = false;
//   bool _mplaybackReady = false;
//   bool _optionsActive = false;
//   var _intendedInteraction = 0;
//   bool _isLoading = false;
//   String _selectedId = "";
//   var _selectedProject = {};

//   @override
//   void initState() {
//     _init();
//     super.initState();
//   }

//   Future<void> _init() async {
//     _mPlayer!.openPlayer().then((value) {
//       setState(() {
//         _mPlayerIsInited = true;
//         _insertMessage(
//             "Hola Oscar, yo soy TerraBot tu asistente virtual. ¿En qué puedo ayudarte?",
//             true);
//       });

//       // _playAudio("init");
//     });

//     // await openTheRecorder();

//     // Generate the recording file path using a helper function

//     setState(() {
//       _mRecorderIsInited = true;
//     });
//   }

//   handleNavigation(
//     interaction,
//   ) {
//     if (_intendedInteraction == 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Projects()),
//       );
//     }

//     if (interaction == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ProjectUI(project: _selectedProject)),
//       );
//     }

//     if (interaction == 2) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => CreateProjectUI()),
//       );
//     }

//     if (interaction == 3) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => InteractionsUI()),
//       );
//     }
//     if (interaction == 4) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => CreateInteractionUI()),
//       );
//     }
//   }

//   Future<String> generateFilePath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

//     var _path = p.join(directory.path, 'tau_file_$timeStamp.m4a');

//     setState(() {
//       _mPath = _path;
//     });

//     return _path;
//   }

//   @override
//   void dispose() {
//     _mPlayer!.closePlayer();
//     _mPlayer = null;

//     _mRecorder!.closeRecorder();
//     _mRecorder = null;
//     super.dispose();
//   }

//   // Future<void> openTheRecorder() async {
//   //   if (!kIsWeb) {
//   //     var status = await Permission.microphone.request();
//   //     if (status != PermissionStatus.granted) {
//   //       throw RecordingPermissionException('Microphone permission not granted');
//   //     }
//   //   }
//   //   await _mRecorder!.openRecorder();
//   //   if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//   //     if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
//   //       _mRecorderIsInited = true;
//   //       return;
//   //     }
//   //   }
//   //   final session = await AudioSession.instance;
//   //   await session.configure(AudioSessionConfiguration(
//   //     avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
//   //     avAudioSessionCategoryOptions:
//   //         AVAudioSessionCategoryOptions.allowBluetooth |
//   //             AVAudioSessionCategoryOptions.defaultToSpeaker,
//   //     avAudioSessionMode: AVAudioSessionMode.spokenAudio,
//   //     avAudioSessionRouteSharingPolicy:
//   //         AVAudioSessionRouteSharingPolicy.defaultPolicy,
//   //     avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
//   //     androidAudioAttributes: const AndroidAudioAttributes(
//   //       contentType: AndroidAudioContentType.speech,
//   //       flags: AndroidAudioFlags.none,
//   //       usage: AndroidAudioUsage.voiceCommunication,
//   //     ),
//   //     androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
//   //     androidWillPauseWhenDucked: true,
//   //   ));

//   //   _mRecorderIsInited = true;
//   // }

//   // void record() async {
//   //   // delay to allow the recorder to start
//   //   generateFilePath();

//   //   await Future.delayed(Duration(milliseconds: 1000));

//   //   print("Actual path: $_mPath");

//   //   _mRecorder!
//   //       .startRecorder(
//   //     toFile: _mPath,
//   //     codec: _codec,
//   //     audioSource: theSource,
//   //   )
//   //       .then((value) {
//   //     setState(() {});
//   //   });
//   // }

//   // transcribeRecordedAudio() async {
//   //   var transcription = await convertSpeechToText();
//   //   createChatCompletion(transcription);

//   //   print("Transcription: $transcription");

//   //   _insertMessage(transcription, true);

//   //   setState(() {
//   //     _transcriptionText = transcription;
//   //     _showAudio = false;
//   //   });

//   //   print("Transcription: $transcription");
//   //   return transcription;
//   // }

//   Future<void> _playAudio(type) async {
//     try {
//       AssetsAudioPlayer.newPlayer().open(
//         Audio(type == "init"
//             ? "assets/audios/botVoice.mp3"
//             : "assets/audios/botVoice.mp3"),
//         autoStart: true,
//         showNotification: true,
//       );
//     } on PlatformException catch (e) {
//       print('Error playing audio: ${e.message}');
//     }
//   }

//   // Future<String> convertSpeechToText() async {
//   //   try {
//   //     const apiKey = "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";
//   //     var url = Uri.https("api.openai.com", "v1/audio/transcriptions");
//   //     var request = http.MultipartRequest('POST', url);
//   //     request.headers.addAll(({"Authorization": "Bearer $apiKey"}));
//   //     request.fields["model"] = 'whisper-1';
//   //     request.fields["language"] = "en";
//   //     request.files.add(await http.MultipartFile.fromPath('file', _mPath));
//   //     var response = await request.send();
//   //     var newresponse = await http.Response.fromStream(response);
//   //     final responseData = json.decode(newresponse.body);

//   //     if (responseData['text'] != null) {
//   //       log("Transcription success: ${responseData['text']}");
//   //       return responseData['text'];
//   //     } else {
//   //       log("Transcription error: ${responseData}");
//   //       throw Exception("Transcription error: ${responseData}");
//   //     }
//   //   } catch (e) {
//   //     log("Error: $e");
//   //     throw Exception("Error: $e");
//   //   }
//   // }

//   createChatCompletion(String value) async {
//     _isLoading = true;
//     print('Creating chat completion');
//     final url = Uri.parse('https://api.openai.com/v1/chat/completions');

//     final openAiApiKey = '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';

//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $openAiApiKey',
//     };

//     const prefix1 =
//         "Eres un asistente virtual para una app móvil, puedes ayudarle con lo siguiente: renderizar todos los proyectos de la red. Detecta la intención del usuario proveniente del siguiente mensaje para manejar la siguiente interacción y comunicame eso a detalle";
//     var prefix2 =
//         "Eres el asistente virtual para un usuario de una app móvil que cuenta con las siguientes functions: ${functions}. genera 2 mensajes de respuesta en el primero  comunicale a la app la intención del usuario y busca en que index se encuentra esa función en este Array ${functions}. en el segundo comunicale al usuario si la función está disponible o no ";
//     var prefix3 =
//         "Eres el asistente virtual para un usuario de una app móvil que cuenta con las siguientes functions: $functions. genera 2 mensajes de respuesta. En el primero  detecta la intención de interacción del usuario y responde solamente con elo que corresponde del siguiente array: ${functions} .en el segundo mensaje comunicale al usuario si la función está disponible o no ";

//     var prefix4 =
//         "Eres el asistente virtual para un usuario de una app móvil que cuenta con las siguientes functions: ${functions}. genera 2 mensajes de respuesta. En el primero detecta la intención de interacción del usuario y busca un match con losos del siguiente Array: ${functions} .en el segundo mensaje comunicale al usuario si la función está disponible o no ";

//     var prefix5 =
//         "Eres el asistente virtual de una app móvil que cuenta con las siguientes functions: ${functions} y analiza los siguientes proyectos: ${projects}. detecta cual es el index de losos de este Array: ${functions} es el que busca el usuario y preguntale: ¿Es Correcto? para confirmar la inteción.  detecta si el prompt del usuario tiene multiples inteciones, si tiene multiples intenciones dile al usuario que escriba una intención a la vez. { formatea la respuesta del usuario para que sea entendible por la app }";
//     var prefix6 =
//         "You are an intent detector for users of a mobile app that has the following functions: ${functions} and analyzes the following projects: ${projects}.";

//     var formato = "{format the response in a table.}";

//     var formato1 =
//         "{format the response to obtain the function that the user is looking for.}";

//     var formato0 =
//         "{ formatea tu respuesta para que sea entendible por la app }";

//     var input = "$prefix6. input del usuario: $value. $formato ";
//     final body = jsonEncode({
//       'model': 'gpt-3.5-turbo',
//       'messages': [
//         {'role': 'user', 'content': input}
//       ],
//       'temperature': 0.2,
//       // 'n': 2,
//     });

//     final response = await http.post(url, headers: headers, body: body);

//     setState(() {
//       _isLoading = false;
//     });

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print("Response data: $responseData");
//       final assistantResponse =
//           responseData['choices'][0]['message']['content'];
//       print('Assistant response: $assistantResponse');

//       // detect if the assistance response contains the following texts: "¿Es correcto?", "¿Es correcto lo que dije?"
//       // if (assistantResponse.contains("¿Es correcto?") ||
//       //     assistantResponse.contains("¿es correcto?") ||
//       //     assistantResponse.contains("¿Es correcto lo que dije?")) {
//       //   print("Assistant response contains confirmation text");
//       var _func = extractFunction(assistantResponse);

//       print("Extracted function: $_func");

//       if (_func == "Viewallprojects") {
//         // handleNavigation(0);
//       }

//       if (_func == "Viewproject") {
//         // var _extractedNumber = extractFirstNumber(assistantResponse);
//         setState(() {
//           // _selectedProject =
//         });

//         // handleNavigation(1);
//       }

//       if (_func == "Createproject") {
//         handleNavigation(2);
//       }

//       if (_func == "Viewallinteractions") {
//         handleNavigation(3);
//       }

//       if (_func == "Createinteraction") {
//         var _extractedNumber = extractFirstNumber(assistantResponse);

//         handleNavigation(4);
//       }

//       // var _extractedNumber = extractFirstNumber(assistantResponse);
//       // print("Extracted number: $_extractedNumber");

//       // var _extractedNumber2 = extractNthNumber(assistantResponse, 2);

//       // var targetId = extractTargetId(assistantResponse);

//       // setState(() {
//       //   _optionsActive = true;
//       //   _intendedInteraction = 1;
//       // });

//       // handleIntentionConfirmation();

//       // } else {
//       //   print("Assistant response does not contain ¿Es correcto?");
//       // }

//       // _playAudio("response");

//       setState(() {
//         _insertMessage(assistantResponse, true);
//         // _transcriptionWidget = GptResponse(transcription: assistantResponse);
//       });
//     } else {
//       print('Failed to get a response from the API');
//     }
//   }

//   extractFunction(String assistantResponse) {
//     // find if the assistant response contains any of the functions array
//     var index = -1;
//     var func = "";
//     for (var i = 0; i < functions.length; i++) {
//       if (assistantResponse.contains(functions[i])) {
//         index = i;
//         func = functions[i];
//         break;
//       }
//     }

//     print("Function: $func");
//     // sanitize the func variable
//     func = func.replaceAll(" ", "");
//     return func;
//   }

//   extractTargetId(String assistantResponse) {
//     // get the next character after the word "proyecto:"
//     var index = assistantResponse.indexOf("proyecto: ");
//     var targetId = assistantResponse.substring(index + 9, index + 10);
//     print("Target id: $targetId");
//     return targetId;
//   }

//   handleIntentionConfirmation() {
//     print("Handling intention confirmation");
//     // handleNavigation();
//     setState(() {
//       _optionsActive = false;
//     });
//   }

//   int extractFirstNumber(String inputString) {
//     RegExp regExp = RegExp(r'\d+');
//     RegExpMatch? match = regExp.firstMatch(inputString);
//     return match != null ? int.parse(match.group(0)!) : -1;
//   }

//   int extractNumbers(String inputString) {
//     RegExp regExp = RegExp(r'\d+');
//     Iterable<RegExpMatch> matches = regExp.allMatches(inputString);
//     List<int> numbers = matches.map((m) => int.parse(m.group(0)!)).toList();
//     return numbers[0];
//   }

//   void stopRecorder() async {
//     await _mRecorder!.stopRecorder().then((value) {
//       setState(() {
//         // var url = value;
//         _mplaybackReady = true;
//       });
//     });

//     // transcribeRecordedAudio();
//   }

//   void play() {
//     // assert(_mPlayerIsInited &&
//     //     _mplaybackReady &&
//     //     _mRecorder!.isStopped &&
//     //     _mPlayer!.isStopped);
//     // _mPlayer!
//     //     .startPlayer(
//     //         fromURI: _mPath,
//     //         whenFinished: () {
//     //           setState(() {});
//     //         })
//     //     .then((value) {
//     //   setState(() {});
//     // });
//   }

//   void stopPlayer() {
//     _mPlayer!.stopPlayer().then((value) {
//       setState(() {});
//     });
//   }

//   void _insertMessage(
//     String message,
//     bool isBot,
//   ) {
//     _listKey.currentState!.insertItem(
//       _messages.length,
//       duration: Duration(milliseconds: 500),
//     );
//     setState(() {
//       _messages.add(message);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundImage: NetworkImage(
//                 'https://res.cloudinary.com/ddbgaessi/image/upload/v1682111078/terrabot_pgmdes.png'),
//           ),
//         ),
//         title: Text('TerraBot',
//             style: TextStyle(color: Colors.white, fontSize: 20)),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: AnimatedList(
//               key: _listKey,
//               initialItemCount: _messages.length,
//               itemBuilder: (BuildContext context, int index,
//                   Animation<double> animation) {
//                 return SizeTransition(
//                   sizeFactor: animation,
//                   child: _buildMessage(_messages[index], index % 2 == 0),
//                 );
//               },
//             ),
//           ),
//           Divider(height: 1),
//           _optionsActive
//               ? ChatOptionsMessage(onPressed: handleIntentionConfirmation)
//               : Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.mic),
//                           onPressed: () {
//                             // initRecorder();

//                             // record();

//                             setState(() {
//                               _showAudio = !_showAudio;
//                             });
//                           },
//                         ),
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: InputDecoration(
//                               hintText: 'Me gustaría...',
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: _isLoading
//                               ? CircularProgressIndicator()
//                               : Icon(Icons.send),
//                           onPressed: () {
//                             String message = _messageController.text.trim();
//                             if (message.isNotEmpty) {
//                               createChatCompletion(message);

//                               setState(() {
//                                 _insertMessage(message, false);
//                                 _messageController.clear();
//                                 _showAudio = false;
//                               });
//                             }

//                             FocusScope.of(context)
//                                 .unfocus(); // Add this line to close the keyboard
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//           _showAudio ? _buildAudioRecorder() : Container(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessage(String text, isBot) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       width: double.maxFinite / 2,
//       decoration: BoxDecoration(
//         color: isBot
//             ? Color.fromARGB(87, 224, 224, 224)
//             : Color.fromARGB(94, 197, 225, 165),
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Text(text),
//       alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
//     );
//   }

//   Widget _buildAudioMessage() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.mic_outlined),
//           SizedBox(width: 8.0),
//           Text('Audio message'),
//         ],
//       ),
//     );
//   }

//   Widget _buildAudioRecorder() {
//     return Container(
//       height: 100.0,
//       color: Colors.grey[300],
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//             icon: Icon(Icons.stop),
//             onPressed: () {
//               stopRecorder();
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.mic),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:collection';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:learning/UI/create_interaction.dart';
// import 'package:learning/UI/create_project.dart';
// import 'package:learning/UI/interactions_ui.dart';
// import 'package:learning/project_ui.dart';
// import 'package:learning/projects_page.dart';
// import 'package:provider/provider.dart';
// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:flutter_sound_platform_interface/flutter_sound_platform_interface.dart';

// // var functions = [
// //   "View all functions",
// //   "View all projects",
// //   "View project",
// //   "Create project",
// //   "View all interactions",
// //   "Create interaction",
// // ];

// var funciones = [
//   "Ver todas las funciones",
//   "Analizar que proyectos están disponibles",
//   "Analizar el estado de un proyecto",
//   "Analizar el progreso de todos los proyectos",
//   "Analizar el cronograma de un proyecto",
//   "Analizar los procesos de un proyecto",
// ];

// class GeneralModel extends ChangeNotifier {
//   // var _proyectos = [
//   //   {
//   //     "id": "1",
//   //     "name": "Project 1",
//   //     "available": true,
//   //     "processes": [false, false, false]
//   //   },
//   //   {
//   //     "id": "2",
//   //     "name": "Project 2",
//   //     "available": false,
//   //     "processes": [false, false, false]
//   //   },
//   // ];

//   var _proyectos = [
//     {
//       "id": "1",
//       "name": "Proyecto 1",
//       "disponible": true,
//       "procesos": [
//         {
//           "titulo": "mantenimiento",
//           "involucrados": ["Juan", "Pedro"],
//           "completo": false,
//           "evidencias": []
//         },
//         {
//           "titulo": "levantamiento",
//           "involucrados": ["Lisa"],
//           "completo": true,
//           "evidencias": ["https://picsum.photos/250?image=9"]
//         },
//       ],
//       "progreso": "10%",
//       "cronograma": [
//         {"titulo": "fase 1", "completo": true}
//       ]
//     },
//   ];

//   final List _interactions = [
//     {
//       "title": "Interaction 1",
//       "img": "https://picsum.photos/250?image=9",
//     }
//   ];

//   TextEditingController _messageController = TextEditingController();
//   bool _showAudio = false;
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   List _messages = [];
//   String _transcriptionText = "";
//   // GptResponse? _transcriptionWidget;
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
//   var _selectedProject = {
//     "id": "",
//     "name": "",
//     "available": true,
//     "processes": [false, false, false]
//   };

//   bool _isActive = false;
//   // List<bool> _stepsChecked = [false, false, false, false];

//   get isActive => _isActive;
//   // get stepsChecked => _stepsChecked;

//   get selectedProject => _selectedProject;
//   UnmodifiableListView get projects => UnmodifiableListView(_proyectos);
//   UnmodifiableListView get interactions => UnmodifiableListView(_interactions);

//   // Public getters for state variables
//   TextEditingController get messageController => _messageController;
//   GlobalKey<AnimatedListState> get listKey => _listKey;
//   List get messages => _messages;
//   bool get isLoading => _isLoading;
//   bool get optionsActive => _optionsActive;

//   GeneralModel() {
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       init();
//     });
//   }

//   Future<void> init() async {
//     print("Initializing model");
//     _mPlayerIsInited = true;
//     insertMessage(
//         "Hola Oscar, yo soy TerraBot tu asistente virtual ¿En qué te puedo ayudar?",
//         true);
//     _playAudio("init");

//     Future.delayed(const Duration(milliseconds: 1800), () {
//       insertMessage(
//           "Estas son las funciones que tengo disponibles: ${funciones}.", true);
//       _playAudio("init");
//     });

//     notifyListeners(); // Updated this line
//   }

//   void toggleSwitch(
//     projectId,
//     bool value,
//   ) {
//     print("Toggling switch: $value");

//     // update the projects list based on the selected project
//     var targetProject = _proyectos.firstWhere((project) {
//       return project["id"] == projectId;
//     });

//     print("targetProject: $targetProject");

//     targetProject["available"] = value;

//     print("projects: $_proyectos");

//     notifyListeners();
//   }

//   void toggleStep(projectId, int index, bool value) {
//     print("Toggling step: $projectId, $index, $value");
//     // update the projects list based on the selected project
//     var targetProject = _proyectos.firstWhere((project) {
//       return project["id"] == projectId;
//     });

//     print("targetProject: $targetProject");

//     updateProject(targetProject, index, value);

//     notifyListeners();
//   }

//   void updateProject(project, index, value) {
//     project["processes"][index] = value;
//   }

//   getProject(id) {
//     var targetProject = _proyectos.firstWhere((project) {
//       return project["id"] == id;
//     });

//     return targetProject;
//   }

//   handleNavigation(interaction, context, id) {
//     if (interaction == 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Projects()),
//       );
//     }

//     if (interaction == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ProjectUI(project: getProject(id))),
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

//   createChatCompletion(String value, context) async {
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
//         "Eres el asistente virtual para un usuario de una app móvil que cuenta con las siguientes functions: ${funciones}. genera 2 mensajes de respuesta en el primero  comunicale a la app la intención del usuario y busca en que index se encuentra esa función en este Array ${funciones}. en el segundo comunicale al usuario si la función está disponible o no ";
//     var prefix3 =
//         "Eres el asistente virtual para un usuario de una app móvil que cuenta con las siguientes funciones: $funciones. genera 2 mensajes de respuesta. En el primero  detecta la intención de interacción del usuario y responde solamente con elo que corresponde del siguiente array: ${funciones} .en el segundo mensaje comunicale al usuario si la función está disponible o no ";

//     var prefix4 =
//         "Eres el asistente virtual para un usuario de una app móvil que cuenta con las siguientes funciones: ${funciones}. genera 2 mensajes de respuesta. En el primero detecta la intención de interacción del usuario y busca un match con losos del siguiente Array: ${funciones} .en el segundo mensaje comunicale al usuario si la función está disponible o no ";

//     var prefix5 =
//         "Eres el asistente virtual de una app móvil que cuenta con las siguientes funciones: ${funciones} y analiza los siguientes proyectos: ${projects}. detecta cual es el index de losos de este Array: ${funciones} es el que busca el usuario y preguntale: ¿Es Correcto? para confirmar la inteción.  detecta si el prompt del usuario tiene multiples inteciones, si tiene multiples intenciones dile al usuario que escriba una intención a la vez. { formatea la respuesta del usuario para que sea entendible por la app }";
//     var prefix6 =
//         "You are an intent detector for users of a mobile app that has the following funciones: ${funciones} and analyzes the following projects: ${_proyectos}.";
//     var prefix7 =
//         "Eres un asistente virtual de una app movil. Estas son las funciones disponibles: ${funciones}. Estos son los proyectos que puedes analizar: ${_proyectos}.";
//     var prefix8 =
//         "Eres un asistente virtual de una app movil. Estos son los mensajes del chat actual para que tengas contexto: $_messages. Estas son las funciones disponibles: $funciones. Estos son los proyectos que puedes analizar: $_proyectos.";

//     var formato =
//         "{Si la funcion del usuario no se encuentra en el siguiente listado: $funciones, dile que no puedes hacer eso.}";

//     var formato1 =
//         "{format the response to obtain the function that the user is looking for.}";

//     var formato0 =
//         "{ formatea tu respuesta para que sea entendible por la app }";

//     var input = "$prefix7. input del usuario: $value. $formato ";
//     final body = jsonEncode({
//       'model': 'gpt-3.5-turbo',
//       'messages': [
//         {'role': 'user', 'content': input}
//       ],
//       'temperature': 0.2,
//       // 'n': 2,
//     });

//     final response = await http.post(url, headers: headers, body: body);

//     _isLoading = false;

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

//       // if (_func == "Viewallprojects") {
//       //   handleNavigation(0, context, "");
//       // }

//       // if (_func == "Viewallprojects") {
//       //   handleNavigation(0, context, "");
//       // }

//       // if (_func == "Viewproject") {
//       //   var _extractedNumber = extractFirstNumber(assistantResponse);
//       //   print("Extracted number: $_extractedNumber");

//       //   handleNavigation(1, context, _extractedNumber.toString());
//       // }

//       // if (_func == "Createproject") {
//       //   handleNavigation(2, context, "");
//       // }

//       // if (_func == "Viewallinteractions") {
//       //   handleNavigation(3, context, "");
//       // }

//       // if (_func == "Createinteraction") {
//       //   var _extractedNumber = extractFirstNumber(assistantResponse);

//       //   handleNavigation(4, context, "");
//       // }

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

//       insertMessage(assistantResponse, true);
//       // _transcriptionWidget = GptResponse(transcription: assistantResponse);
//     } else {
//       print('Failed to get a response from the API');
//     }
//   }

//   extractFunction(String assistantResponse) {
//     // find if the assistant response contains any of the functions array
//     var index = -1;
//     var func = "";
//     for (var i = 0; i < funciones.length; i++) {
//       if (assistantResponse.contains(funciones[i])) {
//         index = i;
//         func = funciones[i];
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
//     _optionsActive = false;
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

//   void insertMessage(
//     String message,
//     bool isBot,
//   ) {
//     print("Inserting message: $message");

//     _listKey.currentState!.insertItem(
//       _messages.length,
//       duration: Duration(milliseconds: 500),
//     );
//     _messages.add({
//       "content": message,
//       "isBot": isBot,
//     });

//     notifyListeners();
//   }

//   void addProject(String name) {
//     _proyectos.add(
//       {
//         "name": name,
//         "inMaintenance": false,
//       },
//     );
//     notifyListeners();
//   }

//   void removeProject(String name) {
//     _proyectos.remove(name);
//     notifyListeners();
//   }

//   void addInteraction(String name, img) {
//     _interactions.add(
//       {
//         "title": name,
//         "img": img,
//       },
//     );
//     notifyListeners();
//   }

//   void removeInteraction(String name) {
//     _interactions.remove(name);
//     notifyListeners();
//   }

//   void toggleMaintenanceStatus(String title, bool status) {
//     int index = _proyectos.indexWhere((project) => project['name'] == title);
//     if (index != -1) {
//       _proyectos[index]['inMaintenance'] = status;
//       notifyListeners();
//     }
//   }
// }

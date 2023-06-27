import 'dart:collection';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning/UI/create_interaction.dart';
import 'package:learning/UI/create_project.dart';
import 'package:learning/UI/interactions_ui.dart';
import 'package:learning/UI/professionals_chat.dart';
import 'package:learning/project_ui.dart';
import 'package:learning/projects_page.dart';
import 'package:provider/provider.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_platform_interface.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// var functions = [
//   "View all functions",
//   "View all projects",
//   "View project",
//   "Create project",
//   "View all interactions",
//   "Create interaction",
// ];

var funciones = [
  "Mostrar las funciones disponibles",
  "Mostrar los nombres de los proyectos",
  "Analizar un proyecto en específico",
  "Buscar un profesional",
];
var paginas = [
  "ver_profesionales",
  "ver_educadores",
];

class ProsModel extends ChangeNotifier {
  final List _interactions = [
    {
      "title": "Interaction 1",
      "img": "https://picsum.photos/250?image=9",
    }
  ];
  ScrollController _scrollController = ScrollController();

  TextEditingController _messageController = TextEditingController();
  bool _showAudio = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _listProKey =
      GlobalKey<AnimatedListState>();
  List _messages = [];
  String _transcriptionText = "";
  // GptResponse? _transcriptionWidget;
  bool _isBotActive = false;
  Codec _codec = Codec.aacADTS;
  var _mPath = "";
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  bool _optionsActive = false;
  var _intendedInteraction = 0;
  bool _isLoading = false;
  String _selectedId = "";

  bool _isActive = false;
  // List<bool> _stepsChecked = [false, false, false, false];

  get isActive => _isActive;
  // get stepsChecked => _stepsChecked;

  // UnmodifiableListView get projects => UnmodifiableListView(_proyectos);
  UnmodifiableListView get interactions => UnmodifiableListView(_interactions);

  // Public getters for state variables
  TextEditingController get messageController => _messageController;
  ScrollController get scrollController => _scrollController;

  GlobalKey<AnimatedListState> get listKey => _listKey;
  GlobalKey<AnimatedListState> get listProKey => _listProKey;
  List get messages => _messages;
  bool get isLoading => _isLoading;
  bool get optionsActive => _optionsActive;

  var _isErr = false;
  get isErr => _isErr;

  // ConnectivityResult _connectivityStatus = ConnectivityResult.none;

  ProsModel() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      init();
      // _initConnectivity();
    });
  }

  // setter for _intendedInteraction
  setIntendedInteraction(int value, context) {
    _intendedInteraction = value;

    // navigate to the ProfessionalsChat
    Navigator.pushNamed(context, '/pros');
  }

  // Future<void> _initConnectivity() async {
  //   _connectivityStatus = await (Connectivity().checkConnectivity());
  //   notifyListeners();

  //   // _subscription = Connectivity()
  //   //     .onConnectivityChanged
  //   //     .listen((ConnectivityResult result) {
  //   //   _connectivityStatus = result;
  //   //   notifyListeners();
  //   // });
  // }

  Future<void> init() async {
    // if current page is professionals chat

    print("Initializing model");
    _mPlayerIsInited = true;

    // notifyListeners(); //

    insertMessage("¿En qué te puedo ayudar?", true);
    _playAudio("init");

    // Future.delayed(const Duration(milliseconds: 1800), () {
    //   insertMessage(
    //       "Estas son las funciones que tengo disponibles: ${funciones}.", true);
    //   _playAudio("init");
    //   // insertProMessage("Qué tipo de profesional buscas?.", true);
    //   // _playAudio("init");
    // });

    notifyListeners(); // Updated this line

    // TODO: create a listener for the _intendedInteraction state variable
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  handleNavigation(interaction, context, id) {
    if (interaction == 0) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Projects()),
      // );
    }

    // if (interaction == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ProjectUI(project: getProject(id))),
    //   );
    // }

    if (interaction == 2) {
      // Navigator.push(
      //   context,
      //   // MaterialPageRoute(builder: (context) => CreateProjectUI()),
      // );
    }

    if (interaction == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfessionalsChat()),
      );
    }
    if (interaction == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateInteractionUI()),
      );
    }
  }

  Future<void> _playAudio(type) async {
    try {
      AssetsAudioPlayer.newPlayer().open(
        Audio(type == "init"
            ? "assets/audios/botVoice.mp3"
            : "assets/audios/botVoice.mp3"),
        autoStart: true,
        showNotification: true,
      );
    } on PlatformException catch (e) {
      print('Error playing audio: ${e.message}');
    }
  }

  createChatCompletion(String value, context) async {
    // show snackbar with the connection status
    _isLoading = true;

    print('Creating chat completion');
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final openAiApiKey = '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';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAiApiKey',
    };

    var contexto = 'el usuario se encuentra en la pagina x';

    // var prefix8 =
    // "Eres un asistente virtual de una app movil que ayuda a conectar a los usuarios con profesional. Estas son las funciones disponibles: $funciones. Estos son los proyectos que puedes analizar: $_proyectos.";
    var prefix10 =
        "Eres el asistente virtual de una app movil, esta app ayuda a conectar a los usuarios con  profesionales. Estas son las funciones disponibles: $funciones. estas son las paginas de la app: $paginas. Tú misión es ayudar al usuario con la navegación en la app.";
    // var prefix9 =
    // "Eres un asistente virtual de una app movil. Estas son las funciones disponibles: $funciones. Estos son los proyectos que puedes analizar: $_proyectos.";

    var formato =
        "{Dime en que index se encuentra la funcion que quiere el usuario del siguiente Array:$funciones. Muéstrame la data que pedí.  Si la funcion del usuario no se encuentra en el siguiente listado: $funciones, dime que no puedes hacer eso.}";

    var formato2 =
        '{indice: (Indice de la funcion), pagina: (pagina a la que se tiene que navegar)}';

    var input =
        "$prefix10.  input del usuario: $value. responde solamente con el siguiente formato: $formato2 ";
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': input}
      ],
      'temperature': 0.2,
      // 'n': 2,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);

      _isLoading = false;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response data: $responseData");
        final assistantResponse =
            responseData['choices'][0]['message']['content'];
        print('Assistant response: $assistantResponse');

        var _func = extractFunction(assistantResponse);

        print("Extracted function: $_func");

        _playAudio("response");

        // check if the assistantResponse contains the number 4
        if (assistantResponse.contains("4")) {
          setIntendedInteraction(4, context);

          // insertProMessage('test', true);

          // navigate to
        }

        // insertMessage(assistantResponse, true);
      } else {
        print('Failed to get a response from the API');
      }
    } catch (e) {
      print('Error: $e');
      _isLoading = false;
      _isErr = true;
      print('An error occurred while calling the API: $e');
      final snackBar = SnackBar(content: Text('An error occurred: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  extractFunction(String assistantResponse) {
    // find if the assistant response contains any of the functions array
    var index = -1;
    var func = "";
    for (var i = 0; i < funciones.length; i++) {
      if (assistantResponse.contains(funciones[i])) {
        index = i;
        func = funciones[i];
        break;
      }
    }

    print("Function: $func");
    // sanitize the func variable
    func = func.replaceAll(" ", "");
    return func;
  }

  extractTargetId(String assistantResponse) {
    // get the next character after the word "proyecto:"
    var index = assistantResponse.indexOf("proyecto: ");
    var targetId = assistantResponse.substring(index + 9, index + 10);
    print("Target id: $targetId");
    return targetId;
  }

  handleIntentionConfirmation() {
    print("Handling intention confirmation");
    // handleNavigation();
    _optionsActive = false;
  }

  int extractFirstNumber(String inputString) {
    RegExp regExp = RegExp(r'\d+');
    RegExpMatch? match = regExp.firstMatch(inputString);
    return match != null ? int.parse(match.group(0)!) : -1;
  }

  int extractNumbers(String inputString) {
    RegExp regExp = RegExp(r'\d+');
    Iterable<RegExpMatch> matches = regExp.allMatches(inputString);
    List<int> numbers = matches.map((m) => int.parse(m.group(0)!)).toList();
    return numbers[0];
  }

  void insertMessage(
    String message,
    bool isBot,
  ) {
    print("Inserting message: $message");

    _listKey.currentState!.insertItem(
      _messages.length,
      duration: Duration(milliseconds: 500),
    );
    _messages.add({
      "content": message,
      "isBot": isBot,
    });

    scrollToBottom(); // Call scrollToBottom here

    notifyListeners();
  }
}

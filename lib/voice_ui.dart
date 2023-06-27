import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:learning/chatbot_ui.dart';
import 'package:learning/gpt_response.dart';
import 'package:learning/projects_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _transcriptionText = "";
  GptResponse? _transcriptionWidget;
  bool _isBotActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recorder & Transcription"),
      ),
      body: Column(
        children: [
          Expanded(
              child:
                  SimpleRecorder(onRecordingComplete: transcribeRecordedAudio)),
          Divider(thickness: 2, color: Colors.black),
          Expanded(child: transcriptionContent()),
          if (_transcriptionWidget != null) _transcriptionWidget!,
        ],
      ),
    );
  }

  createChatCompletion(String transcription) async {
    print('Creating chat completion');
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final openAiApiKey = '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';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAiApiKey',
    };

    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': transcription}
      ],
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print("Response data: $responseData");
      final assistantResponse =
          responseData['choices'][0]['message']['content'];
      print('Assistant response: $assistantResponse');
      // _playAudio();
      setState(() {
        _transcriptionWidget = GptResponse(transcription: assistantResponse);
      });
    } else {
      print('Failed to get a response from the API');
    }
  }

  void transcribeRecordedAudio(String filePath) {
    convertSpeechToText(filePath).then((value) {
      // createChatCompletion(value);
      // _playAudio();

      print("Transcription: $value");

      // check if the value contains the words vegi
      // if yes then play the audio

      // var validWords = [
      //   "veggie",
      //   "veggiebot",
      //   "veggie bot",
      //   "VeggieBot",
      //   "VeggieBot, activate!",
      //   "VeggieBot, activate"
      // ];

      // // if (value.contains(validWords[0]) ||
      // //     value.contains(validWords[1]) ||
      // //     value.contains(validWords[2]) ||
      // //     value.contains(validWords[3]) ||
      // //     value.contains(validWords[4]) ||
      // //     value.contains(validWords[5])) {
      // //   _playAudio();
      // //   _isBotActive = true;
      // // }

      setState(() {
        _transcriptionText = value;
      });
    });
  }

  Widget transcriptionContent() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Mensaje: " + _transcriptionText,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }

  Future<void> _playAudio() async {
    try {
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/audios/botVoice.mp3"),
        autoStart: true,
        showNotification: true,
      );
    } on PlatformException catch (e) {
      print('Error playing audio: ${e.message}');
    }
  }

  Future<String> convertSpeechToText(String filePath) async {
    const apiKey = "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";
    var url = Uri.https("api.openai.com", "v1/audio/transcriptions");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(({"Authorization": "Bearer $apiKey"}));
    request.fields["model"] = 'whisper-1';
    request.fields["language"] = "en";
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    var response = await request.send();
    var newresponse = await http.Response.fromStream(response);
    final responseData = json.decode(newresponse.body);

    if (responseData.containsKey('text')) {
      return responseData['text'];
    } else {
      return "Transcription failed. Please try again.";
    }
  }
}

// Include your SimpleRecorder class here
typedef _Fn = void Function();

/* This does not work. on Android we must have the Manifest.permission.CAPTURE_AUDIO_OUTPUT permission.
 * But this permission is _is reserved for use by system components and is not available to third-party applications._
 * Pleaser look to [this](https://developer.android.com/reference/android/media/MediaRecorder.AudioSource#VOICE_UPLINK)
 *
 * I think that the problem is because it is illegal to record a communication in many countries.
 * Probably this stands also on iOS.
 * Actually I am unable to record DOWNLINK on my Xiaomi Chinese phone.
 *
 */
//const theSource = AudioSource.voiceUpLink;
//const theSource = AudioSource.voiceDownlink;

const theSource = AudioSource.microphone;

/// Example app.
class SimpleRecorder extends StatefulWidget {
  final Function(String)? onRecordingComplete;

  const SimpleRecorder({Key? key, this.onRecordingComplete}) : super(key: key);

  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    await openTheRecorder();

    // Generate the recording file path using the path_provider package
    final directory = await getApplicationDocumentsDirectory();
    _mPath = p.join(directory.path, 'tau_file.mp4');

    setState(() {
      _mRecorderIsInited = true;
    });
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        // var url = value;
        _mplaybackReady = true;
      });

      if (widget.onRecordingComplete != null) {
        widget.onRecordingComplete!(_mPath);
      }
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(children: [
              ElevatedButton(
                onPressed: getRecorderFn(),
                //color: Colors.white,
                //disabledColor: Colors.grey,
                child: Text(_mRecorder!.isRecording ? 'Stop' : 'Record'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(_mRecorder!.isRecording
                  ? 'Recording in progress'
                  : 'Recorder is stopped'),
            ]),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: makeBody(),
    );
  }
}

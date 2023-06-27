import 'package:flutter/material.dart';

import 'package:learning/UI/interactions_ui.dart';
import 'package:learning/UI/professionals_chat.dart';
import 'package:learning/chatbot_ui.dart';
import 'package:learning/models/general_model.dart';
import 'package:learning/project_ui.dart';
import 'package:learning/projects_page.dart';

import 'package:provider/provider.dart';

import 'UI/create_interaction.dart';
import 'UI/create_project.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => GeneralModel(),
    child: MaterialApp(
        // remove debug banner
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Color.fromARGB(255, 247, 247, 247),
          primaryColor: Colors.black,
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
            ),
            headline6: TextStyle(
                fontSize: 24.0,
                // fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Hind',
            ),
          ),
        ),
        routes: {
          '/': (context) => ChatBotPage(),
          // '/projects': (context) => Projects(),
          // '/create_project': (context) => CreateProjectUI(),
          // '/project': (context) {
          //   final Map<String, String> arguments = ModalRoute.of(context)!
          //       .settings
          //       .arguments as Map<String, String>;
          //   return ProjectUI(project: arguments);
          // },
          '/create_interaction': (context) => CreateInteractionUI(),
          // '/interactions': (context) => InteractionsUI(),
          '/pros': (context) => ProfessionalsChat(),
        }),
  ));
  // runApp(MaterialApp(home: MyApp()));
}

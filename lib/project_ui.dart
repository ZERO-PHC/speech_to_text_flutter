// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'models/general_model.dart';

// class ProjectUI extends StatefulWidget {
//   final Map project;

//   const ProjectUI({Key? key, required this.project}) : super(key: key);

//   @override
//   _ProjectUIState createState() => _ProjectUIState();
// }

// class _ProjectUIState extends State<ProjectUI> {
//   @override
//   Widget build(BuildContext context) {
//     getProjectIndex() {
//       // parse the project id from the widget.project['id'] string to int
//       final id = int.parse(widget.project['id']) - 1;
//       return id;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Project ${widget.project['id']}'),
//       ),
//       body: Consumer<GeneralModel>(
//         builder: (context, generalModel, child) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Project ID: ${widget.project['name']}',
//                   style: TextStyle(fontSize: 24),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Project Information:',
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 Switch(
//                   value: widget.project['available'],
//                   onChanged: (value) {
//                     print("Switch: $value");
//                     Provider.of<GeneralModel>(context, listen: false)
//                         .toggleSwitch(widget.project['id'], value);
//                   },
//                 ),

//                 // Add more widgets to display project information based on the id
//                 if (generalModel.projects[getProjectIndex()]["available"])
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 16),
//                         Text(
//                           'Maintenance Steps:',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: generalModel
//                                 .selectedProject["processes"].length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: CheckboxListTile(
//                                   title: Text('${index + 1}. Check oil level'),
//                                   value:
//                                       generalModel.projects[getProjectIndex()]
//                                           ["processes"][index],
//                                   onChanged: (bool? value) {
//                                     generalModel.toggleStep(
//                                         widget.project['id'],
//                                         index,
//                                         value ?? false);
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

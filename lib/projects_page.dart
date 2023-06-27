// import 'package:flutter/material.dart';
// import 'package:learning/models/general_model.dart';
// import 'package:provider/provider.dart';

// import 'project_ui.dart';

// class Projects extends StatelessWidget {
//   const Projects({super.key});

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
//         title: Text('Proyectos', style: TextStyle(color: Colors.white)),
//       ),
//       body: Consumer<GeneralModel>(
//         builder: (context, generalModel, child) {
//           return ListView.builder(
//             // itemCount: generalModel.projects.length,
//             itemBuilder: (context, index) {
//               // final project = generalModel.projects[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(project['name']),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProjectUI(project: project),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //     builder: (context) => ProjectUI(project: null),
//           //   ),
//           // );
//         },
//         child: Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }

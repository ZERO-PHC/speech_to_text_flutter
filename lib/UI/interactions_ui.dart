// import 'package:flutter/material.dart';
// import 'package:learning/models/general_model.dart';
// import 'package:provider/provider.dart';

// class InteractionsUI extends StatelessWidget {
//   const InteractionsUI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundImage: NetworkImage(
//                 'https://res.cloudinary.com/ddbgaessi/image/upload/v1682111078/terrabot_pgmdes.png'),
//           ),
//         ),
//         title: Text('TerraBot', style: TextStyle(color: Colors.white)),
//       ),
//       body: Center(
//         child: Consumer(
//           builder: (context, GeneralModel model, child) => ListView.builder(
//             itemCount: model.interactions.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(model.interactions[index]['title']),
//                 leading: CircleAvatar(
//                   backgroundImage: AssetImage(model.interactions[index]['img']),
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     model.removeProject(model.interactions[index]);
//                   },
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/create_interaction');
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

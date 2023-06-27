// import 'package:flutter/material.dart';
// import 'package:learning/models/general_model.dart';
// import 'package:provider/provider.dart';

// class CreateProjectUI extends StatefulWidget {
//   @override
//   _CreateProjectUIState createState() => _CreateProjectUIState();
// }

// class _CreateProjectUIState extends State<CreateProjectUI> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Create Project')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name')),
//             TextField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(labelText: 'Description')),
//             TextField(
//                 controller: _startDateController,
//                 decoration: InputDecoration(labelText: 'Start Date')),
//             TextField(
//                 controller: _endDateController,
//                 decoration: InputDecoration(labelText: 'End Date')),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               child: Text('Submit'),
//               onPressed: () {
//                 String name = _nameController.text;
//                 String description = _descriptionController.text;
//                 String startDate = _startDateController.text;
//                 String endDate = _endDateController.text;
//                 Provider.of<GeneralModel>(context, listen: false).addProject(
//                   name,
//                 );
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/clea.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/general_model.dart';

class CreateInteractionUI extends StatefulWidget {
  @override
  _CreateInteractionUIState createState() => _CreateInteractionUIState();
}

class _CreateInteractionUIState extends State<CreateInteractionUI> {
  late File _image = File('');
  var _imagePath = "";
  // final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    // setState(() {
    //   _image = File(image!.path);
    //   _imagePath = image!.path;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear interacción'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Evidencia',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: Text('Seleccionar imagen '),
                  onPressed: getImage,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  child: Text('Publicar'),
                  onPressed: () {
                    Provider.of<GeneralModel>(context, listen: false)
                        .addInteraction(
                      'Interaction 1',
                      _imagePath,
                    );

                    // navigate to the interactions page
                    Navigator.pushNamed(context, '/interactions');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

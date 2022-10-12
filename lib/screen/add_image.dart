import 'dart:io';

import 'package:chalkboard/model/FirebaseFile.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddImage extends StatefulWidget {
  final String uid;

  const AddImage({Key? key, required this.uid}) : super(key: key);
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;

  List<File> _image = [];
  final picker = ImagePicker();

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await picker.pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      Navigator.of(context).pop();
      setState(() => _image.add(imageTemporary));
    } on Exception catch (e) {
      print('Failed to pick image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to pick image: $e"),
      ));
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose One Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildButton(
            title: 'Pick Gallery',
            icon: Icons.image_outlined,
            onClicked: () => pickImage(ImageSource.gallery),
          ),
          const SizedBox(
            height: 24,
          ),
          buildButton(
            title: 'Pick Camera',
            icon: Icons.camera_alt_outlined,
            onClicked: () => pickImage(ImageSource.camera),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Image'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                              color: Colors.red,
                              icon: const Icon(Icons.add_a_photo_rounded,
                                  size: 50),
                              onPressed: () {
                                !uploading
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _buildPopupDialog(context);
                                        },
                                      )
                                    : null;
                              },
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: const Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        ));
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      final name = Path.basename(img.path);
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('documents/${widget.uid}/$name');
      await ref.putFile(img).whenComplete(() async {
        final url = await ref.getDownloadURL();
        FirebaseFile file = FirebaseFile(
            ref: ref, name: name, url: url, uploadTime: DateTime.now());
        await FirestoreApi.postDocument(file, widget.uid);
      });
      i++;
    }
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(56),
          primary: Colors.white,
          onPrimary: Colors.black,
          textStyle: TextStyle(fontSize: 20),
        ),
        onPressed: onClicked,
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(title)
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
  }
}

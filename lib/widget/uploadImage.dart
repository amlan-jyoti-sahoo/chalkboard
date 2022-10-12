import 'package:chalkboard/screen/add_image.dart';
import 'package:chalkboard/screen/myDocuments.dart';
import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('upload your data'),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 600,
                    color: Colors.amber,
                    child: AddImage(uid: widget.uid),
                  );
                });
          },
        ),
        ElevatedButton(
          child: const Text('My Uploaded Documents'),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 600,
                    color: Colors.amber,
                    child: MyDocuments(uid: widget.uid),
                  );
                });
          },
        ),
      ],
    );
  }
}

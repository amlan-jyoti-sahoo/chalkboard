import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/FirebaseFile.dart';
import '../services/firestoreApi.dart';

Future<void> showExceptionAlertDialog(BuildContext context,
    {required String title, required Exception exception}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(_message(exception)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        )
      ],
    ),
  );
}

String _message(Exception exception) {
  if (exception is FirebaseException) {
    return exception.message!;
  }
  return exception.toString();
}

Future<void> showNormalAlretDialog(BuildContext context,
    {required String title, required String message}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'OK',
            style: TextStyle(color: Colors.green),
          ),
        )
      ],
    ),
  );
}

class ShowRenameDialog extends StatefulWidget {
  const ShowRenameDialog({Key? key, required this.uid, required this.file})
      : super(key: key);
  final String uid;
  final FirebaseFile file;

  @override
  _ShowRenameDialogState createState() => _ShowRenameDialogState();
}

class _ShowRenameDialogState extends State<ShowRenameDialog> {
  TextEditingController renamecontroller = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    renamecontroller.text = widget.file.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: isLoading ? Text('Renaming...') : Text('Rename File'),
      content: isLoading
          ? Center(
              heightFactor: 2,
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : TextField(
              controller: renamecontroller,
            ),
      actions: <Widget>[
        if (!isLoading)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
            child: const Text('Cancle'),
          ),
        if (!isLoading)
          TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              widget.file.name = renamecontroller.text;
              await FirestoreApi.renameFile(widget.uid, widget.file);
              Navigator.of(context).pop();
              setState(() {
                isLoading = false;
              });
            },
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
            child: const Text('Save'),
          ),
      ],
    );
  }
}

class ShowDeleteDialog extends StatefulWidget {
  const ShowDeleteDialog({Key? key, required this.uid, required this.file})
      : super(key: key);
  final String uid;
  final FirebaseFile file;

  @override
  _ShoweleteDialogState createState() => _ShoweleteDialogState();
}

class _ShoweleteDialogState extends State<ShowDeleteDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isLoading ? 'Deleting file ..' : 'Delete File',
          style: TextStyle(color: Colors.red)),
      content: isLoading
          ? Center(
              heightFactor: 2,
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : Text('do you want to delete this file permanently ?'),
      actions: <Widget>[
        if (!isLoading)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
            child: const Text('Cancle'),
          ),
        if (!isLoading)
          TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await FirestoreApi.deleteFile(widget.uid, widget.file);
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop();
            },
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}

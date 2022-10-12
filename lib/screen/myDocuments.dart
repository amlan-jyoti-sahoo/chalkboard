import 'package:cached_network_image/cached_network_image.dart';
import 'package:chalkboard/model/FirebaseFile.dart';
import 'package:chalkboard/screen/view_image.dart';
import 'package:chalkboard/services/cacheManager.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:flutter/material.dart';

import '../widget/alret_dialog.dart';
import 'add_image.dart';

class MyDocuments extends StatefulWidget {
  MyDocuments({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<MyDocuments> createState() => _MyDocumentsState();
}

class _MyDocumentsState extends State<MyDocuments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<FirebaseFile>>(
        stream: FirestoreApi.getFileStream(widget.uid),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(files.length),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];

                          return buildFile(context, file);
                        },
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            cacheManager: AppCacheManager.documentCacheManager,
            imageUrl: file.url,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
            'uploaded on ${file.uploadTime.day}/${file.uploadTime.month}/${file.uploadTime.year}'),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'rename',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Rename'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(
                      width: 20,
                    ),
                    Text('Delete'),
                  ],
                ),
              )
            ];
          },
          onSelected: (String value) async {
            switch (value) {
              case 'rename':
                {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowRenameDialog(uid: widget.uid, file: file);
                      });
                }

                break;
              case 'delete':
                {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowDeleteDialog(
                          uid: widget.uid,
                          file: file,
                        );
                      });
                }
                break;
            }
          },
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewImage(
                file: file,
              ),
            ),
          );
        },
      );

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.grey,
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.orange,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        subtitle: TextButton(
          child: Text("upload file"),
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
      );
}

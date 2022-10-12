import 'package:cached_network_image/cached_network_image.dart';
import 'package:chalkboard/model/FirebaseFile.dart';
import 'package:chalkboard/services/cacheManager.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final FirebaseFile file;
  const ViewImage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);

    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              await FirestoreApi.downloadFile(file.ref);

              final snackBar = SnackBar(
                content: Text('Downloaded ${file.name}'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isImage
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  minScale: 1,
                  maxScale: 4,
                  child: CachedNetworkImage(
                    imageUrl: file.url,
                    fit: BoxFit.cover,
                    cacheManager: AppCacheManager.documentCacheManager,
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                'Cannot be displayed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}

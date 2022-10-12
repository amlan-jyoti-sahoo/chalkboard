import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile {
  final String? fileId;
  final Reference ref;
  String name;
  final String url;
  final DateTime uploadTime;

  FirebaseFile(
      {required this.ref,
      required this.name,
      required this.url,
      this.fileId,
      required this.uploadTime});

  static FirebaseFile fromJson(json, String fileid) {
    return FirebaseFile(
      ref: FirebaseStorage.instance.ref(json['reference']),
      name: json['file name'],
      url: json['url'],
      fileId: fileid,
      uploadTime: json['upload time'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.ref.fullPath;
    data['file name'] = this.name;
    data['url'] = this.url;
    data['upload time'] = this.uploadTime;
    return data;
  }
}

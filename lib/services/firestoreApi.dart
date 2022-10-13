import 'dart:io';

import 'package:chalkboard/model/address.dart';
import 'package:chalkboard/model/donation.dart';
import 'package:chalkboard/model/user.dart';
import 'package:chalkboard/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/FirebaseFile.dart';

class FirestoreApi {
  final db = FirebaseFirestore.instance;

  // firestore api for user -------

  Future<void> userSignUpWithEmail(
      User newUser, Address address, BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final user = await auth.createUserWithEmailAndPassword(
      newUser.email,
      newUser.password!,
    );
    if (user != null) {
      DocumentReference ref = db.doc('users/${user.uid}');
      await ref.set(newUser.toJson()).then((_) async {
        DocumentReference ref =
            db.doc('users/${user.uid}/addresses/first_address');
        await ref.set(address.toJson());
      });
      user.updateDisplayName('Chalkboard USER');
      auth.signOut();
    }
  }

  Future<void> userSignUpWithThirdparyProvider(
      User newUser, Address address, BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final user = auth.currentuser;
    if (user != null) {
      DocumentReference ref = db.doc('users/${user.uid}');
      await ref.set(newUser.toJson()).then((_) async {
        DocumentReference ref =
            db.doc('users/${user.uid}/addresses/first_address');
        await ref.set(address.toJson());
      });
    }
    user!.updateDisplayName('Chalkboard USER');
  }

  Stream<User?> getCurrentUserDetailsStream(String userId) {
    DocumentReference ref = db.doc('users/${userId}');
    final snapshot = ref.snapshots();
    return snapshot.map((snapshot) => User.fromJson(snapshot.data()));
  }

  Future<Address> getUserDefaultAddress(
      String defaultAddressId, String uid) async {
    DocumentReference ref = db.doc('users/$uid/addresses/$defaultAddressId');
    final snapshot = await ref.get();
    return Address.fromJson(snapshot.data());
  }

  Future<bool> isNewIser(String userId) async {
    DocumentReference ref = db.doc('users/${userId}');
    final snapshot = await ref.get();
    return !snapshot.exists;
  }

  static Future<void> uploadProfilePicture(
      String uid, File file, User currentUser) async {
    try {
      final ref = FirebaseStorage.instance.ref('profile/$uid');
      UploadTask? task = ref.putFile(file);
      final snapshot = await task.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      DocumentReference refuser = FirebaseFirestore.instance.doc('users/$uid');
      currentUser.profileUrl = url;
      await refuser.update(currentUser.toJson());
    } on FirebaseException catch (e) {
      throw e;
    }
  }
  //--------------------------------------------------------------------------

  // firestore api for file upload -------
  static Future<void> postDocument(FirebaseFile file, String uid) async {
    CollectionReference ref =
        FirebaseFirestore.instance.collection('users/$uid/documents');
    var jsonfile = file.toJson();
    await ref.add(jsonfile);
  }

  static Stream<List<FirebaseFile>> getFileStream(String uid) {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('users/$uid/documents');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => FirebaseFile.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }

  static Future<void> renameFile(String uid, FirebaseFile file) async {
    DocumentReference ref =
        FirebaseFirestore.instance.doc('users/$uid/documents/${file.fileId}');
    await ref.update(file.toJson());
  }

  static Future<void> deleteFile(String uid, FirebaseFile file) async {
    DocumentReference ref =
        FirebaseFirestore.instance.doc('users/$uid/documents/${file.fileId}');
    await ref.delete();
  }
  //--------------------------------------------------------------------------

  // firestore api for donation-------

  Stream<List<Donation>> getDonationStream() {
    CollectionReference reference = db.collection('Donations');
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Donation.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  Future<Donation> getDonationById(String id) async {
    DocumentReference ref = db.doc('Donations/$id');
    DocumentSnapshot snapshot = await ref.get();
    return Donation.fromJson(snapshot.data(), snapshot.id);
  }

  Future<void> postDonation(Donation donation) async {
    CollectionReference ref = db.collection('Donations');
    await ref.add(donation.toJson());
  }

  Future<void> editDonation(Donation donation, String oldDonationId) async {
    DocumentReference ref = db.doc('Donations/$oldDonationId');
    await ref.update(donation.toJson());
  }

  Stream<List<Donation>> getMyDonation({required String uid}) {
    final reference =
        db.collection('Donations').where('donor id', isEqualTo: uid);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => Donation.fromJson(snapshot.data(), snapshot.id))
        .toList());
  }

  Future<void> deleteMyDonation(String donationId) async {
    DocumentReference ref = db.doc('Donations/$donationId');
    await ref.delete();
  }

  //--------------------------------------------------------------------------

}
import 'package:chalkboard/model/user.dart';
import 'package:chalkboard/services/auth.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widget/bottomNavigationBarWidget.dart';

class LoadUserData extends StatefulWidget {
  const LoadUserData({Key? key}) : super(key: key);

  @override
  _LoadUserDataState createState() => _LoadUserDataState();
}

class _LoadUserDataState extends State<LoadUserData> {
  bool isLoading = true;
  late bool newUser;
  User user = User(
      firstName: '',
      lastName: '',
      email: '',
      role: '',
      phoneNumber: '',
      ratingCount: 0,
      avgRating: 0,
      donationCount: 0,
      defaultAddressId: '',
      joinedOn: DateTime.now(),
      cartItemCount: 0);
  Stream<User?>? currentUserStream;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final auth = Provider.of<Auth>(context, listen: false);
    final db = Provider.of<FirestoreApi>(context, listen: false);
    newUser = await db.isNewIser(auth.currentuser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final db = Provider.of<FirestoreApi>(context, listen: false);
    return isLoading
        ? Container(
            color: Colors.white70,
            child: Center(
              child: SpinKitSquareCircle(
                color: Colors.greenAccent,
              ),
            ),
          )
        : (newUser == true
            ? BottomNavigationBarWidget( newuser: true)
            : StreamProvider<User?>.value(
                value: db.getCurrentUserDetailsStream(auth.currentuser!.uid),
                initialData: user,
                child: BottomNavigationBarWidget(newuser: false),
              ));
  }
}

import 'package:chalkboard/screen/splash_screen.dart';
import 'package:chalkboard/services/auth.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (_) => Auth()),
        Provider<FirestoreApi>(create: (_) => FirestoreApi()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chalkboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  SpalshScreen(),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapplication2/ecommerse/producatpage.dart';
import 'package:flutterapplication2/ecommerse/profilePage.dart';
import 'package:flutterapplication2/ecommerse/signin.dart';
import 'package:flutterapplication2/ecommerse/signup.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA28t9Vf2OCP9W8xhEjeJDQ2mGQ7Kf1XTk",
      appId: "1:1051727939430:android:1ada7996dc9d45c85deaa7",
      messagingSenderId: "1051727939430",
      projectId: "commerce-447de",
    ),
  ); 
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInPage(),
      routes: {
        '/signup': (context) => SignUpPage(),
        '/signin': (context) => SignInPage(),
        '/profile': (context) => ProfilePage(),
        '/products': (context) => ProductListingPage(),
      },
    );
  }
}

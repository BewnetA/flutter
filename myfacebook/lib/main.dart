import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCVfMG72biq6wscHbiWDDk-6w5uThmYhlY",
      authDomain: "facebookclone-81209.firebaseapp.com",
      projectId: "facebookclone-81209",
      storageBucket: "facebookclone-81209.firebasestorage.app",
      messagingSenderId: "1091847567450",
      appId: "1:1091847567450:web:e31d689d38406bda468063"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook UI Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

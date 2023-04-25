import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //Firebase configuration
    options: const FirebaseOptions(
        apiKey: "AIzaSyBh9tPEcZPbhPGXjnGoN343tS4xsFhjNPI",
        authDomain: "electionssystem-381414.firebaseapp.com",
        projectId: "electionssystem-381414",
        storageBucket: "electionssystem-381414.appspot.com",
        messagingSenderId: "260982386941",
        appId: "1:260982386941:web:de77c0a49c1c5aac9a8e94",
        measurementId: "G-QL50DL3W9E"
    ),
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/home': (BuildContext context) => const LoginPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

//Splash screen
class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/blink.png'),
            const SizedBox(height: 60),
            const Text(
              'I am seen... are you?',
              style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Pacifico'),
            ),
          ],
        ),
      ),
    );
  }
}


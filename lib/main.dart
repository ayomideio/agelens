import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/user-taskbar/homescreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:readmitpredictor/ui/welcome/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shake_gesture/shake_gesture.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyDv7GZgSO8QxH5J8cvOQ9wcrm2oNJAng-A',
    appId: '1:144014575055:android:6582f50bd6f82750a1feba',
    messagingSenderId: 'sendid',
    projectId: 'yarsmarketplace',
    storageBucket: 'yarsmarketplace.appspot.com',
  ));
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MyApp(
      prefs: prefs,
    ),
  );
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _shakeCount = 0;

  Future<void> _makeEmergencyCall() async {
    await launchUrl(Uri.parse("999"));
  }

  @override
  Widget build(BuildContext context) {
    return ShakeGesture(
        onShake: () {
          print("shaked");
          setState(() {
            _shakeCount++;
            if (_shakeCount >= 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling')),
              );
              _makeEmergencyCall();
              _shakeCount = 0; // Reset the shake count after dialing
            }
          });
        },
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Issy Travel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: SplashScreen(),
      ),
    );
  }
}

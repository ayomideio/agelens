import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/user-taskbar/homescreen.dart';
import 'package:readmitpredictor/ui/welcome/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
 
  await Firebase.initializeApp(
     options: FirebaseOptions(
    apiKey: 'AIzaSyDtG9STBp6XG_2R82v3VCsGXkpWvuMIt14',
    appId: '1:414238529271:android:c42eb68810bce18b39a5f2',
    messagingSenderId: '',
    
    projectId: 'readmit-predictor.appspot.com',
    storageBucket: 'readmit-predictor.appspot.com',
  )
  ).then((value) => runApp(
        MyApp(
          prefs: prefs,
        ),
      ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'predictcare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

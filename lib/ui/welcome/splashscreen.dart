import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readmitpredictor/ui/user-taskbar/homescreen.dart';

import 'package:readmitpredictor/ui/welcome/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool showAppLabel = true; // Set to true initially to show "Ade"
  late AnimationController _controller;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );

    _textAnimation = Tween<Offset>(
      begin: Offset(0, 0), // Start from the normal position
      end: Offset(0, 8), // End at the extreme bottom
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (showAppLabel) {
      // Wait for 5 seconds and then hide the label
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          showAppLabel = false;
          _controller.forward();
        });
      });
    } else {
      _controller.forward();
    }

    // Navigate to the home screen after the animation is complete
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 5), () {
          // sendEmail();
          checkSignedIn();
        });
      }
    });
  }

  void checkSignedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //  await pref.clear();
    String _name = "" + pref.getString('firstName').toString();
    if (_name.length > 0) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              // UpdateKyc()
              Welcome(),
              // HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          }));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              // UpdateKyc()
              // Welcome()
              Welcome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: Container(
        color: Colors.white,
        height: screenSize.height,
        width: screenSize.width,
        child: ScaleTransition(
            scale: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/vectors/splash.png',
                  height: 60,
                  width: 160,
                ),
                Text('Predict Care')
              ],
            )),
      )),
    );
  }
}

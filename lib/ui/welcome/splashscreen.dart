import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> createDocument() async {
    // Reference to the Firestore collection
    CollectionReference collection =
        FirebaseFirestore.instance.collection('triplocale');

    // Document data to be added
    Map<String, dynamic> documentData = {
      'location': 'United Kingdom',
      'price': '500',
      'productDescription':
          "The Tower of London, located on the banks of the River Thames, is a historic castle with a history that spans nearly a thousand years. Originally built by William the Conqueror in 1066, it has served variously as a royal palace, fortress, and prison. The Tower is renowned for housing the Crown Jewels, including the famous Koh-i-Noor diamond. Visitors can explore the White Tower, which is the oldest part of the complex, as well as the Medieval Palace and the Bloody Tower, associated with the infamous imprisonment and execution of high-profile figures. The Tower’s Yeoman Warders, or Beefeaters, offer guided tours rich with tales of intrigue and history.",
      'productImage': [
        'https://images.unsplash.com/photo-1578580497088-96ced26b6806?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8VGhlJTIwR2lhbnQlRTIlODAlOTlzJTIwQ2F1c2V3YXl8ZW58MHx8MHx8fDA%3D',
        'https://plus.unsplash.com/premium_photo-1664304974999-4993bc2a9525?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8VGhlJTIwR2lhbnQlRTIlODAlOTlzJTIwQ2F1c2V3YXl8ZW58MHx8MHx8fDA%3D',
        'https://images.unsplash.com/photo-1499298792468-246b96c63730?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8VGhlJTIwR2lhbnQlRTIlODAlOTlzJTIwQ2F1c2V3YXl8ZW58MHx8MHx8fDA%3D',
      ],
      'productName': 'The Giant’s Causeway',
      'vendorId': 'The Giant’s Causeway',
      'vendorName': 'The Giant’s Causeway',
    };

    try {
      // Add the document to Firestore
      await collection.add(documentData);
      print('Document added successfully');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  void checkSignedIn() async {
    // await createDocument();
    SharedPreferences pref = await SharedPreferences.getInstance();
    //  await pref.clear();
    String _name = "" + pref.getString('firstName').toString();
    print("nameee ${_name}");
    if (!_name.contains('null')) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              // UpdateKyc()
              // HomeScreen(),
              // Welcome(),
              HomeScreen(),
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
        color: Color(0XFF29333D),
        height: screenSize.height,
        width: screenSize.width,
        child: ScaleTransition(
            scale: _controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/vectors/splash.png',
                  height: 160,
                  width: 160,
                ),
              ],
            )),
      )),
    );
  }
}

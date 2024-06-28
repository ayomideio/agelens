import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:readmitpredictor/ui/user-taskbar/homescreen.dart';

import 'package:readmitpredictor/ui/widgets/success.dart';

class VerificationSuccess extends StatefulWidget {
  const VerificationSuccess({super.key});

  @override
  State<VerificationSuccess> createState() => _VerificationSuccessState();
}

class _VerificationSuccessState extends State<VerificationSuccess> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Success(),
          SizedBox(
            height: 50,
          ),
          Text(
            "You are all set!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "You’ll be signed into your account in a ",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            "moment. If nothing happens, click",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            "continue",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: screenSize.height / 6,
          ),
          GestureDetector(
              onTap: () async {
                print('yes');
                // prefs.setBool('isLoggedIn', true);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext build) => HomeScreen()));
              },
              child: Container(
                width: screenSize.width / 1.1,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorStyles.primaryButtonColor,
                ),
                child: Center(
                  child: Text(
                    "Continhue",
                    style: TextStyle(
                        color: ColorStyles.screenColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ],
      )),
    );
  }
}

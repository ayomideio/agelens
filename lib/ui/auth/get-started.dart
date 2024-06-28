import 'package:readmitpredictor/ui/auth/signup.dart';
import 'package:readmitpredictor/ui/constants/colorstyles.dart';
import 'package:readmitpredictor/ui/auth/login.dart';
import 'package:readmitpredictor/ui/auth/phone.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Container(
          height: size.height,
          width: size.width,
          color: Color(0xffFFFFFF),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Image.asset(
                  "assets/vectors/onb3.png",
                  height: 200,
                ),
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  height: 191,
                  width: 295,
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        width: 295,
                        decoration: BoxDecoration(
                          color: ColorStyles.primaryButtonColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Text(
                            "Continue with phone number",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Comfortaa'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                     
                    ],
                  ),
                ),
                SizedBox(
                  height: 43,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(280, 50, 0, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (buildContext) => LoginScreen()));
                      },
                      child: Container(
                        width: size.width / 4,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ColorStyles.screenColor,
                        ),
                        child: Center(
                          child: Text(
                            "Log In ",
                            style: TextStyle(
                                color: ColorStyles.primaryButtonColor),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/auth/phone.dart';
import 'package:readmitpredictor/ui/user-taskbar/homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        child: Container(
          color: Color(0xffFFFFFF),
          height: screenSize.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'Sign in to your account',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff9CA3AF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Container(
                        height: 45,
                        width: screenSize.width / 1.1,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff6B6B6B)),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Image.asset(
                                'assets/vectors/google.png',
                                height: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(65, 0, 0, 0),
                              child: Text(
                                'Continue with google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Container(
                        height: 45,
                        width: screenSize.width / 1.1,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff6B6B6B)),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Image.asset(
                                'assets/vectors/apple.png',
                                height: 25,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(105, 0, 0, 0),
                              child: Text(
                                'Apple ID',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                        height: 30,
                        width: screenSize.width / 1.1,
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Container(
                                  height: 2,
                                  width: screenSize.width / 2.8,
                                  color: Color(0xffF3F4F6),
                                )),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff9CA3AF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Container(
                                  height: 2,
                                  width: screenSize.width / 2.8,
                                  color: Color(0xffF3F4F6),
                                )),
                          ],
                        ))),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text(
                        'Hospital Number',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: screenSize.width / 1.15,
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0xff9CA3AF)),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset(
                          'assets/vectors/mail.png',
                          height: 24,
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width / 20,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Email address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(22, 15, 0, 0),
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: screenSize.width / 1.15,
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Color(0xff9CA3AF)),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset(
                          'assets/vectors/pass.png',
                          height: 24,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff9CA3AF),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(220, 0, 0, 0),
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff61E3A5F)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext build) =>
                                HomeScreen()));
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                    child: Container(
                      width: screenSize.width / 1.15,
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Color(0xff61E3A5F),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                        text: ' Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff61E3A5F)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

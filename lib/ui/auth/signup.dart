import 'package:flutter/material.dart';
import 'package:readmitpredictor/ui/auth/login.dart';
import 'package:readmitpredictor/ui/auth/phone.dart';
import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText = true;
  bool _isChecked = false;
  String email = "", firstname = "", password = '';
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

                 SizedBox(height: 100,),
                Image.asset(
                  "assets/vectors/signup.png",
                  height: 200,
                  width: screenSize.width,
                ),
               SizedBox(
                  height: 50,
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
                          'assets/vectors/contact.png',
                          height: 24,
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width / 20,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              firstname = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Full Name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
               
                SizedBox(
                  height: 20,
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
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              email = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Hospital Number',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(
                  height: 20,
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
                          onChanged: (value) {
                            setState(() {
                              password = value.toString();
                            });
                          },
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
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    if (email.length < 3 ||
                        firstname.length < 4 ||
                        password.length < 3) {
                      const snackBar = SnackBar(
                        content: Text('All Fields are required'),
                      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('firstName', firstname);
                      prefs.setString('email', email);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext build) =>
                                  TwoStepPhoneScreen()));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                    child: Container(
                      width: screenSize.width / 1.15,
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: ColorStyles.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
                            builder: (BuildContext build) => LoginScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Already have an account?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: ' login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff61E3A5F)),
                        ),
                      ],
                    ),
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

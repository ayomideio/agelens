import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readmitpredictor/ui/auth/login.dart';
import 'package:readmitpredictor/ui/auth/verifyemail.dart';
import 'package:readmitpredictor/ui/auth/verifyphone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readmitpredictor/ui/auth/verification_success.dart';
import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText = true;
  String email = "", password = "", firstname = "", lastname = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _sendVerificationCode(String email) async {
    // Generate a 6-digit code
    String code = (Random().nextInt(900000) + 100000).toString();
    final String apiUrl = "http://18.225.156.117:5000/api/sendmail";
  final Map<String, dynamic> data = {
    'email_body': 'Your Otp Code is ${code}',
    'email': email,
  };

  try {
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      await _firestore.collection('emailVerifications').doc(email).set({
        'code': code,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Email sent to $email");
      // Here you would update your success count
      // setState(() {
      //   successCount += 1;
      // });
    } else {
      print("Failed to send email to $email");
    }
  } catch (e) {
    print("Error occurred: $e");
  }
   

    // Send code to user's email (using Firebase, SMTP, etc.)
    // This depends on the email sending service you're using
    // For example, if using an SMTP server, you would configure that here.

    // Store the code and email in Firestore for later verification

    // print("Verification code sent to $email: $code");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        child: Container(
          color: ColorStyles.primaryButtonColor,
          height: screenSize.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  "assets/vectors/splash.png",
                  height: 200,
                  width: screenSize.width,
                ),
                SizedBox(height: 50),
                _buildTextField(
                  hint: "First Name",
                  icon: 'assets/vectors/contact.png',
                  onChanged: (value) => firstname = value,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  hint: "Last Name",
                  icon: 'assets/vectors/contact.png',
                  onChanged: (value) => lastname = value,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  hint: "Email",
                  icon: 'assets/vectors/mail.png',
                  onChanged: (value) => email = value,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  hint: "Password",
                  icon: 'assets/vectors/pass.png',
                  onChanged: (value) => password = value,
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xffF3C204),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                
                _buildSignUpButton(context),

                SizedBox(height: 20),
                _buildLoginText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required String icon,
    required Function(String) onChanged,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.15,
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Color(0xffF3C204)),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Image.asset(
              icon,
              height: 24,
              color: Color(0xffF3C204),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width / 20),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xffF3C204)),
              ),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          if (suffixIcon != null) suffixIcon,
        ],
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (email.isEmpty ||
            firstname.isEmpty ||
            lastname.isEmpty ||
            password.isEmpty) {
          const snackBar = SnackBar(content: Text('All Fields are required'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          try {
            UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
            User? user = userCredential.user;
               final firestoreInstance = FirebaseFirestore.instance;


      // Add document to a collection (e.g., 'users')
       firestoreInstance.collection('user').doc(user?.email.toString()).set({
        'fullName': firstname,
        'email':user?.email.toString(),
        'password': password,
        'phoneNumber': '',
        'address': '',
        'location': '',
        'trips':[],
        'orders':[],
      });

            if (user != null && !user.emailVerified) {
              // await user.sendEmailVerification();
              await _sendVerificationCode(user.email.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Verification email sent. Please check your inbox.')),
              );

              // Navigate to the VerificationSuccess screen
              SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('firstName', firstname);
            prefs.setString('lastName', lastname);
            prefs.setString('email', email);
               Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext build) => VerificationSuccess()),
        );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => VerifyEmailScreen(
              //       email: user.email.toString(),
              //     ),
              //   ),
              // );
            }

            
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.15,
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 18,
                  color: ColorStyles.primaryButtonColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext build) => LoginScreen()),
        );
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
                text: 'Already have an account?',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            TextSpan(
                text: ' login',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readmitpredictor/ui/user-taskbar/homescreen.dart';
import 'package:readmitpredictor/ui/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  Future<void> _getUserDataAndStore(String email) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the user's document using the email as the document ID
      DocumentSnapshot userDoc =
          await firestore.collection('user').doc(email).get();

      if (userDoc.exists) {
        // Retrieve data from the document
        String firstName = userDoc['fullName'];
        String lastName = userDoc['fullName'];
        String email = userDoc['email'];

        // Store data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('firstName', firstName);
        prefs.setString('lastName', lastName);
        prefs.setString('email', email);

        // You can also print or use the data as needed
        print("User Data: $firstName $lastName, Email: $email");
      } else {
        print("No such document!");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _getUserDataAndStore(_emailController.text.trim());
      // Navigate to the home screen upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors appropriately
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: Center(
        child: Container(
          color: const Color(0xffFFFFFF),
          height: screenSize.height,
          width: screenSize.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 130, 0, 0),
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text(
                  'Sign in to your account',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff9CA3AF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // Other UI code for Google/Apple sign-in buttons and OR divider...
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: screenSize.width / 1.15,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xff9CA3AF)),
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
                      SizedBox(width: screenSize.width / 20),
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenSize.width / 1.15,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: const Color(0xff9CA3AF)),
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: const InputDecoration(
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
                          color: const Color(0xff9CA3AF),
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(220, 0, 0, 0),
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff61E3A5F),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _signInWithEmailAndPassword,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 5),
                    child: Container(
                      width: screenSize.width / 1.15,
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: const Color(0xff61E3A5F),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap:(){
                     Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreen(
                    
                  ),
                ),
              );
                  },

                  child:  RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff61E3A5F),
                        ),
                      ),
                    ],
                  ),
                ),
                )
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}

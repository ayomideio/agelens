import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readmitpredictor/ui/auth/verification_success.dart';
import 'package:readmitpredictor/ui/constants/index.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  String erro = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyCode(String code) async {
    try {
      // Retrieve the stored code from Firestore
      DocumentSnapshot doc = await _firestore
          .collection('emailVerifications')
          .doc(widget.email)
          .get();

      if (doc.exists) {
        String storedCode = doc['code'];

        if (storedCode == code) {
          // Code is correct, proceed to success screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VerificationSuccess()),
          );
        } else {
          setState(() {
            erro = "Invalid code. Please try again.";
          });
        }
      } else {
        setState(() {
          erro = "Verification failed. Please request a new code.";
        });
      }
    } catch (e) {
      setState(() {
        erro = "An error occurred. Please try again.";
      });
    }
  }

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
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 80, 0, 0),
                      child: Text(
                        'Enter the 6-digit code sent to\nyou at ' +
                            widget.email,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 40,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffEEEEEE)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          }
                          if (index == 5) {
                            // Automatically verify when all fields are filled
                            bool allFilled = controllers.every(
                                (controller) => controller.text.isNotEmpty);
                            if (allFilled) {
                              // Hide the keyboard
                              FocusScope.of(context).unfocus();

                              // Combine the entered code
                              String code = controllers
                                  .map((controller) => controller.text)
                                  .join('');

                              _verifyCode(code);
                            }
                          }
                        },
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none, counterText: ''),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 10),
                Text(
                  erro,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // Combine the entered code manually if not auto-verified
                    String code = controllers
                        .map((controller) => controller.text)
                        .join('');

                    _verifyCode(code);
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
                          'Verify',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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

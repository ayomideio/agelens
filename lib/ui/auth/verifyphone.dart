import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readmitpredictor/ui/auth/verification_success.dart';
import 'package:readmitpredictor/ui/constants/index.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String verificationId;
  final String phone;
  const VerifyPhoneScreen(
      {super.key, required this.verificationId, required this.phone});

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());
  String erro = "";

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future _sendCodeToFirebase(String? code) async {
    if (widget.verificationId != null) {
      var credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: code!,
      );

      await _auth
          .signInWithCredential(credential)
          .then((value) {
            print("auth complete!");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerificationSuccess()),
            );
          })
          .whenComplete(() {})
          .onError((error, stackTrace) {
            setState(() {
              erro = "invalid code";
            });
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
                            widget.phone,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 40),
                      child: Text(
                        'Enter your phone number, we will send a \nauthentication code',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff9CA3AF),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
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
                            // Check if all fields are filled
                            bool allFilled = controllers.every(
                                (controller) => controller.text.isNotEmpty);
                            if (allFilled) {
                              // Hide the keyboard
                              FocusScope.of(context).unfocus();
                            }
                          }
                        },
                        maxLength: 1,
                        // maxLengthEnforced: false,

                        // showKeyboard: false,

                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none, counterText: ''),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: "Resend code in",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )),
                      TextSpan(
                        text: ' 00:48',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext build) =>
                                VerificationSuccess()));
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

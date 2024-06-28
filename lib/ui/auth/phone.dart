import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:readmitpredictor/ui/auth/verifyphone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readmitpredictor/ui/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TwoStepPhoneScreen extends StatefulWidget {
  const TwoStepPhoneScreen({super.key});

  @override
  State<TwoStepPhoneScreen> createState() => _TwoStepPhoneScreenState();
}

class _TwoStepPhoneScreenState extends State<TwoStepPhoneScreen> {
  String phne = '';
  bool isClicked = false;
  var _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _verifyPhoneNumber() async {
    setState(() {
      isClicked = true;
    });
    print("verifying phone");
    _auth.verifyPhoneNumber(
        phoneNumber:
            // "+234 7045802442",
            "+234" + " " + phne,
        verificationCompleted: (phonesAuthCredentials) async {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code.length > 0) {
            print(e.message);
            print(e.code);
          }
        },
        codeSent: (verificationId, reseningToken) async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString('phonenumber', "+234" + " " + phne);

          setState(() {
            _verificationId = verificationId;
            print(_verificationId);
            setState(() {
              isClicked = false;
            });

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext build) => VerifyPhoneScreen(
                        verificationId: _verificationId, phone: '0' + phne)));
            // here I am printing the opt code so I will know what it is to use it
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
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
                        'Set Up 2-Step Verification',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
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
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(25, 50, 0, 0),
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 05, 0, 0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: screenSize.width / 1.2, // Align items to the center
                    decoration: BoxDecoration(
                      color: Color(0xffe8f1ff),
                      border: Border.all(color: Color(0xffe8f1ff)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: IntlPhoneField(
                        autovalidateMode: AutovalidateMode.disabled,
                        flagsButtonPadding:
                            const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        dropdownIconPosition: IconPosition.trailing,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        initialCountryCode: 'NG',
                        onChanged: (phone) {
                          if (phone.number.length >= 10) {
                            FocusScope.of(context).unfocus();
                          }
                          print(phone.countryCode);
                          var compNumb = phone.completeNumber;
                          setState(() {
                            phne = phone.number.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isClicked?  CircularProgressIndicator(
                        color: ColorStyles.primaryColor,
                      )
                    :
                
                InkWell(
                  onTap: () async {
                    if (phne.length < 8) return;

                    await _verifyPhoneNumber();
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                    child: 
                    Container(
                      width: screenSize.width / 1.15,
                      height: 48,
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: ColorStyles.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
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

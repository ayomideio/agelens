import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:readmitpredictor/ui/user-taskbar/bookdetails.dart';

class Home extends StatefulWidget {
  final String fullname;
  final String phone;
  const Home({Key? key, required this.fullname, required this.phone})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  RemoteConfigUpdate? update;
   Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'hi': 'Hi,',
      'where_do': 'Where Do',
      'you_want_to_go': 'You Want To Go?',
      'search_destinations': 'Search Destinations',
      'recommended': 'Recommended',
      'view_all': 'View All',
    },
    'es': {
      'hi': 'Hola,',
      'where_do': 'Dónde',
      'you_want_to_go': 'Quieres Ir?',
      'search_destinations': 'Buscar Destinos',
      'recommended': 'Recomendado',
      'view_all': 'Ver Todo',
    },
  };

  String _selectedLanguage = 'en';

   void _switchLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  // Define a default email body text
  final String defaultEmailBody =
      "Hello, I am Victor, your personal guide from Shopify. "
      "I recently came across your store while reviewing the weekly report I received as a certified Shopify partner. "
      "I must say, I am truly impressed with the exceptional work you have accomplished thus far. "
      "Upon analyzing your store, I noticed that although you have taken proactive measures to generate sales, "
      "there seem to be several technical issues hindering the conversion of your daily traffic into customers. "
      "Glitches, broken links, and bugs are impacting the overall functionality of your store. "
      "I want to assist in resolving these issues and elevating your store to a higher level. "
      "By improving the user experience and setting the broken links, we can enhance your ability to convert daily traffic into repeat customers. "
      "Can I proceed???";
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    final startPosition = Offset(1.0, 0.0);
    final endPosition = Offset.zero;

    _animation = Tween<Offset>(
      begin: startPosition,
      end: endPosition,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    // Initialize the email body controller with default text
    _emailBodyController.text = defaultEmailBody;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailBodyController = TextEditingController();
  final TextEditingController _emailListsController = TextEditingController();
  final TextEditingController _emailNameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  bool _isLoading = false;
  int _successCount = 0;
  int _failureCount = 0;
  int _totalEmailsSent = 0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _successCount = 0;
        _failureCount = 0;
      });

      List<String> emailList = _emailListsController.text.split('\n');
      int batchSize = 10;
      int delayInMinutes = 5;

      for (int i = 0; i < emailList.length; i += batchSize) {
        List<String> batch = emailList
            .sublist(
                i,
                i + batchSize > emailList.length
                    ? emailList.length
                    : i + batchSize)
            .where((email) => email.trim().isNotEmpty)
            .toList();

        await _sendBatch(batch);

        if (i + batchSize < emailList.length) {
          await Future.delayed(Duration(minutes: delayInMinutes));
        }
      }

      setState(() {
        _isLoading = false;
      });

      _showResponseDialog();
    }
  }

  Future<void> _sendBatch(List<String> batch) async {
    for (String email in batch) {
      String endpoint = '';
      if (_totalEmailsSent >= 2000) {
        endpoint = 'http://18.225.156.117:5000/api/sendsupportIntromail';
      } else if (_totalEmailsSent >= 1000) {
        endpoint = 'http://18.225.156.117:5000/api/sendmaintenancemail';
      } else {
        endpoint = 'http://18.225.156.117:5000/api/sendsupportmail';
      }

      final response = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email_name': _emailNameController.text,
          'subject': _subjectController.text,
          'email_body': _emailBodyController.text,
          'email': email.trim(),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _successCount++;
        });
      } else {
        setState(() {
          _failureCount++;
        });
      }

      setState(() {
        _totalEmailsSent++;
      });
    }
  }

  void _showResponseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email Sending Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Emails sent successfully: $_successCount'),
              Text('Emails not successful: $_failureCount'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  // _emailBodyController.clear();
                  _emailListsController.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      {int maxLines = 1}) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
         appBar: AppBar(
          title: Text(''),
          actions: [
            
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _switchLanguage(newValue);
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'es',
                  child: Text('Español'),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          height: size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        _localizedStrings[_selectedLanguage]!['hi']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff737491),
                        ),
                      ),
                      Text(
                        widget.fullname,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffF3C204),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        _localizedStrings[_selectedLanguage]!['where_do']!,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff737491),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                       _localizedStrings[_selectedLanguage]!['you_want_to_go']!,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff737491),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 300,
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blueAccent,
                      ),
                      decoration: InputDecoration(
                        hintText:  _localizedStrings[_selectedLanguage]!['search_destinations']!,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.white, width: 50.0),
                        ),
                        suffixIcon: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.search),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     TextField(
                  //       decoration: InputDecoration(
                  //         prefixIcon: Icon(Icons.done),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                               _localizedStrings[_selectedLanguage]!['recommended']!,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Color(0xff737491),
                            fontStyle: FontStyle.normal),
                      ),
                      SizedBox(
                        width: size.width / 3.5,
                      ),
                      Text(
                       _localizedStrings[_selectedLanguage]!['view_all']!,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff737491)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
          SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('triplocale').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final locations = snapshot.data!.docs;

          return Row(
            children: locations.map((doc) {
              var data = doc.data() as Map<String, dynamic>;

              // Using null-aware operators to prevent the null exception
              String productName = data['productName'] ?? 'Unknown Location';
              String productDescription = data['productDescription'] ?? 'No Description';
              String productImage = data['productImage'][0] ?? '';
              List<String> productImages = List<String>.from(data['productImage'] ?? []);
              String price = data['price']?.toString() ?? '0';
              String vendorId = data['vendorId'] ?? '';
              String vendorName = data['vendorName'] ?? 'Unknown Vendor';
              String location = data['location'] ?? 'Unknown';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationDetails(
                        price: double.parse(price),
                        productDescription: productDescription,
                        productImage: productImages,
                        productName: productName,
                        vendorId: vendorId,
                        vendorName: vendorName,
                        location:location
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 220,
                  width: 300,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: productImage.isNotEmpty
                          ? NetworkImage(productImage)
                          : AssetImage('assets/vectors/default_image.jpg') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          color: Colors.black.withOpacity(.5),
                          width: 300,
                          height: 80,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow, size: 15),
                                    Icon(Icons.star, color: Colors.yellow, size: 15),
                                    Icon(Icons.star, color: Colors.yellow, size: 15),
                                    Icon(Icons.star, color: Colors.yellow, size: 15),
                                    Icon(Icons.star, color: Colors.yellow, size: 15),
                                    SizedBox(width: 5),
                                    Text(
                                      '5.0',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

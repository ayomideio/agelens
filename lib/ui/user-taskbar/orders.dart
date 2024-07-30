import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Orders extends StatefulWidget {
  final String fullname;
  final String phone;
  const Orders({Key? key, required this.fullname, required this.phone})
      : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  RemoteConfigUpdate? update;

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
      int delayInMinutes = 15;

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
      String endpoint = 'http://18.225.156.117:5000/api/sendmaintenancemail';

      final response = await http.post(
        Uri.parse(endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
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
        body: Container(
          color: Colors.white,
          height: size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(_totalEmailsSent.toString()),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // _buildTextFormField(_emailNameController, 'Email Name'),
                        // _buildTextFormField(_subjectController, 'Subject'),
                        _buildTextFormField(_emailBodyController, 'Email Body',
                            maxLines: 5),
                        _buildTextFormField(
                            _emailListsController, 'Email Lists',
                            maxLines: 8),
                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _submitForm,
                                child: Text('Send'),
                              ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

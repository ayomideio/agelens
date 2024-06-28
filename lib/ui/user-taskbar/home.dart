import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _allMedCountController = TextEditingController();
  final TextEditingController _timeInHospitalController =
      TextEditingController();
  final TextEditingController _totalNumProceduresController =
      TextEditingController();
  final TextEditingController _diabetesMedsCountController =
      TextEditingController();
  final TextEditingController _numComorbidityController =
      TextEditingController();
  final TextEditingController _numberVisitController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _changeValue;
  String? _diabetesMedValue;

  Map<String, dynamic>? _response;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

        final FirebaseRemoteConfig remoteConfig =
                                  FirebaseRemoteConfig.instance;
                              // Using zero duration to force fetching from remote server.
                              await remoteConfig.setConfigSettings(
                                RemoteConfigSettings(
                                  fetchTimeout: const Duration(seconds: 10),
                                  minimumFetchInterval: Duration.zero,
                                ),
                              );
                              await remoteConfig.fetchAndActivate();
                              print(
                                  'Fetched: ${remoteConfig.getString('api_url')}');
                              // var apiKey = remoteConfig.getString('numverify_key');

      final response = await http.post(
        Uri.parse(remoteConfig.getString('api_url')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'all_med_count': int.parse(_allMedCountController.text),
          'time_in_hospital': int.parse(_timeInHospitalController.text),
          'total_num_procedures': int.parse(_totalNumProceduresController.text),
          'diabetes_Meds_count': int.parse(_diabetesMedsCountController.text),
          'change': _changeValue == 'yes' ? 1 : 0,
          'num_comorbidity': int.parse(_numComorbidityController.text),
          'diabetesMed': _diabetesMedValue == 'yes' ? 1 : 0,
          'number_visit': int.parse(_numberVisitController.text),
          'age': int.parse(_ageController.text),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _response = jsonDecode(response.body);
          _isLoading = false;
        });
        _showResponseDialog();
      } else {
        setState(() {
          _isLoading = false;
        });
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    }
  }

void _showResponseDialog() {
    String message;
    Icon icon;
    if (_response != null) {
      if (_response!['random_forest'] == 1) {
        message = 'Readmission risk';
        icon = Icon(Icons.warning, color: Colors.red, size: 40);
      } else {
        message = 'No readmission risk';
        icon = Icon(Icons.check_circle, color: Colors.green, size: 40);
      }
    } else {
      message = 'No response';
      icon = Icon(Icons.error, color: Colors.grey, size: 40);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Readmission Risk'),
          content:
          
          Row(
            children: [
              icon,
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _response = null;
                  _allMedCountController.clear();
                  _timeInHospitalController.clear();
                  _totalNumProceduresController.clear();
                  _diabetesMedsCountController.clear();
                  _changeValue = null;
                  _numComorbidityController.clear();
                  _diabetesMedValue = null;
                  _numberVisitController.clear();
                  _ageController.clear();
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

  Widget _buildTextFormField(
      TextEditingController controller, String labelText) {
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
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String labelText, String? value, void Function(String?) onChanged) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        items: ['yes', 'no'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null) {
            return 'Please select $labelText';
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
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      "The green checkmark indicates there is no readmission risk, while the red icon indicates there is a readmission risk.",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildTextFormField(
                            _allMedCountController, 'All Medication Counts'),
                        _buildTextFormField(
                            _timeInHospitalController, 'Time in Hospital'),
                        _buildTextFormField(_totalNumProceduresController,
                            'Total number of procedures'),
                        _buildTextFormField(_diabetesMedsCountController,
                            'Diabetes Medication Counts'),
                        _buildDropdownField('Change of Diabetes Medication', _changeValue, (value) {
                          setState(() {
                            _changeValue = value;
                          });
                        }),
                        _buildTextFormField(
                            _numComorbidityController, 'Number of Comorbidity'),
                        _buildDropdownField('Diabetes Medication', _diabetesMedValue, (value) {
                          setState(() {
                            _diabetesMedValue = value;
                          });
                        }),
                        _buildTextFormField(
                            _numberVisitController, 'Number of Visit'),
                        _buildTextFormField(_ageController, 'Age'),
                        SizedBox(height: 20),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _submitForm,
                                child: Text('Submit'),
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

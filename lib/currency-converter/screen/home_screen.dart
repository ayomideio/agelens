import 'dart:convert';
import 'dart:io';
import 'package:readmitpredictor/currency-converter/constant.dart';
import 'package:readmitpredictor/currency-converter/model/currency_response_model.dart';
import 'package:readmitpredictor/currency-converter/screen/currency_screen.dart';
import 'package:readmitpredictor/currency-converter/widget/custom_textfield.dart';
import 'package:readmitpredictor/currency-converter/widget/rate_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../apikey.dart';
import '../model/currency_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final key = GlobalKey<FormState>();
  CurrencyModel currencies = CurrencyModel();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final amountController = TextEditingController();
  double rate = 0;
  double exchangeRate = 0;
  final client = Client();
  bool isLoading = false;
  bool isVisible = false;

Future<CurrencyResponseModel> getCurrencyConversionRate({
  required String convertFrom,
  required String convertTo,
  required num amount,
}) async {
  try {
    setState(() => isLoading = true);

    // Construct the URL with query parameters
    final Uri url = Uri.parse(
      'https://api.apilayer.com/exchangerates_data/convert?to=$convertTo&from=$convertFrom&amount=$amount',
    );

    // Set up the headers with the API key
    final Map<String, String> headers = {
      'apikey': 'PFk3uAEcKskv0WY4gTHZfsm4OYTlk1iI', // Replace with your actual API key
    };

    // Make the GET request
    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      setState(() => isLoading = false);

      // Parse the JSON response
      final Map<String, dynamic> json = jsonDecode(response.body);
      print(json);

      // Convert the JSON into the model
      final CurrencyResponseModel data = CurrencyResponseModel.fromJson(json);

      // Update state with the result
      setState(() {
        rate = data.result!;
        exchangeRate = data.info!.rate!;
        isVisible = true;
      });

      return data;
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar('Something went wrong'));
      print(response.reasonPhrase);
      throw Exception('Unable to get data');
    }
  } on SocketException catch (_) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar('No internet connection'));
    setState(() => isLoading = false);
    rethrow;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff292d36),
          title: const Text('CURRENCY CONVERTER'),
        ),
        backgroundColor: const Color(0xff292d36),
        body: SafeArea(
          minimum: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Convert from', style: style),
                    CustomTextfield(
                      textStyle: style.copyWith(color: Colors.black),
                      hintText: 'Convert from',
                      controller: fromController,
                      validator: (val) => val!.isEmpty ? 'enter value' : null,
                      readOnly: true,
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => const CurrencyScreen()));
                        setState(() => fromController.text = result);
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text('Convert to', style: style),
                    CustomTextfield(
                      textStyle: style.copyWith(color: Colors.black),
                      hintText: 'Convert to',
                      validator: (val) => val!.isEmpty ? 'enter value' : null,
                      controller: toController,
                      readOnly: true,
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => const CurrencyScreen()));
                        setState(() => toController.text = result);
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text('Amount', style: style),
                    CustomTextfield(
                      keyboardType: TextInputType.number,
                      textStyle: style.copyWith(color: Colors.black),
                      hintText: '25',
                      validator: (val) => val!.isEmpty ? 'enter value' : null,
                      controller: amountController,
                    ),
                    const SizedBox(height: 15),
                    const Divider(thickness: 2, color: Colors.grey),
                    AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        child: !isVisible
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  const Text('Rate', style: style),
                                  RateTextWidget(
                                      value: rate.toStringAsFixed(2)),
                                  const SizedBox(height: 15),
                                  const Text('Exchange rate', style: style),
                                  RateTextWidget(
                                      value: exchangeRate.toStringAsFixed(7)),
                                ],
                              )),
                    const SizedBox(height: 50),
                    MaterialButton(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          getCurrencyConversionRate(
                              amount: num.parse(amountController.text),
                              convertFrom: fromController.text,
                              convertTo: toController.text);
                        }
                      },
                      shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.red,
                      minWidth: double.infinity,
                      height: 60,
                      child: isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'CONVERT',
                              style: style.copyWith(fontSize: 23),
                            ),
                    )
                  ]),
            ),
          ),
        ));
  }
}

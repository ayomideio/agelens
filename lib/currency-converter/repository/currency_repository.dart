import 'dart:convert';
import 'package:http/http.dart';
import 'package:readmitpredictor/currency-converter/apikey.dart';
import 'package:readmitpredictor/currency-converter/model/currency_model.dart';

class CurrencyRepository {
  final client = Client();
  final baseUrl = 'https://api.apilayer.com/exchangerates_data/';

  // Set up headers
  final Map<String, String> headers = {
    'apikey': apikey, // apikey from your apikey.dart file
  };

  // Method to get currency symbols
  Future<Map<String, dynamic>> getCurrencySymbols() async {
    // Construct the URL
    final Uri url = Uri.parse(baseUrl + 'symbols');

    // Make the GET request
    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic> data = json['symbols'];
      print(data);
      return data;
    } else {
      throw Exception('Unable to get data');
    }
  }

  // Method to get currency conversion rate
  Future<CurrencyModel> getCurrencyConversionRate({
    required String convertFrom,
    required String convertTo,
    required num amount,
  }) async {
    // Construct the URL with query parameters
    final Uri url = Uri.parse(
      baseUrl + 'convert?from=$convertFrom&to=$convertTo&amount=$amount',
    );

    // Make the GET request
    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return CurrencyModel.fromJson(json);
    } else {
      print(response.reasonPhrase);
      throw Exception('Unable to get data');
    }
  }
}

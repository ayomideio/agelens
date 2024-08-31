import 'package:readmitpredictor/currency-converter/model/currency_model.dart';
import 'package:readmitpredictor/currency-converter/repository/currency_repository.dart';

class CurrencyProvider {
  static final repository = CurrencyRepository();

  static Future<CurrencyModel> getCurrencyConversionRate({
    required String convertFrom, // Changed to required
    required String convertTo,   // Changed to required
    required num amount,         // Changed to required
  }) async {
    // Ensure parameters are non-null before calling the method
    return await repository.getCurrencyConversionRate(
      convertFrom: convertFrom,
      convertTo: convertTo,
      amount: amount,
    );
  }

  static Future<Map<String, dynamic>> getCurrencySymbols() async {
    return await repository.getCurrencySymbols();
  }
}

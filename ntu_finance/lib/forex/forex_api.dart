import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForexApi {
  Future<Map<String, dynamic>> fetchForexDetails(
      String fromSymbol, String toSymbol) async {
    String apiKey = 'AJYN287HEEKWIOHN';

    String url =
        'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$fromSymbol&to_currency=$toSymbol&apikey=$apiKey';

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> exchangeRate =
            data['Realtime Currency Exchange Rate'] as Map<String, dynamic>;
        // debugPrint('Exchange Rate: ${exchangeRate['5. Exchange Rate']}');
        // debugPrint(data.toString());
        return exchangeRate;
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching Forex details: $e');
    }

    return {}; // Return an empty map in case of an error
  }

  Future<Map<String, double>> fetchAllExchangeRates(
      String baseCurrency, List<String> targetCurrencies) async {
    Map<String, double> exchangeRates = {};

    for (String currency in targetCurrencies) {
      Map<String, dynamic> forexDetails =
          await fetchForexDetails(baseCurrency, currency);

      double rate = double.parse(forexDetails['5. Exchange Rate'] as String);
      exchangeRates[currency] = rate;
    }

    return exchangeRates;
  }
}

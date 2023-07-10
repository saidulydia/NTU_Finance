import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForexApi {
  static Future<Map<String, dynamic>> fetchForexDetails() async {
    String apiKey = 'AJYN287HEEKWIOHN';
    String fromCurrency = 'EUR';
    String toCurrency = 'USD';

    String url =
        'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$fromCurrency&to_currency=$toCurrency&apikey=$apiKey';

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        Map<String, dynamic> exchangeRate =
            data['Realtime Currency Exchange Rate'] as Map<String, dynamic>;
        debugPrint('Exchange Rate: ${exchangeRate['5. Exchange Rate']}');
        debugPrint(data.toString());
        return exchangeRate;
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching Forex details: $e');
    }

    return {};
  }
}

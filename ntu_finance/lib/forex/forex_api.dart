import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForexApi {
  static Future<Map<String, dynamic>> fetchForexDetails() async {
    String apiKey = 'AJYN287HEEKWIOHN';
    String symbol = 'EURUSD';

    String url =
        'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$symbol&to_currency=USD&apikey=$apiKey';

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        debugPrint(response.body);
        return {};

        // Map<String, dynamic> data = json.decode(response.body);
        // Map<String, dynamic> exchangeRate =
        //     data['Realtime Currency Exchange Rate'] as Map<String, dynamic>;
        // debugPrint('Exchange Rate: ${exchangeRate['5. Exchange Rate']}');
        // debugPrint(data.toString());
        // return exchangeRate;
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching Forex details: $e');
    }

    return {}; // Return an empty map in case of an error
  }
}

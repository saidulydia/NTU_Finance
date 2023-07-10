import 'package:flutter/material.dart';
import 'package:ntu_finance/forex/forex_api.dart';

class ForexPage extends StatefulWidget {
  @override
  _ForexPageState createState() => _ForexPageState();
}

class _ForexPageState extends State<ForexPage> {
  Map<String, dynamic>? forexData;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchForexData();
  }

  Future<void> fetchForexData() async {
    try {
      Map<String, dynamic>? data = await ForexApi.fetchForexDetails();
      if (data != null) {
        setState(() {
          forexData = data;
          isLoading = false;
          error = '';
        });
      } else {
        setState(() {
          isLoading = false;
          error = 'Failed to fetch Forex details.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forex Data'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : error.isNotEmpty
                ? Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  )
                : forexData != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Exchange Rate: ${forexData!['5. Exchange Rate']}'),
                          Text(
                              'From Currency: ${forexData!['2. From_Currency Name']}'),
                          Text(
                              'To Currency: ${forexData!['4. To_Currency Name']}'),
                        ],
                      )
                    : SizedBox(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ntu_finance/forex/forex_api.dart';
import 'package:ntu_finance/widgets/currency_card.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';

  final List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD'];

  final TextEditingController fromCurrencyController = TextEditingController();
  final TextEditingController toCurrencyController = TextEditingController();

  Map<String, double> exchangeRates = {};

  Future<void> fetchExchangeRates() async {
    exchangeRates =
        await ForexApi().fetchAllExchangeRates(fromCurrency, currencies);
    setState(() {});
  }

  Future<void> performConversion(String fromCurrency, String toCurrency) async {
    Map<String, dynamic> exchangeRateMap =
        await ForexApi().fetchForexDetails(fromCurrency, toCurrency);
    String exchangeRate = exchangeRateMap["5. Exchange Rate"];

    double result =
        double.parse(fromCurrencyController.text) * double.parse(exchangeRate);

    setState(() {
      toCurrencyController.text = result.toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fromCurrencyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'From Currency',
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                DropdownButton<String>(
                  value: fromCurrency,
                  onChanged: (value) {
                    setState(() {
                      fromCurrency = value!;
                    });
                  },
                  items:
                      currencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: toCurrencyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'To Currency',
                    ),
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 20.0),
                DropdownButton<String>(
                  value: toCurrency,
                  onChanged: (value) {
                    setState(() {
                      toCurrency = value!;
                    });
                  },
                  items:
                      currencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                performConversion(fromCurrency, toCurrency);
              },
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                'Exchange Rates:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: exchangeRates.length,
                itemBuilder: (BuildContext context, int index) {
                  String currency = exchangeRates.keys.elementAt(index);
                  double rate = exchangeRates[currency]!;

                  return ListTile(
                    title: CurrencyCard(
                      currency: currency,
                      rate: rate,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
// import 'package:super_clipboard/super_clipboard.dart';

class DiscountOffer {
  final String companyName;
  final String shortDescription;
  final double discountPercentage;
  final String couponCode;

  DiscountOffer(this.companyName, this.shortDescription,
      this.discountPercentage, this.couponCode);
}

class DiscountPage extends StatefulWidget {
  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  final List<DiscountOffer> _offers = [
    DiscountOffer(
      "Tech Store",
      "Get the latest gadgets at a discount!",
      15.0,
      "TECHSALE15",
    ),
    DiscountOffer(
      "Fashion Outlet",
      "Upgrade your wardrobe with student discounts.",
      20.0,
      "FASHION20",
    ),
    DiscountOffer(
      "Food Delivery",
      "Enjoy your favorite meals with discounts.",
      10.0,
      "DELIVERY10",
    ),
    // Add more discount offers here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Discount Offers"),
      ),
      body: ListView.builder(
        itemCount: _offers.length,
        itemBuilder: (context, index) {
          return DiscountOfferCard(_offers[index]);
        },
      ),
    );
  }
}

class DiscountOfferCard extends StatelessWidget {
  final DiscountOffer offer;

  DiscountOfferCard(this.offer);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${offer.discountPercentage}% OFF",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              offer.companyName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(offer.shortDescription),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Coupon: ${offer.couponCode}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    FlutterClipboard.copy(offer.couponCode);
                  },
                  icon: const Icon(Icons.copy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

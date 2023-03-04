import 'package:chalkboard/screen/VolunteerProfile.dart';
import 'package:chalkboard/screen/home_screen.dart';
import 'package:chalkboard/screen/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDonationScreen extends StatefulWidget {
  const MyDonationScreen({Key? key}) : super(key: key);

  @override
  _MyDonationScreenState createState() => _MyDonationScreenState();
}

class _MyDonationScreenState extends State<MyDonationScreen> {

  

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Image.asset('assets/images/donation.png'),
          ),
          Container(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                child: Text('Donate Now'.tr),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentScreen()),
                  );
                },
              ),
            ),
          ),
          Text(
            'Previous Donations'.tr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 25),
          ),
          
        ],
      ),
    );
  }
}

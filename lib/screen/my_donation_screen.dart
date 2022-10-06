
import 'package:chalkboard/model/donation.dart';
import 'package:chalkboard/services/auth.dart';
import 'package:chalkboard/services/firestoreApi.dart';
import 'package:chalkboard/widget/donate_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/user.dart';
import 'add_edit_donation.dart';

class MyDonationScreen extends StatefulWidget {
  const MyDonationScreen({Key? key}) : super(key: key);

  @override
  _MyDonationScreenState createState() => _MyDonationScreenState();
}

class _MyDonationScreenState extends State<MyDonationScreen> {
  //razorpay instance
  var _razorpay = Razorpay();
  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  
  
  void openCheckout(){
    var options = {
      'key': 'rzp_test_TLizkUXChD8GM3',
      'amount': (int.parse(textEditingController.text)*100).toString(), //in the smallest currency sub-unit.
      'name': 'ChalkBoard',
      'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': 'Payment for Child Education',
      'timeout': 200, // in seconds
      'prefill': {
        'contact': '9123456789',
        'email': 'gaurav.kumar@example.com'
      },
      'external' : {
        'wallets' : ['paytm']
      }
    };
    
    _razorpay.open(options);
    // try{
      
    // } catch(e){
    //   print(e.toString());
    // }
  }
    
  
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Do something when payment succeeds
    print("Payment Success");
    Fluttertoast.showToast(
        msg: "Payment Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Error");
    Fluttertoast.showToast(
        msg: "some error occours!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print("External Wallet");
    Fluttertoast.showToast(
        msg: "External Wallet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: "Enter the amount",
              ),
            ),
            SizedBox(height: 30,),
            FloatingActionButton.extended(
              onPressed: () {
                // Respond to button press
                openCheckout();
              },
              icon: Icon(Icons.add),
              label: Text('DONATE MONEY'),
            ),
          ],
        ),
      ),
      ),
    );
  }

  @override 
    void dispose() {
      _razorpay.clear(); // Removes all listeners
      super.dispose();
    }

}


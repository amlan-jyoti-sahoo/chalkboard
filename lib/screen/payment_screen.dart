import 'package:chalkboard/widget/d_info.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNo = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController amount = TextEditingController();

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    initializeRazorPay();
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void launchRazorPay() {
    int amountToPay = int.parse(amount.text) * 100;

    var options = {
      'key': 'rzp_test_TLizkUXChD8GM3',
      'amount': "$amountToPay",
      'name': name.text,
      'description': description.text,
      'prefill': {'contact': phoneNo.text, 'email': email.text}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Sucessfull");
    Navigator.pop(context);
    DInfo.dialogSuccess(context,'Payment Success');
    DInfo.closeDialog(context,durationBeforeClose: const Duration(seconds: 1));
    print(
        "${response.orderId} \n${response.paymentId} \n${response.signature}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payemt Failed");
    Navigator.pop(context);
    DInfo.dialogError(context,'Payment Failed');
    DInfo.closeDialog(context,durationBeforeClose: const Duration(seconds: 1));
    print("${response.code}\n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Payment Failed");
    Navigator.pop(context);
    DInfo.dialogError(context,'Payment Failed');
    DInfo.closeDialog(context,durationBeforeClose: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              textField(size, "Name", false, name),
              textField(size, "Phone no.", false, phoneNo),
              textField(size, "Email", false, email),
              textField(size, "Description", false, description),
              textField(size, "amount", true, amount),
              ElevatedButton(
                onPressed: launchRazorPay,
                child: Text("Pay Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(Size size, String text, bool isNumerical,
      TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height / 50),
      child: Container(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextField(
          controller: controller,
          keyboardType: isNumerical ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: text,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}

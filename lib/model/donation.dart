import 'package:flutter/cupertino.dart';
//import 'package:intl/intl.dart';

class Donation with ChangeNotifier {
  String? donationId;
  String donorId;
  String paymentId;
  String amount;
  String donorName;
  String donorEmail;
  String description;
  String donorContact;
  String status;

  Donation({
    this.donationId,
    required this.donorId,
    required this.paymentId,
    required this.donorName,
    required this.donorContact,
    required this.status,
    required this.description,
    required this.amount,
    required this.donorEmail,
  });
  static Donation fromJson(json, documentId) {
    return Donation(
      donationId: documentId,
      donorId: json['donor id'],
      paymentId: json['payment id'],
      amount: json['donation Amount'],
      description: json['description'],
      donorEmail: json['donor Email'],
      donorName: json['donor name'],
      donorContact: json['donor contact'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['donor id'] = this.donorId;
    data['payment id'] = this.paymentId;
    data['donation Amount'] = this.amount;
    data['description'] = this.description;
    data['donor Email'] = this.donorEmail;
    data['donor name'] = this.donorName;
    data['donor contact'] = this.donorContact;
    data['status'] = this.status;
    return data;
  }

}

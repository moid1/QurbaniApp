import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetail {
  final String name;
  final String address;
  final String phoneNo;

  UserDetail(
      {@required this.name, @required this.address, @required this.phoneNo});

  UserDetail.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        address = snapshot['address'],
        phoneNo = snapshot['phoneNo'];

  Map<String, dynamic> toJson() =>
      {"name": name, "address": address, "phoneNo": phoneNo};
}

import 'package:flutter/material.dart';

class UserDetail {
  final String name;
  final String address;
  final String phoneNo;

  UserDetail(
      {@required this.name, @required this.address, @required this.phoneNo});
  Map<String, dynamic> toJson() =>
      {"name": name, "address": address, "phoneNo": phoneNo};
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductModel {
  final String userId;
  final String categoryId;
  final Timestamp createdAt;
  final String image;
  final String color;
  final int price;
  final String address;

  ProductModel({
    @required this.userId,
    @required this.categoryId,
    @required this.createdAt,
    @required this.image,
    @required this.price,
    @required this.address,
    @required this.color,
  });

  ProductModel.fromSnapshot(DocumentSnapshot snapshot)
      : userId = snapshot['user_id'],
        categoryId = snapshot['category_id'],
        image = snapshot['image'],
        createdAt = snapshot['created_at'],
        price = snapshot['price'] ?? 0,
        address = snapshot['address'],
        color = snapshot['color'];

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "category_id": categoryId,
        "image": image,
        "created_at": createdAt,
        "price": price,
        "address": address,
        "color": color
      };
}

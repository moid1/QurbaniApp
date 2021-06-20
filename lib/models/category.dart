import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final Timestamp createdAt;
  final String image;

  CategoryModel({
    @required this.id,
    @required this.name,
    @required this.createdAt,
    @required this.image,
  });

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        id = snapshot['id'],
        image = snapshot['image'],
        createdAt = snapshot['created_at'];

  Map<String, dynamic> toJson() =>
      {"name": name, "image": image, "created_at": createdAt};
}

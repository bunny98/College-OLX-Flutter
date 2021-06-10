import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class Product {
  final String id;
  final String name;
  final String sellerId;
  final String collegeId;
  final String status;
  final int price;
  final List<String> contentURLs;
  
  Product({
    @required this.id,
    @required this.name,
    @required this.sellerId,
    @required this.collegeId,
    @required this.status,
    @required this.price,
    @required this.contentURLs,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sellerId': sellerId,
      'collegeId': collegeId,
      'status': status,
      'price': price,
      'contentURLs': contentURLs,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      sellerId: map['sellerId'],
      collegeId: map['collegeId'],
      status: map['status'],
      price: map['price']?.toInt(),
      contentURLs: List<String>.from(map['contentURLs']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, name: $name, sellerId: $sellerId, collegeId: $collegeId, status: $status, price: $price, contentURLs: $contentURLs)';
  }
}
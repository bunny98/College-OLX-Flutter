import 'dart:convert';

import 'package:ent_new/models/product.dart';
import 'package:ent_new/models/user.dart';
import 'package:flutter/foundation.dart';

class Request {
  final String id;
  final Product product;
  final User recipientUser;
  final String status;
  Request({
    @required this.id,
    @required this.product,
    @required this.recipientUser,
    @required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'recipientUser': recipientUser.toMap(),
      'status': status,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map['id'],
      product: Product.fromMap(map['product']),
      recipientUser: User.fromMap(map['recipientUser']),
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) =>
      Request.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Request(id: $id, product: $product, recipientUser: $recipientUser, status: $status)';
  }
}

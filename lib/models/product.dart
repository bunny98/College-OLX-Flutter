import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String prodName;
  final double price;
  final String imageUrl;
  final String sellerUserId;
  bool doneTransaction;

  Product(
      {@required this.id,
      @required this.prodName,
      @required this.price,
      @required this.imageUrl,
      @required this.sellerUserId,
      this.doneTransaction = false});
}

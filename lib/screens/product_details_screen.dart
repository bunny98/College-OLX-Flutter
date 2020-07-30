import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_details_item.dart';

class ProductDetailsScreen extends StatelessWidget {
  final prodId;
  ProductDetailsScreen(this.prodId);
  @override
  Widget build(BuildContext context) {
    print('*********PRODUCT DETAILS SCREEN BUILT***********');
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(prodId);
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ProductDetailsItem(prod: product),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }
}

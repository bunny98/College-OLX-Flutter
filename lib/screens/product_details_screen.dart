import 'package:ent_new/constants.dart';
import 'package:ent_new/view_models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_details_item.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String prodId;
  ProductDetailsScreen(this.prodId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HOME_BG_COLOR,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Consumer<ProductViewModel>(
            builder: (context, model, _) =>
                ProductDetailsItem(prod: model.getProductWithId(prodId))),
        SizedBox(
          height: 10,
        ),
      ]),
    );
  }
}

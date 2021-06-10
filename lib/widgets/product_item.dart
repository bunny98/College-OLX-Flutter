import 'package:ent_new/models/product.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/product_details_screen.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;

  ProductItemWidget({this.product});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ProductDetailsScreen(product.id)));
      },
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: CARD_ELEVATION,
              child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            product.contentURLs[0],
                          ))),
                  child: Image.network(
                    product.contentURLs[0],
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Rs. " + product.price.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

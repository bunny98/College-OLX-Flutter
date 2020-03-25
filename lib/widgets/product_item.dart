import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';

class ProductItemWidget extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String prodName;

  ProductItemWidget({this.id, this.imageUrl, this.prodName});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => ProductDetailsScreen(id)));
          },
          child: GridTile(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    prodName,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

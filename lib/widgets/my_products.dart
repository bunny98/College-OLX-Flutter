import 'dart:ui';

import 'package:ent_new/view_models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/product.dart';
import '../screens/edit_my_product_screen.dart';

class MyProducts extends StatefulWidget {
  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  List<Product> _myProducts;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(builder: (context, model, _) {
      _myProducts = model.getMyProducts();
      return _myProducts.length == 0
          ? Center(
              child: Text('You haven\'t Added Any Products'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _myProducts.length,
              itemBuilder: (context, i) {
                return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditMyProductScreen(prod: _myProducts[i])));
                      },
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: CARD_ELEVATION,
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(.3),
                                          Colors.black.withOpacity(.8)
                                        ])),
                              ),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          _myProducts[i].contentURLs[0])),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _myProducts[i].name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "Rs " + _myProducts[i].price.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ));
              },
            );
    });
  }
}

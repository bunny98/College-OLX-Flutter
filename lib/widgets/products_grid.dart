import 'package:ent_new/providers/auth.dart';
import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductsGrid extends StatefulWidget {
  ProductsGrid({Key key}) : super(key: key);
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  var _userId;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    _userId = Provider.of<Auth>(context).userId;
    await Provider.of<Products>(context).fetchObjects(_userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loadedProducts = Provider.of<Products>(context).items;
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5 / 2,
            crossAxisSpacing: 5,
          ),
          itemCount: loadedProducts.length,
          itemBuilder: (ctx, i) => ProductItemWidget(
            id: loadedProducts[i].id,
            prodName: loadedProducts[i].prodName,
            imageUrl: loadedProducts[i].imageUrl,
          ),
        ));
  }
}

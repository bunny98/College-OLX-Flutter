import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/products.dart';
import '../models/product.dart';
import '../screens/edit_my_product_screen.dart';

class MyProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('*********MY PRODUCTS WIDGET BUILT***********');
    List<Product> loadedProducts =
        Provider.of<Products>(context).getMyItems;
    return loadedProducts.length == 0
        ? Center(
            child: Text('You haven\'t Added Any Products'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              childAspectRatio: 4.0,
            ),
            itemCount: loadedProducts.length,
            itemBuilder: (ctx, i) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              EditMyProductScreen(prod: loadedProducts[i])));
                    },
                    child: GridTile(
                      child: Image.network(
                        loadedProducts[i].imageUrl,
                        fit: BoxFit.cover,
                      ),
                      footer: GridTileBar(
                        backgroundColor: Colors.white60,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              loadedProducts[i].prodName,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          );
  }
}

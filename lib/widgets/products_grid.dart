import 'package:ent_new/constants.dart';
import 'package:ent_new/models/college.dart';
import 'package:ent_new/models/product.dart';
import 'package:ent_new/models/user.dart';
import 'package:ent_new/view_models/product_model.dart';
import 'package:ent_new/view_models/user_model.dart';
import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatefulWidget {
  ProductsGrid({Key key}) : super(key: key);
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  ProductViewModel _productViewModel;
  User _currUser;
  College _currCollege;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _productViewModel = ProductViewModel.getInstance();
    _currUser = UserViewModel.getInstance().getCurrUser();
    _currCollege = UserViewModel.getInstance().getCurrCollege();
  }

  Future<void> _refresh() async {
    await _productViewModel.fetchLobbyProducts(
        userId: _currUser.id, collegeId: _currUser.collegeId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(builder: (context, model, _) {
      List<Product> loadedProducts = model.getLobbyProducts();
      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          // SliverAppBar(
          //   title: Text(
          //     'Welcome to College Rentals!',
          //     style:
          //         TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          //   ),
          //   centerTitle: true,
          //   floating: true,
          //   pinned: false,
          //   backgroundColor: Colors.transparent,
          //   shadowColor: Colors.transparent,
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("images/product-grid.jpg"))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello, ${_currUser.name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Find products on sale/rent in \n${_currCollege.name}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
          ),
        ],
        body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                ),
                itemCount: loadedProducts.length,
                itemBuilder: (ctx, i) {
                  if (loadedProducts.length > 0)
                    return Hero(
                      tag: 'SelectedObj',
                      child: ProductItemWidget(
                        product: loadedProducts[i],
                      ),
                    );
                  else
                    return Center(
                      child: Text('No Products'),
                    );
                })),
      );
    });
  }
}

import 'package:ent_new/constants.dart';
import 'package:ent_new/models/user.dart';
import 'package:ent_new/view_models/order_model.dart';
import 'package:ent_new/view_models/product_model.dart';
import 'package:ent_new/view_models/user_model.dart';
import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../widgets/my_products.dart';
import '../widgets/notifications.dart';
import '../widgets/add_item.dart';
import 'package:provider/provider.dart';
import '../screens/auth_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class OverViewScreen extends StatefulWidget {
  static const routeName = '/overview-screen';
  const OverViewScreen({Key key}) : super(key: key);
  @override
  OverviewScreenState createState() => OverviewScreenState();
}

class OverviewScreenState extends State<OverViewScreen> {
  int _selectedIndex = 0;
  UserViewModel _userViewModel;
  ProductViewModel _productViewModel;
  OrderViewModel _orderViewModel;
  User _currUser;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          ProductsGrid(),
          MyProducts(),
          Notifications(),
          AddItem(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _userViewModel = UserViewModel.getInstance();
    _currUser = _userViewModel.getCurrUser();
    _productViewModel = ProductViewModel.getInstance();
    _orderViewModel = OrderViewModel.getInstance();
    _fetchLobbyProducts();
    _fetchMyProducts();
    _initNotificationListener();
  }

  void _initNotificationListener() {
    _orderViewModel.initNotificationListener(userId: _currUser.id);
  }

  Future _fetchLobbyProducts() async {
    await _productViewModel.fetchLobbyProducts(
        collegeId: _currUser.collegeId, userId: _currUser.id);
  }

  Future _fetchMyProducts() async {
    await _productViewModel.fetchMyProducts(sellerId: _currUser.id);
  }

  Color getBgColor() {
    switch (_selectedIndex) {
      case 0:
        return HOME_BG_COLOR;
      case 1:
        return MY_PRODUCTS_BG_COLOR;
      case 2:
        return NOTIFICATIONS_BG_COLOR;
      case 3:
        return ADD_PRODUCT_BG_COLOR;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    print('*********OVERVIEW SCREEN BUILT***********');
    return WillPopScope(
        onWillPop: () {
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
            return new Future(() => false);
          }
          return new Future(() => true);
        },
        child: Scaffold(
          backgroundColor: getBgColor(),
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(38),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      await _userViewModel.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => AuthScreen()),
                          (route) => false);
                    },
                    tooltip: 'Logout',
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              )),
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator(0),
              _buildOffstageNavigator(1),
              _buildOffstageNavigator(2),
              _buildOffstageNavigator(3),
            ],
          ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.home, color: Colors.black),
                title: Text(
                  "Home",
                  style: TextStyle(color: Colors.black),
                ),
                selectedColor: HOME_BOTTOM_BAR_COLOR,
              ),

              /// My Products
              SalomonBottomBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                title:
                    Text("My Products", style: TextStyle(color: Colors.black)),
                selectedColor: MY_PRODUCTS_BOTTOM_BAR_COLOR,
              ),

              /// Notifications
              SalomonBottomBarItem(
                icon: Icon(Icons.notifications, color: Colors.black),
                title: Text("Notifications",
                    style: TextStyle(color: Colors.black)),
                selectedColor: NOTIFICATIONS_BOTTOM_BAR_COLOR,
              ),

              /// Add Products
              SalomonBottomBarItem(
                icon: Icon(Icons.add, color: Colors.black),
                title:
                    Text("Add Product", style: TextStyle(color: Colors.black)),
                selectedColor: ADD_PRODUCT_BOTTOM_BAR_COLOR,
              ),
            ],
          ),
        ));
  }
}

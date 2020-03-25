import 'package:ent_new/providers/received_request.dart';
import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import '../widgets/my_products.dart';
import '../widgets/notifications.dart';
import '../widgets/add_item.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../screens/auth_screen.dart';
import './splash_screen.dart';
import '../providers/products.dart';

class OverViewScreen extends StatefulWidget {
  static const routeName = '/overview-screen';
  const OverViewScreen({Key key}) : super(key: key);
  @override
  OverviewScreenState createState() => OverviewScreenState();
}

class OverviewScreenState extends State<OverViewScreen> {
  int _selectedIndex = 0;
  bool _isInit = true;
  var _logoutError;
  var _userDetails;
  static final List<Widget> _widgetOptions = [
    ProductsGrid(),
    MyProducts(),
    Notifications(),
    AddItem(),
  ];

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
    print("INDEX INSIDE OFF STAGE" +
        index.toString() +
        "SELECTED INDEX" +
        _selectedIndex.toString());
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
  void initState(){
    _isInit = true;
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      var _userId = Provider.of<Auth>(context).userId;
      _userDetails = Provider.of<Auth>(context).userDetails;
      await Provider.of<Products>(context).fetchObjects(_userId);
      await Provider.of<Products>(context).getRequests();
      await Provider.of<Products>(context).setSentRequest(_userId);
      _isInit = false;
    }
  }

  // Future<void> _initialize() async {
  //   var _userId = Provider.of<Auth>(context).userId;
  //   _userDetails = Provider.of<Auth>(context).userDetails;
  //   await Provider.of<Products>(context).fetchObjects(_userId);
  //   await Provider.of<Products>(context).getRequests();
  //   await Provider.of<Products>(context).setSentRequest(_userId);
  // }

  Future<bool> _onWillPop() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInit
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () {
              print("SELECTED INDEX" + _selectedIndex.toString());
              if (_selectedIndex != 0) {
                setState(() {
                  _selectedIndex = 0;
                });
                return new Future(() => false);
              }
              return new Future(() => true);
            },
            child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(38),
                  child: AppBar(
                    title: _userDetails['userName'] != null
                        ? Text(
                            'Hi ' + _userDetails['userName'] + '!',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )
                        : Text('College Olx'),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                        ),
                        onPressed: () async {
                          await Provider.of<Auth>(context).signOut();
                          _logoutError =
                              Provider.of<Auth>(context).getErrorMessage;
                          if (_logoutError == null) {
                            // _isInit = true;
                            Provider.of<Products>(context).clearReceivedReq();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AuthScreen.routeName, (_) => false);
                          }
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
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), title: Text('Home')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.mood), title: Text('My Products')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notifications_none),
                      title: Text('Notifications')),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_circle_outline),
                      title: Text('Add Product')),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: (idx) {
                  setState(() {
                    _selectedIndex = idx;
                  });
                },
              ),
            ));
  }
}

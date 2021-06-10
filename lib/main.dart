import 'package:ent_new/view_models/order_model.dart';
import 'package:ent_new/view_models/product_model.dart';
import 'package:ent_new/view_models/user_model.dart';
import 'package:flutter/material.dart';
import './screens/overview_screen.dart';
import 'package:provider/provider.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './screens/takePictureScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserViewModel.getInstance()),
          ChangeNotifierProvider.value(value: ProductViewModel.getInstance()),
          ChangeNotifierProvider.value(value: OrderViewModel.getInstance()),
        ],
        child: MaterialApp(
          title: 'College OLX',
          theme: ThemeData(
            primaryColor: Colors.indigo,
            accentColor: Colors.black,
          ),
          home: SplashScreen(),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            TakePictureScreen.routeName: (context) => TakePictureScreen(),
            SplashScreen.routeName: (context) => SplashScreen(),
            OverViewScreen.routeName: (context) => OverViewScreen(),
          },
        ));
  }
}

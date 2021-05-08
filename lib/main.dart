import 'package:flutter/material.dart';
import './screens/overview_screen.dart';
import './screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/splash_screen.dart';
import './screens/takePictureScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Products()),
          ChangeNotifierProvider.value(value: Auth())
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    primaryColor: Colors.indigo,
                    accentColor: Colors.black,
                  ),
                  home: SplashScreen(),
                  routes: {
                    AuthScreen.routeName: (context)=>AuthScreen(),
                    TakePictureScreen.routeName: (context)=>TakePictureScreen(),
                    SplashScreen.routeName: (context)=>SplashScreen(),
                    OverViewScreen.routeName: (context) => OverViewScreen(),
                  },
                )));
  }
}

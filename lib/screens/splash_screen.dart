import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './overview_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';
  SplashScreen({Key key}) : super(key: key);
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  void initState() {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user == null) {
        AuthData auth = new AuthData(
            userId: null,
            errorMessage: null,
            userAddress: null,
            userMobile: null,
            userName: null);
        Provider.of<Auth>(context).onNewAuth(auth);
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      } else {
        Firestore.instance
            .collection("users")
            .document(user.uid)
            .get()
            .then((DocumentSnapshot result) {
          AuthData auth = new AuthData(
              userId: user.uid,
              errorMessage: null,
              userAddress: result['address'],
              userMobile: result['mobNum'],
              userName: result['name']);
          Provider.of<Auth>(context).onNewAuth(auth);
          Navigator.of(context).pushReplacementNamed(OverViewScreen.routeName);
        });
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}

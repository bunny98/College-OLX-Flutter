import 'package:ent_new/view_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../screens/auth_screen.dart';
import './overview_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';
  SplashScreen({Key key}) : super(key: key);
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Future _initLogic;
  void initState() {
    super.initState();
    _initLogic = UserViewModel.getInstance().onStartUp();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initLogic,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done)
              return Center(
                child: CircularProgressIndicator(),
              );
            bool _signInNotReq = snap.data;
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          _signInNotReq ? OverViewScreen() : AuthScreen()),
                  (_) => false);
            });

            return Container();
          }),
    );
  }
}

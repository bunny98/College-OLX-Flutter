import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthData {
  String userId;
  String errorMessage;
  String userName;
  String userAddress;
  String userMobile;

  AuthData(
      {this.userId,
      this.errorMessage,
      this.userAddress,
      this.userMobile,
      this.userName});
}

class Auth with ChangeNotifier {
  // String _token;
  AuthData auth;

  onNewAuth(AuthData auth) {
    this.auth = auth;
    notifyListeners();
  }

  String get userId {
    return auth.userId;
  }

  String get getErrorMessage {
    return auth.errorMessage;
  }

  String get userName {
    return auth.userName;
  }

  Map<String, String> get userDetails {
    return {
      'userName': auth.userName,
      'userAddress': auth.userAddress,
      'userMobile': auth.userMobile,
    };
  }

  // String getUserName(String uid)async{
  //   var ret = await Firestore.instance.collection("users").document(uid).get();
  //   return ret.data['name'].toString();
  // }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut().catchError((e) {
        auth.errorMessage = e.code;
      });
      auth.userId = null;
      auth.errorMessage = null;
      auth.userAddress = null;
      auth.userName = null;
      auth.userMobile = null;
    } catch (e) {}
    notifyListeners();
  }

  Future signIn({String email, String password}) async {
    try {
      // auth = new AuthData();
      FirebaseUser currUser = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password)
              .catchError((e) {
        print("SIGNIN ERROR: " + e.code);
        auth.errorMessage = e.code;
      }))
          .user;
      auth.userId = currUser.uid;
      auth.errorMessage = null;
      await Firestore.instance
          .collection("users")
          .document(currUser.uid)
          .get()
          .then((DocumentSnapshot result) {
            auth.userName = result['name'];
            auth.userAddress = result['address'];
            auth.userMobile = result['mobNum'];
      });
    } catch (e) {}
    notifyListeners();
  }

  Future signUp(
      {String email,
      String password,
      String name,
      String address,
      String mobNum}) async {
    try {
      // auth = new AuthData();
      FirebaseUser currentUser = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password)
              .catchError((e) {
        print("Singup ERROR" + e.code);
        auth.errorMessage = e.code;
      }))
          .user;
      auth.userId = currentUser.uid;
      auth.errorMessage = null;
      await Firestore.instance
          .collection("users")
          .document(currentUser.uid)
          .setData({
        'userId': currentUser.uid,
        'name': name,
        'address': address,
        'mobNum': mobNum,
      }).catchError((e) {
        print("WRITING USER INFO ERROR" + e.code);
      });
      auth.userAddress = address;
      auth.userMobile = mobNum;
      auth.userName = name;
    } catch (e) {}
    notifyListeners();
  }
}

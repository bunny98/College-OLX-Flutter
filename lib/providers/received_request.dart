import 'package:flutter/material.dart';

class ReceivedRequest with ChangeNotifier {
  Map<String, bool> _receivedReq = {};
  void initialize(String prodId) {
    _receivedReq.addAll({prodId: false});
    print('INITIALIZED: '+prodId+" "+_receivedReq.length.toString());
  }

  void setHasRequestTrue(String prodId) {
    _receivedReq['prodId'] = true;
    notifyListeners();
  }

  void setHasRequestFalse(String prodId) {
    _receivedReq['prodId'] = false;
    notifyListeners();
  }
}

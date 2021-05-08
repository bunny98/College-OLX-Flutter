import 'dart:async';

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/requests.dart';

class Products with ChangeNotifier {
  bool _shouldListenRReq = true;
  List<Product> _items = [];
  List<Product> _myItems = [];
  List<Requests> _sentRequest = [];
  List<Requests> _receivedRequests = [];
  StreamSubscription<QuerySnapshot> receivedReqStream;

  List<Requests> get receivedRequests {
    return _receivedRequests;
  }

  List<Requests> get sentRequest {
    return _sentRequest;
  }

  List<Product> get getMyItems {
    return _myItems;
  }

  List<Product> get allItems {
    return [..._items];
  }

  List<Product> get items {
    return _items.where((prod) => !prod.doneTransaction).toList();
  }

  List<String> get myProdIds {
    List<String> ret = [];
    _myItems.forEach((item) {
      ret.add(item.id);
    });
    return ret;
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id, orElse: () => null);
  }

  void shouldListenRReq() {
    _shouldListenRReq = !_shouldListenRReq;
  }

  void cancelReceivedReqStream() {
    receivedReqStream.cancel();
  }

  Future<void> onAcceptRemoveSameReq(String pid) {
    _receivedRequests.removeWhere((req) => req.prodId == pid);
    notifyListeners();
    return Future.value(true);
  }

  void removeRequestLocally(Requests req) {
    _receivedRequests.remove(req);
    print("Length after removal: " + _receivedRequests.length.toString());
    notifyListeners();
  }

  void clearReceivedReq() {
    _myItems = [];
    _receivedRequests = [];
    notifyListeners();
  }

  void deleteItemLocally(Product prod) {
    _items.removeAt(
        _items.indexOf(_items.firstWhere((item) => item.id == prod.id)));
    _myItems.removeAt(
        _myItems.indexOf(_myItems.firstWhere((item) => item.id == prod.id)));
    notifyListeners();
  }

  void addItemLocally(Product newProd) {
    _items.add(newProd);
    _myItems.add(newProd);
    cancelReceivedReqStream();
    getRequests();
    notifyListeners();
  }

  void updateLocally(Product newProd) {
    int start =
        _items.indexOf(_items.firstWhere((prod) => prod.id == newProd.id));
    _items.replaceRange(start, start + 1, [newProd]);
    start =
        _myItems.indexOf(_myItems.firstWhere((prod) => prod.id == newProd.id));
    _myItems.replaceRange(start, start + 1, [newProd]);
    notifyListeners();
  }

  Future<void> getRequests() async {
    if (_myItems.isNotEmpty)
      _myItems.forEach((item) {
        var snapshots = Firestore.instance
            .collection("requests")
            .document(item.id)
            .collection(item.id)
            .orderBy('timeStamp', descending: true)
            .snapshots();
        receivedReqStream = snapshots.listen((data) {
          if (data.documents.length > 0 && _shouldListenRReq) {
            data.documents.forEach((doc) async {
              if (doc['response'] == 'Pending') {
                int flg = 0;
                _receivedRequests.forEach((req) {
                  if (req.prodId == item.id && req.userId == doc['userId'])
                    flg = 1;
                });
                if (flg == 0) {
                  _receivedRequests.add(Requests(
                      prodId: item.id,
                      userId: doc['userId'],
                      response: doc['response'],
                      timeStamp: doc['timeStamp'],
                      userName: doc['userName']));
                  print('ADDED REQUEST!');
                  notifyListeners();
                }
              }
            });
          }
        });
      });
  }

  Future<void> sentRequestStreams(String uid) {
    _sentRequest.forEach((req) {
      try {
        var snaps = Firestore.instance
            .collection("requests")
            .document(req.prodId)
            .collection(req.prodId)
            .where('userId', isEqualTo: uid)
            .snapshots();
        snaps.listen((data) {
          if (data.documents.length > 0) {
            data.documents.forEach((doc) {
              if (req.response != doc['response']) {
                req.response = doc['response'];
                notifyListeners();
              }
            });
          }
        });
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> setSentRequest(String uid) async {
    List<Requests> newVals = [];
    var docs = await Firestore.instance
        .collection("requestsSent")
        .document(uid)
        .collection(uid)
        .orderBy('timeStamp', descending: true)
        .getDocuments();
    if (docs.documents.length > 0) {
      docs.documents.forEach((doc) {
        newVals.add(Requests(
            prodId: doc['prodId'],
            timeStamp: doc['timeStamp'],
            response: 'Not Received'));
      });
    }
    newVals.sort((req1, req2) {
      if (DateTime.fromMillisecondsSinceEpoch(int.parse(req1.timeStamp))
          .isAfter(
              DateTime.fromMillisecondsSinceEpoch(int.parse(req2.timeStamp))))
        return 1;
      else
        return 0;
    });
    _sentRequest = newVals;
    sentRequestStreams(uid);
    notifyListeners();
  }

  Future<void> saveRequest({String pid, String uid}) async {
    var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    await Firestore.instance
        .collection("requestsSent")
        .document(uid)
        .collection(uid)
        .add({
      'prodId': pid,
      'timeStamp': timeStamp,
    }).then((_) {
      _sentRequest.insert(
          0, Requests(prodId: pid, timeStamp: timeStamp, response: 'Pending'));
      sentRequestStreams(uid);
      notifyListeners();
    });
  }

  Future<void> fetchObjects(String uid) async {
    List<Product> loadedItems = [];
    await Firestore.instance
        .collection("products")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((doc) {
        print(doc.data['price']);
        loadedItems.add(Product(
            id: doc.documentID,
            imageUrl: doc.data['imageUrl'],
            price: double.parse(doc.data['price']),
            prodName: doc.data['prodName'],
            sellerUserId: doc.data['sellerId']));
      });
      _items = loadedItems;
      print('Items Received');
      List<Product> ret = [];
      _items.forEach((item) {
        if (item.sellerUserId == uid) ret.add(item);
      });
      _myItems = ret;
      print('My items set');
      notifyListeners();
    });
  }
}

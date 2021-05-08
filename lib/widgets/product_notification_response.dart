import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_olx_flutter/models/requests.dart';
import 'package:college_olx_flutter/providers/products.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class ProductNotificationResponse extends StatefulWidget {
  final Requests request;
  final Product product;
  ProductNotificationResponse({Key key, this.request, this.product})
      : super(key: key);
  _ProductNotificationResponseState createState() =>
      _ProductNotificationResponseState();
}

class _ProductNotificationResponseState
    extends State<ProductNotificationResponse> {
  bool _isInit = true;
  var _docId;
  var _sellerId;
  bool _isResponding = false;
  TextStyle _textStyle = new TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.indigo,
  );
  var snackBarAccept = SnackBar(content: Text('Declining all other requests for same product'),);

  Future _onAccept() async {
    setState(() {
      _isResponding = true;
    });
    Scaffold.of(context).showSnackBar(snackBarAccept);
    print(widget.product.id + " " + widget.request.timeStamp);
    Provider.of<Products>(context).shouldListenRReq();
    await Firestore.instance.collection("accepted").add({
      'prodId': widget.product.id,
      'renterId': widget.request.userId,
      'sellerId': _sellerId,
      'payment':'unpaid',
    });
    var docs = await Firestore.instance
        .collection("requests")
        .document(widget.product.id)
        .collection(widget.product.id)
        .getDocuments();
    for (int i = 0; i < docs.documents.length; i++) {
      var doc = docs.documents[i];
      if (doc.data['userId'] == widget.request.userId) {
        await Firestore.instance
            .collection("requests")
            .document(widget.product.id)
            .collection(widget.product.id)
            .document(doc.documentID)
            .updateData({
          'response': 'Accepted',
        }).then((_) {
          print("Accepted one!");
        });
      } else {
        await Firestore.instance
            .collection("requests")
            .document(widget.product.id)
            .collection(widget.product.id)
            .document(doc.documentID)
            .updateData({
          'response': 'Declined',
        }).then((_) {
          print('Declined one');
        });
      }
    }

    await Provider.of<Products>(context)
        .onAcceptRemoveSameReq(widget.product.id);
    // Provider.of<Products>(context).resumeReceivedReqStream();
    Provider.of<Products>(context).shouldListenRReq();
    print("ACCEPTED!");

    setState(() {
      _isResponding = false;
    });
    // var ref = await Firestore.instance
    //     .collection("requests")
    //     .document(widget.product.id)
    //     .collection(widget.product.id)
    //     .where('userId', isEqualTo: widget.request.userId)
    //     .getDocuments();
    // print('DOC TO BE UPDATED' + ref.documents.length.toString());
    // ref.documents.forEach((doc) async {
    //   await Firestore.instance
    //       .collection("requests")
    //       .document(widget.product.id)
    //       .collection(widget.product.id)
    //       .document(doc.documentID)
    //       .updateData({
    //     'response': 'Accepted',
    //   });
    // });
    // Provider.of<Products>(context).removeRequestLocally(widget.request);

    return;
  }

  void _onDecline() async {
    setState(() {
      _isResponding = true;
    });
    print(widget.product.id + " " + widget.request.timeStamp);

    print(_docId);
    await Firestore.instance
        .collection("requests")
        .document(widget.product.id)
        .collection(widget.product.id)
        .document(_docId)
        .updateData({
      'response': 'Declined',
    });
    Provider.of<Products>(context).removeRequestLocally(widget.request);
    setState(() {
      _isResponding = false;
    });
    return;
  }

  Widget build(BuildContext context) {
    print('*********PRODUCT NOTIFICATIONS RESPONSE WIDGET BUILT***********');
    final deviceSize = MediaQuery.of(context).size;

    // return Text(widget.document['response']);
    if (_isInit) {
      _sellerId = Provider.of<Auth>(context).userId;
      _isInit = false;
    }
    Firestore.instance
        .collection("requests")
        .document(widget.product.id)
        .collection(widget.product.id)
        .where('timeStamp', isEqualTo: widget.request.timeStamp)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
              _docId = doc.documentID;
            }));
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10,
      child: Container(
          // constraints: BoxConstraints(),
          width: deviceSize.width * 0.85,
          padding: EdgeInsets.all(10.0),
          child: Stack(children: [
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'For ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.product.prodName,
                      style: _textStyle,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'From ',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.request.userName,
                      style: _textStyle,
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (!_isResponding)
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: _onAccept,
                    color: Colors.green,
                    iconSize: 30,
                  )
                else
                  CircularProgressIndicator(),
                if (!_isResponding)
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: _onDecline,
                    color: Colors.red,
                    iconSize: 30,
                  )
                else
                  CircularProgressIndicator(),
              ],
            )
          ])),
    );
  }
}

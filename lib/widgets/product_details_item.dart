import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ent_new/models/requests.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/products.dart';

class ProductDetailsItem extends StatefulWidget {
  final Product prod;
  ProductDetailsItem({Key key, this.prod}) : super(key: key);
  _ProductDetailsItemState createState() => _ProductDetailsItemState();
}

class _ProductDetailsItemState extends State<ProductDetailsItem> {
  bool _isSendingRequest = false;
  bool _canSendRequest = true;
  bool _hasAlreadySentRequest = false;

  List<Product> _myItems;
  List<Requests> _sentRequests;
  var _userId;
  var _userName;
  final snackbar = SnackBar(
      content: Text(
    'Yay! You\'ve sent the request',
    textAlign: TextAlign.center,
  ));

  void _onSendRequest() async {
    setState(() {
      _isSendingRequest = true;
    });

    var documentReference = Firestore.instance
        .collection("requests")
        .document(widget.prod.id)
        .collection(widget.prod.id)
        .document(DateTime.now().millisecondsSinceEpoch.toString());
    await Firestore.instance.runTransaction((transaction) async {
      await transaction.set(documentReference, {
        'userId': _userId,
        'userName':_userName,
        'response': 'Pending',
        'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    });
    print("REQUEST SENT!");
    await Provider.of<Products>(context)
        .saveRequest(pid: widget.prod.id, uid: _userId)
        .then((_) {
      print("SAVED REQUEST!");
      Scaffold.of(context).showSnackBar(snackbar);
      // Navigator.of(context).pop();
      setState(() {
        _isSendingRequest = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _userId = Provider.of<Auth>(context).userId;
    _userName = Provider.of<Auth>(context).userName;
    Provider.of<Products>(context).getMyItems.forEach((item) {
      if (widget.prod.id == item.id) _canSendRequest = false;
    });
    _sentRequests = Provider.of<Products>(context).sentRequest;
    _sentRequests.forEach((req){
      if(req.prodId == widget.prod.id)
        _hasAlreadySentRequest = true;
    });
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.prod.imageUrl,
                fit: BoxFit.cover,
                width: 350,
                height: 250,
              )),
          SizedBox(
            height: 20,
          ),
          Text(
            'Price: ' + widget.prod.price.toString() + ' Rs',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          if (_canSendRequest)
            if (_isSendingRequest)
              CircularProgressIndicator()
            else if (!_hasAlreadySentRequest)
              RaisedButton(
                elevation: 20,
                onPressed: _onSendRequest,
                child: Text(
                  'Send Request to Seller',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.purple,
              )
            else
              RaisedButton(
                  onPressed: null,
                  elevation: 20,
                  child: Text(
                    'Already Requested',
                    style: TextStyle(color: Colors.white),
                  )),
        ],
      ),
    );
  }
}

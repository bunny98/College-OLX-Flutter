import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ent_new/models/requests.dart';
import 'package:ent_new/providers/auth.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class SentRequestShowResponse extends StatefulWidget {
  final Requests request;
  SentRequestShowResponse({Key key, this.request}) : super(key: key);
  _SentRequestShowResponseState createState() =>
      _SentRequestShowResponseState();
}

class _SentRequestShowResponseState extends State<SentRequestShowResponse> {
  Product prod;
  TextStyle _textStyle = TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo);

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    prod = Provider.of<Products>(context).findById(widget.request.prodId);
    // print(prod);
    var _inDocResponse = widget.request.response;
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _inDocResponse == 'Pending'
                ? [Colors.yellow, Colors.white]
                : _inDocResponse == 'Accepted'
                    ? [Colors.green, Colors.white]
                    : _inDocResponse == 'Declined'
                        ? [Colors.red, Colors.white]
                        : [Colors.black45, Colors.white],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          // color: _inDocResponse == 'Pending'
          //     ? Colors.yellow
          //     : _inDocResponse == 'Accepted'
          //         ? Colors.green
          //         : _inDocResponse == 'Declined'
          //             ? Colors.red
          //             : Colors.white,
          elevation: 10,
          child: Container(
              // constraints: BoxConstraints(),
              width: deviceSize.width * 0.85,
              padding: EdgeInsets.all(10.0),
              child: _inDocResponse == 'Deleted'|| prod == null 
                  ? Text(
                      'Requested item was ' + _inDocResponse,
                      style: _textStyle,
                      textAlign: TextAlign.center,
                    )
                  : Column(
                      children: <Widget>[
                        Text(
                          "For " + prod.prodName,
                          style: _textStyle,
                        ),
                        Text(
                          "Response " + _inDocResponse,
                          style: _textStyle,
                        ),
                      ],
                    )),
        ));
  }
}

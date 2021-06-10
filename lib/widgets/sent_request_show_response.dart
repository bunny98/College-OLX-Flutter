import 'package:ent_new/models/request.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/product.dart';

class SentRequestShowResponse extends StatefulWidget {
  final Request request;
  SentRequestShowResponse({Key key, this.request}) : super(key: key);
  _SentRequestShowResponseState createState() =>
      _SentRequestShowResponseState();
}

class _SentRequestShowResponseState extends State<SentRequestShowResponse> {
  Product prod;
  TextStyle _textStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
  TextStyle _blueTextStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue);

  void initState() {
    super.initState();
    prod = widget.request.product;
  }

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: CARD_ELEVATION,
        child: Container(
            // constraints: BoxConstraints(),
            width: deviceSize.width * 0.85,
            padding: EdgeInsets.all(10.0),
            child: Stack(children: [
              Center(
                  child: Column(
                children: <Widget>[
                  Text(
                    "For " + prod.name,
                    style: _textStyle,
                  ),
                  Text(
                    "Response " + widget.request.status,
                    style: _blueTextStyle,
                  ),
                ],
              )),
            ])),
      ),
    );
  }
}

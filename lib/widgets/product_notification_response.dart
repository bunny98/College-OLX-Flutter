import 'package:ent_new/models/request.dart';
import 'package:ent_new/view_models/order_model.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';

class ProductNotificationResponse extends StatefulWidget {
  final Request request;
  final Product product;
  ProductNotificationResponse({Key key, this.request, this.product})
      : super(key: key);
  _ProductNotificationResponseState createState() =>
      _ProductNotificationResponseState();
}

class _ProductNotificationResponseState
    extends State<ProductNotificationResponse> {
  OrderViewModel _orderViewModel;
  bool _isResponding = false;
  TextStyle _textStyle = new TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );
  var snackBarAccept = SnackBar(
    content: Text('Declining all other requests for same product'),
  );

  @override
  void initState() {
    super.initState();
    _orderViewModel = OrderViewModel.getInstance();
  }

  Future _onAccept() async {
    setState(() {
      _isResponding = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(snackBarAccept);
    //ACCEPT ORDER
    await _orderViewModel.acceptOrder(
        productId: widget.product.id, requestId: widget.request.id);

    setState(() {
      _isResponding = false;
    });
  }

  void _onDecline() async {
    setState(() {
      _isResponding = true;
    });
    //DENY ORDER
    await _orderViewModel.denyOrder(
        productId: widget.product.id, requestId: widget.request.id);

    setState(() {
      _isResponding = false;
    });
    return;
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
                        widget.product.name,
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
                        widget.request.recipientUser.name,
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
      ),
    );
  }
}

import 'package:ent_new/models/user.dart';
import 'package:ent_new/view_models/order_model.dart';
import 'package:ent_new/view_models/user_model.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsItem extends StatefulWidget {
  final Product prod;
  ProductDetailsItem({Key key, this.prod}) : super(key: key);
  _ProductDetailsItemState createState() => _ProductDetailsItemState();
}

class _ProductDetailsItemState extends State<ProductDetailsItem> {
  bool _isSendingRequest = false;
  bool _canSendRequest = true;
  bool _hasAlreadySentRequest = false;
  User _currUser;
  OrderViewModel _orderViewModel;
  final snackbar = SnackBar(
      content: Text(
    'Yay! You\'ve sent the request',
    textAlign: TextAlign.center,
  ));

  @override
  void initState() {
    super.initState();
    _currUser = UserViewModel.getInstance().getCurrUser();
    _canSendRequest = widget.prod.status == "ACTIVE";
    _hasAlreadySentRequest = widget.prod.status == "PENDING";
    _orderViewModel = OrderViewModel.getInstance();
  }

  void _onSendRequest() async {
    setState(() {
      _isSendingRequest = true;
    });

    //CREATE ORDER
    bool retVal = await _orderViewModel.createOrder(
        productId: widget.prod.id,
        renterId: _currUser.id,
        sellerId: widget.prod.sellerId);

    if (retVal) {
      setState(() {
        _hasAlreadySentRequest = true;
        _isSendingRequest = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else
      setState(() {
        _isSendingRequest = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Hero(
            tag: 'SelectedObj',
            child: Container(
              height: 400,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.prod.contentURLs[0]))),
            ),
          ),
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
              ElevatedButton(
                onPressed: _onSendRequest,
                child: Text(
                  'Send Request to Seller',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              ElevatedButton(
                  onPressed: null,
                  child: Text(
                    'Already Requested',
                    style: TextStyle(color: Colors.white),
                  )),
        ],
      ),
    );
  }
}

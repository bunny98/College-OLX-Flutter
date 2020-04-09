import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ent_new/models/requests.dart';
import 'package:ent_new/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:upi_india/upi_india.dart';

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
  Future _transaction;
  bool _hasFinishedTransaction = false;
  bool _hasPaid = false;

  Future<String> _initiateTransaction(String app) async {
    UpiIndia upi = new UpiIndia(
      app: app,
      receiverUpiId: 'abha.chourasia-1@oksbi',
      receiverName: 'Tester',
      transactionRefId: 'TestingId',
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
    );
    String response = await upi.startTransaction();
    return response;
  }

  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      prod = Provider.of<Products>(context).findById(widget.request.prodId);
    });
  }

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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
              child: _inDocResponse == 'Deleted' || prod == null
                  ? Text(
                      'Requested item was ' + _inDocResponse,
                      style: _textStyle,
                      textAlign: TextAlign.center,
                    )
                  : Stack(children: [
                      Center(
                          child: Column(
                        children: <Widget>[
                          Text(
                            "For " + prod.prodName,
                            style: _textStyle,
                          ),
                          Text(
                            "Response " + _inDocResponse,
                            style: _textStyle,
                          ),
                          if (_hasFinishedTransaction)
                            FutureBuilder(
                                future: _transaction,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  print('SNAPCONNECTION STATE' +
                                      snapshot.connectionState.toString());
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.data == null)
                                    return Center(
                                        child: CircularProgressIndicator());
                                  else {
                                    switch (snapshot.data.toString()) {
                                      case UpiIndiaResponseError
                                          .APP_NOT_INSTALLED:
                                        return Text('App Not Installed!',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.red));
                                        break;
                                      case UpiIndiaResponseError
                                          .INVALID_PARAMETERS:
                                        return Text(
                                            'App is unable to handle request!',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.red));
                                        break;
                                      case UpiIndiaResponseError.USER_CANCELLED:
                                        return Text(
                                            'It seems like you cancelled the transaction!',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.red));
                                        break;
                                      case UpiIndiaResponseError.NULL_RESPONSE:
                                        return Text(
                                          'Sorry! No data Received',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red),
                                        );
                                        break;
                                      default:
                                        UpiIndiaResponse _upiResponse;
                                        _upiResponse =
                                            UpiIndiaResponse(snapshot.data);
                                        String txnId =
                                            _upiResponse.transactionId;
                                        String resCode =
                                            _upiResponse.responseCode;
                                        String txnRef =
                                            _upiResponse.transactionRefId;
                                        String status = _upiResponse.status;
                                        String approvalRef =
                                            _upiResponse.approvalRefNo;
                                        print("RECEIVED SNAP: " + status);
                                        if (status.toLowerCase() == 'success') {
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) async {
                                            setState(() {
                                              _hasFinishedTransaction = false;
                                              _hasPaid = true;
                                            });
                                            var ref = await Firestore.instance
                                                .collection('accepted')
                                                .where('prodId',
                                                    isEqualTo: prod.id)
                                                .getDocuments();
                                            ref.documents.forEach((doc) async {
                                              await Firestore.instance
                                                  .collection('accepted')
                                                  .document(doc.documentID)
                                                  .updateData(
                                                      {'payment': 'paid'});
                                            });
                                          });
                                        }
                                        return Text(
                                          'Status: ' + status,
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w400),
                                        );
                                    }
                                  }
                                })
                        ],
                      )),
                      if (_inDocResponse == 'Accepted' && !_hasPaid)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ButtonTheme(
                                minWidth: 30,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                  elevation: 10,
                                  onPressed: () {
                                    setState(() {
                                      _transaction = _initiateTransaction(
                                          UpiIndiaApps.GooglePay);
                                      _hasFinishedTransaction = true;
                                    });
                                  },
                                  child: Text(
                                    'GPay',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.blue,
                                )),
                            ButtonTheme(
                                minWidth: 30,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 3),
                                  ),
                                  elevation: 10,
                                  onPressed: () {
                                    setState(() {
                                      _transaction = _initiateTransaction(
                                          UpiIndiaApps.PayTM);
                                      _hasFinishedTransaction = true;
                                    });
                                  },
                                  child: Text(
                                    'Paytm',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green,
                                ))
                          ],
                        ),
                    ])),
        ));
  }
}

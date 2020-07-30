import 'package:ent_new/models/requests.dart';
import 'package:ent_new/widgets/product_notification_response.dart';
import 'package:ent_new/widgets/sent_request.dart';
import 'package:ent_new/widgets/sent_request_show_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/received_request.dart';
import './product_notification.dart';
import '../models/product.dart';
import '../providers/products.dart';

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _showReceivedReq = false;
  bool _showSentReq = false;
  TextStyle _textStyle = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
  );

  @override
  Widget build(BuildContext context) {
    // Provider.of<Products>(context).shouldListenRReq();
    print('*********NOTIFICATIONS WIDGET BUILT***********');
    List<Requests> _sentRequests = Provider.of<Products>(context).sentRequest;
    List<Requests> _receivedRequests =
        Provider.of<Products>(context).receivedRequests;
    print('RECEIVED REQ LEN:' + _receivedRequests.length.toString());
    print('SENT REQ LEN:' + _sentRequests.length.toString());
    if (_receivedRequests.length > 0 && _sentRequests.length > 0)
      return ListView.builder(
          itemCount: _sentRequests.length + _receivedRequests.length + 2,
          itemBuilder: (ctx, index) {
            if (index <= _receivedRequests.length) {
              if (index == 0)
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Received Requests: ',
                      style: _textStyle,
                    ));
              Product prod = Provider.of<Products>(context)
                  .findById(_receivedRequests[index - 1].prodId);
              return ProductNotificationResponse(
                request: _receivedRequests[index - 1],
                product: prod,
              );
            } else if (index > _receivedRequests.length) {
              if (index == _receivedRequests.length + 1)
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sent Requests: ',
                      style: _textStyle,
                    ));
              int i = index - _receivedRequests.length - 2;
              return SentRequestShowResponse(request: _sentRequests[i]);
            }
          });
    else if (_receivedRequests.length > 0 || _sentRequests.length > 0) {
      return ListView.builder(
          itemCount: _sentRequests.length + _receivedRequests.length + 1,
          itemBuilder: (ctx, index) {
            if (_receivedRequests.length > 0) {
              if (index == 0)
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Received Requests: ',
                      style: _textStyle,
                    ));
              Product prod = Provider.of<Products>(context)
                  .findById(_receivedRequests[index - 1].prodId);
              return ProductNotificationResponse(
                request: _receivedRequests[index - 1],
                product: prod,
              );
            } else {
              if (index == 0)
                return Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sent Requests: ',
                      style: _textStyle,
                    ));
              int i = index - 1;
              return SentRequestShowResponse(request: _sentRequests[i]);
            }
          });
    } else {
      return Center(
        child: Text('You have no new notifications'),
      );
    }
  }
}

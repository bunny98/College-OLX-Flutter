import 'package:ent_new/models/request.dart';
import 'package:ent_new/view_models/order_model.dart';
import '../widgets/product_notification_response.dart';
import '../widgets/sent_request_show_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:ent_new/models/notification.dart' as NotificationModel;

class Notifications extends StatefulWidget {
  Notifications({Key key}) : super(key: key);
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  TextStyle _textStyle = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(builder: (context, model, _) {
      NotificationModel.Notification notification = model.getNotification();
      List<Request> _sentRequests = notification.sentRequests;
      List<Request> _receivedRequests = notification.receivedRequests;

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
                return ProductNotificationResponse(
                  request: _receivedRequests[index - 1],
                  product: _receivedRequests[index - 1].product,
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
                return SentRequestShowResponse(
                    key: UniqueKey(), request: _sentRequests[i]);
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
                return ProductNotificationResponse(
                  request: _receivedRequests[index - 1],
                  product: _receivedRequests[index - 1].product,
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
    });
  }
}

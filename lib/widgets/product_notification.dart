import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './product_notification_response.dart';

class ProductNotification extends StatefulWidget {
  final product;
  ProductNotification({Key key, this.product}) : super(key: key);
  _ProductNotificationState createState() => _ProductNotificationState();
}

class _ProductNotificationState extends State<ProductNotification> {
  Widget build(BuildContext context) {
    print('*********PRODUCT NOTIFICATIONS LIST WIDGET BUILT***********');
    return StreamBuilder(
        stream: Firestore.instance
            .collection("requests")
            .document(widget.product.id)
            .collection(widget.product.id)
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SizedBox(
              height: 0,
            ));
          } else {
            if (snapshot.data.documents.length > 0) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data.documents[index]['response'] == 'Pending')
                      return Container(
                          padding: EdgeInsets.all(5),
                          child: ProductNotificationResponse(
                              request: snapshot.data.documents[index],
                              product: widget.product));
                    else {
                      return SizedBox(
                        height: 0,
                      );
                    }
                  });
            } else
              return SizedBox(
                height: 0,
              );
          }
        });
    // return Text(widget.id);
  }
}

// import 'package:ent_new/widgets/sent_request_show_response.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SentRequest extends StatefulWidget {
//   final prodId;
//   SentRequest({Key key, this.prodId}) : super(key: key);
//   _SentRequestState createState() => _SentRequestState();
// }

// class _SentRequestState extends State<SentRequest> {
//   var _userId;

//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) {
//       _userId = Provider.of<Auth>(context).userId;
//     });
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Firestore.instance
//             .collection("requests")
//             .document(widget.prodId)
//             .collection(widget.prodId)
//             .where('userId', isEqualTo: _userId)
//             .getDocuments(),
//         builder: (context, dataSnapshot) {
//           if (!dataSnapshot.hasData) return CircularProgressIndicator();
//           print(dataSnapshot.data.documents.length);
//           if (dataSnapshot.data.documents.length > 0)
//             return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: dataSnapshot.data.documents.length,
//                 itemBuilder: (ctx, i) {
//                   return SentRequestShowResponse(
//                       request: dataSnapshot.data.documents[i],
//                       id: widget.prodId);
//                 });
//           else
//             return SizedBox(
//               height: 0,
//             );
//         });
//   }
// }

import 'package:ent_new/models/request.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Notification {
  final List<Request> sentRequests;
  final List<Request> receivedRequests;

  Notification({@required this.sentRequests, @required this.receivedRequests});

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      sentRequests:
          (map["sentRequests"] as List).map((req) => Request.fromMap(req)).toList(),
      receivedRequests:
          (map["receivedRequests"] as List).map((req) => Request.fromMap(req)).toList(),
    );
  }

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Notification(sentRequests: $sentRequests, receivedRequests: $receivedRequests)';
  }
}

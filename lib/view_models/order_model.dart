import 'package:ent_new/models/notification.dart' as NotificationModel;
import 'package:ent_new/repository/orders_repository.dart';
import 'package:flutter/material.dart';

class OrderViewModel extends ChangeNotifier {
  static OrderViewModel _uniqueInstance;

  OrderRepository _orderRepository;
  NotificationModel.Notification _currNotification;

  OrderViewModel._() {
    _currNotification =
        NotificationModel.Notification(sentRequests: [], receivedRequests: []);
    _orderRepository = OrderRepository();
  }

  static OrderViewModel getInstance() {
    if (_uniqueInstance == null) {
      _uniqueInstance = OrderViewModel._();
    }
    return _uniqueInstance;
  }

  NotificationModel.Notification getNotification() => _currNotification;

  Future<bool> createOrder(
      {String productId, String renterId, String sellerId}) async {
    return await _orderRepository.createOrder(
        sellerId: sellerId, productId: productId, renterId: renterId);
  }

  Future<bool> acceptOrder({String productId, String requestId}) async {
    return await _orderRepository.acceptOrder(
        productId: productId, requestId: requestId);
  }

  Future<bool> denyOrder({String productId, String requestId}) async {
    return await _orderRepository.denyOrder(
        productId: productId, requestId: requestId);
  }

  void initNotificationListener({String userId}) {
    _orderRepository.getNotifications(userId: userId).listen((event) {
      _currNotification = event;
      notifyListeners();
    });
  }
}

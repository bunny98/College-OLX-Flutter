import 'package:ent_new/models/notification.dart';
import 'package:ent_new/repository/base_repository.dart';

import '../constants.dart';

class OrderRepository extends Repository {
  Future<bool> createOrder(
      {String productId, String renterId, String sellerId}) async {
    Map<String, dynamic> response = await api.createOrder(
        sellerId: sellerId, productId: productId, renterId: renterId);
    return isSuccessResponse(response);
  }

  Future<bool> acceptOrder({String productId, String requestId}) async {
    Map<String, dynamic> response =
        await api.acceptOrder(productId: productId, requestId: requestId);
    return isSuccessResponse(response);
  }

  Future<bool> denyOrder({String productId, String requestId}) async {
    Map<String, dynamic> response =
        await api.denyOrder(requestId: requestId, productId: productId);
    return isSuccessResponse(response);
  }

  //STREAM RECEIVED NOTIFICATION JSON FROM API AFTER MARSHALLING INTO NOTIFICATION OBJ
  Stream<Notification> getNotifications({String userId}) async* {
    yield* api.getNotifications(userId: userId).map<Notification>(
        (Map<String, dynamic> response) =>
            Notification.fromMap(response[API_RESPONSE_KEY]));
  }
}

import 'package:ent_new/Api/api_interface.dart';

class Api implements ApiI {
  static Api _uniqueInstance;

  Api._();

  static Api getInstance() {
    if (_uniqueInstance == null) {
      _uniqueInstance = Api._();
    }
    return _uniqueInstance;
  }

  @override
  Future<Map<String, dynamic>> acceptOrder({String productId, String requestId}) {
      // TODO: implement acceptOrder
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> createCollege({String name}) {
      // TODO: implement createCollege
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> createOrder({String productId, String renterId, String sellerId}) {
      // TODO: implement createOrder
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> createProduct({String sellerId, String collegeId, String name, int price, List<String> contentURLs}) {
      // TODO: implement createProduct
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> createUser({String name, String collegeId, String mobNum}) {
      // TODO: implement createUser
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> denyOrder({String productId, String requestId}) {
      // TODO: implement denyOrder
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> getAllColleges() {
      // TODO: implement getAllColleges
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> getLobbyProducts({String userId, String collegeId}) {
      // TODO: implement getLobbyProducts
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> getMyProducts({String sellerId}) {
      // TODO: implement getMyProducts
      throw UnimplementedError();
    }
  
    @override
    Stream<Map<String, dynamic>> getNotifications({String userId}) {
      // TODO: implement getNotifications
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> getUserById({String id}) {
      // TODO: implement getUserById
      throw UnimplementedError();
    }
  
    @override
    Future<Map<String, dynamic>> updateProduct({String productId, String name, int price, List<String> contentURLs}) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getCollegeById({String id}) {
    // TODO: implement getCollegeById
    throw UnimplementedError();
  }
}

abstract class ApiI {
  //COLLEGE SERVICE APIs
  Future<Map<String, dynamic>> getAllColleges();
  Future<Map<String, dynamic>> createCollege({String name});

  //USER SERVICE APIs
  Future<Map<String, dynamic>> createUser(
      {String name, String collegeId, String mobNum});
  Future<Map<String, dynamic>> getUserById({String id});

  //PRODUCT SERVICE APIs
  Future<Map<String, dynamic>> getLobbyProducts(
      {String userId, String collegeId});
  Future<Map<String, dynamic>> getMyProducts({String sellerId});
  Future<Map<String, dynamic>> updateProduct(
      {String productId, String name, int price, List<String> contentURLs});
  Future<Map<String, dynamic>> createProduct(
      {String sellerId,
      String collegeId,
      String name,
      int price,
      List<String> contentURLs});

  //ORDERS SERVICE APIs
  Future<Map<String, dynamic>> createOrder(
      {String productId, String renterId, String sellerId});
  Stream<Map<String, dynamic>> getNotifications({String userId});
  Future<Map<String, dynamic>> acceptOrder(
      {String productId, String requestId});
  Future<Map<String, dynamic>> denyOrder({String productId, String requestId});
}

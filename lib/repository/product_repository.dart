import 'package:ent_new/constants.dart';
import 'package:ent_new/models/product.dart';
import 'package:ent_new/repository/base_repository.dart';

class ProductRepository extends Repository {
  Future<List<Product>> getLobbyProducts(
      {String userId, String collegeId}) async {
    Map<String, dynamic> response =
        await api.getLobbyProducts(userId: userId, collegeId: collegeId);
    return isSuccessResponse(response)
        ? (response[API_RESPONSE_KEY] as List)
            .map((prod) => Product.fromMap(prod))
            .toList()
        : null;
  }

  Future<List<Product>> getMyProducts({String sellerId}) async {
    Map<String, dynamic> response = await api.getMyProducts(sellerId: sellerId);
    return isSuccessResponse(response)
        ? (response[API_RESPONSE_KEY] as List)
            .map((prod) => Product.fromMap(prod))
            .toList()
        : null;
  }

  Future<Product> updateProduct(
      {String productId,
      String name,
      int price,
      List<String> contentURLs}) async {
    Map<String, dynamic> response = await api.updateProduct(
        productId: productId,
        name: name,
        price: price,
        contentURLs: contentURLs);
    return isSuccessResponse(response)
        ? Product.fromMap(response[API_RESPONSE_KEY])
        : null;
  }

  Future<Product> createProduct(
      {String name,
      int price,
      List<String> contentURLs,
      String sellerId,
      String collegeId}) async {
    Map<String, dynamic> response = await api.createProduct(
        sellerId: sellerId,
        collegeId: collegeId,
        name: name,
        price: price,
        contentURLs: contentURLs);
    return isSuccessResponse(response)
        ? Product.fromMap(response[API_RESPONSE_KEY])
        : null;
  }
}

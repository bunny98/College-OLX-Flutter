import 'package:ent_new/models/product.dart';
import 'package:ent_new/repository/product_repository.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  static ProductViewModel _uniqueInstance;
  ProductRepository _productRepository;
  List<Product> _myProducts;
  List<Product> _lobbyProducts;

  ProductViewModel._() {
    _myProducts = [];
    _lobbyProducts = [];
    _productRepository = ProductRepository();
  }

  static ProductViewModel getInstance() {
    if (_uniqueInstance == null) {
      _uniqueInstance = ProductViewModel._();
    }
    return _uniqueInstance;
  }

  List<Product> getMyProducts() => _myProducts;
  List<Product> getLobbyProducts() => _lobbyProducts;
  Product getProductWithId(String id) =>
      _lobbyProducts.firstWhere((element) => element.id == id);

  Future<bool> createProduct(
      {String name,
      int price,
      List<String> contentURLs,
      String sellerId,
      String collegeId}) async {
    Product newProd = await _productRepository.createProduct(
        name: name,
        price: price,
        contentURLs: contentURLs,
        sellerId: sellerId,
        collegeId: collegeId);
    fetchLobbyProducts(collegeId: collegeId, userId: sellerId);
    fetchMyProducts(sellerId: sellerId);
    return newProd != null;
  }

  Future<Product> updateProduct(
      {String productId,
      String name,
      int price,
      List<String> contentURLs}) async {
    Product newProd = await _productRepository.updateProduct(
      productId: productId,
      name: name,
      price: price,
      contentURLs: contentURLs,
    );
    _myProducts = _findAndReplaceProduct(
        productToReplace: newProd, listToReplaceIn: _myProducts);
    _lobbyProducts = _findAndReplaceProduct(
        productToReplace: newProd, listToReplaceIn: _lobbyProducts);
    notifyListeners();
    return newProd;
  }

  Future<bool> fetchMyProducts({String sellerId}) async {
    List<Product> _products =
        await _productRepository.getMyProducts(sellerId: sellerId);
    if (_products != null) {
      _myProducts = _products;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> fetchLobbyProducts({String userId, String collegeId}) async {
    List<Product> _products = await _productRepository.getLobbyProducts(
        userId: userId, collegeId: collegeId);
    if (_products != null) {
      _lobbyProducts = _products;
      notifyListeners();
      return true;
    }
    return false;
  }

  List<Product> _findAndReplaceProduct(
      {Product productToReplace, List<Product> listToReplaceIn}) {
    int index = listToReplaceIn
        .indexWhere((element) => element.id == productToReplace.id);
    if (index != -1) listToReplaceIn[index] = productToReplace;
    return listToReplaceIn;
  }
}

import 'package:ent_new/Api/api_interface.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';

class FakeApi implements ApiI {
  int i = 0;
  String getUniqueId() {
    return Uuid().v4();
  }

  String getRandomNames() {
    i++;
    return "RANDOM NAME $i";
  }

  @override
  Future<Map<String, dynamic>> acceptOrder(
      {String productId, String requestId}) async {
    await Future.delayed(Duration(seconds: 1));
    return {API_RESPONSE_KEY: "SUCCESS"};
  }

  @override
  Future<Map<String, dynamic>> createCollege({String name}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: {"id": getUniqueId(), "name": name, "numOfStudents": 0}
    };
  }

  @override
  Future<Map<String, dynamic>> createOrder(
      {String productId, String renterId, String sellerId}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: {
        "id": getUniqueId(),
        "renter": {
          "id": renterId,
          "name": "NEW NEW HNLU STU 1",
          "collegeId": "60ba5e1ebfeffe752996f473",
          "mobileNumber": "1234567890"
        },
        "status": "PENDING"
      }
    };
  }

  @override
  Future<Map<String, dynamic>> createProduct(
      {String sellerId,
      String collegeId,
      String name,
      int price,
      List<String> contentURLs}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: {
        "id": getUniqueId(),
        "name": name,
        "sellerId": sellerId,
        "collegeId": collegeId,
        "status": "ACTIVE",
        "price": 1000,
        "contentURLs": [
          "https://picsum.photos/250?image=9",
          "https://picsum.photos/250?image=9"
        ]
      }
    };
  }

  @override
  Future<Map<String, dynamic>> createUser(
      {String name, String collegeId, String mobNum}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: {
        "id": getUniqueId(),
        "name": name,
        "collegeId": collegeId,
        "mobileNumber": mobNum
      }
    };
  }

  @override
  Future<Map<String, dynamic>> denyOrder(
      {String productId, String requestId}) async {
    await Future.delayed(Duration(seconds: 1));
    return {API_RESPONSE_KEY: "SUCCESS"};
  }

  @override
  Future<Map<String, dynamic>> getAllColleges() async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: [
        {"id": "5fccf52475622d1797fb6626", "name": "IIIT", "numOfStudents": 10},
        {"id": "5fccf56175622d1797fb6627", "name": "HNLU", "numOfStudents": 1},
        {
          "id": "5fcd13e41ae4be3cafa1935f",
          "name": "IIT DHANBAD",
          "numOfStudents": 0
        },
        {
          "id": "608313744ebee2707c55898b",
          "name": "IIT Bombay",
          "numOfStudents": 0
        },
        {
          "id": "6083152b6ac109366576ba4c",
          "name": "IIT NEW ONE",
          "numOfStudents": 0
        },
        {
          "id": "60ba5e1ebfeffe752996f473",
          "name": "NEW CREATED COLLGED",
          "numOfStudents": 0
        }
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getLobbyProducts(
      {String userId, String collegeId}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: [
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 2",
          "price": 100,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 2",
          "price": 100,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 2",
          "price": 100,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 2",
          "price": 100,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 2",
          "price": 100,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 2",
          "price": 100,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 3",
          "price": 3,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "ITEM TEST 4",
          "price": 30,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": userId,
          "status": "MY_PRODUCT"
        },
        {
          "id": getUniqueId(),
          "name": "NOTI TEST 3",
          "price": 1000,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ],
          "sellerId": getUniqueId(),
          "status": "AVAILABLE"
        }
      ]
    };
  }

  @override
  Future<Map<String, dynamic>> getMyProducts({String sellerId}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: [
        {
          "id": getUniqueId(),
          "name": "NEW USER PROD",
          "sellerId": sellerId,
          "collegeId": getUniqueId(),
          "status": "ACTIVE",
          "price": 1000,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ]
        },
        {
          "id": getUniqueId(),
          "name": "NEW USER PROD 2",
          "sellerId": sellerId,
          "collegeId": getUniqueId(),
          "status": "ACTIVE",
          "price": 1000,
          "contentURLs": [
            "https://picsum.photos/250?image=9",
            "https://picsum.photos/250?image=9"
          ]
        },
      ]
    };
  }

  @override
  Stream<Map<String, dynamic>> getNotifications({String userId}) async* {
    while (true) {
      await Future.delayed(Duration(seconds: FAKE_NOTIFICATION_INTERVAL));
      yield {
        API_RESPONSE_KEY: {
          "sentRequests": [
            {
              "id": getUniqueId(),
              "product": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "sellerId": getUniqueId(),
                "collegeId": getUniqueId(),
                "status": "ACTIVE",
                "price": 200,
                "contentURLs": [
                  "https://picsum.photos/250?image=9",
                  "https://picsum.photos/250?image=9"
                ]
              },
              "recipientUser": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "collegeId": getUniqueId(),
                "mobileNumber": "1234567890"
              },
              "status": "PENDING"
            },
            {
              "id": getUniqueId(),
              "product": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "sellerId": getUniqueId(),
                "collegeId": getUniqueId(),
                "status": "ACTIVE",
                "price": 200,
                "contentURLs": [
                  "https://picsum.photos/250?image=9",
                  "https://picsum.photos/250?image=9"
                ]
              },
              "recipientUser": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "collegeId": getUniqueId(),
                "mobileNumber": "1234567890"
              },
              "status": "DENIED"
            },
          ],
          "receivedRequests": [
            {
              "id": getUniqueId(),
              "product": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "sellerId": getUniqueId(),
                "collegeId": getUniqueId(),
                "status": "ACTIVE",
                "price": 200,
                "contentURLs": [
                  "https://picsum.photos/250?image=9",
                  "https://picsum.photos/250?image=9"
                ]
              },
              "recipientUser": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "collegeId": getUniqueId(),
                "mobileNumber": "1234567890"
              },
              "status": "ACCEPTED"
            },
            {
              "id": getUniqueId(),
              "product": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "sellerId": getUniqueId(),
                "collegeId": getUniqueId(),
                "status": "ACTIVE",
                "price": 200,
                "contentURLs": [
                  "https://picsum.photos/250?image=9",
                  "https://picsum.photos/250?image=9"
                ]
              },
              "recipientUser": {
                "id": getUniqueId(),
                "name": getRandomNames(),
                "collegeId": getUniqueId(),
                "mobileNumber": "1234567890"
              },
              "status": "PENDING"
            },
          ]
        }
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getUserById({String id}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: {
        "id": id,
        "name": "John Doe",
        "collegeId": getUniqueId(),
        "mobileNumber": "1234567890"
      }
    };
  }

  @override
  Future<Map<String, dynamic>> updateProduct(
      {String productId,
      String name,
      int price,
      List<String> contentURLs}) async {
    await Future.delayed(Duration(seconds: 1));
    return {
      API_RESPONSE_KEY: {
        "id": productId,
        "name": name,
        "sellerId": getUniqueId(),
        "collegeId": getUniqueId(),
        "status": "ACTIVE",
        "price": price,
        "contentURLs": contentURLs
      }
    };
  }
}

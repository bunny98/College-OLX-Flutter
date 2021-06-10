import 'dart:convert';
import 'package:flutter/foundation.dart';


class User {
  final String id;
  final String name;
  final String collegeId;
  final String mobileNumber;
  User({
    @required this.id,
    @required this.name,
    @required this.collegeId,
    @required this.mobileNumber,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'collegeId': collegeId,
      'mobileNumber': mobileNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      collegeId: map['collegeId'],
      mobileNumber: map['mobileNumber'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, collegeId: $collegeId, mobileNumber: $mobileNumber)';
  }
}
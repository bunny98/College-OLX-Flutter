import 'dart:convert';

import 'package:flutter/foundation.dart';

class College {
  final String id;
  final String name;
  final int numOfStudents;
  College({
    @required this.id,
    @required this.name,
    @required this.numOfStudents,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'numOfStudents': numOfStudents,
    };
  }

  factory College.fromMap(Map<String, dynamic> map) {
    return College(
      id: map['id'],
      name: map['name'],
      numOfStudents: map['numOfStudents']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory College.fromJson(String source) =>
      College.fromMap(json.decode(source));

  College.init({
    this.id = "RANDOM",
    this.name = "IIIT Naya Raipur",
    this.numOfStudents = 0,
  });

  @override
  String toString() =>
      'College(id: $id, name: $name, numOfStudents: $numOfStudents)';
}

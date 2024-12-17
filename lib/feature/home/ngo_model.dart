import 'package:cloud_firestore/cloud_firestore.dart';

class NGOModel {
  final String ngoId;
  final String
      foodName; // Includes food name and quantity in the format "Item (Quantity)"
  final Timestamp addeddate;

  NGOModel({
    required this.ngoId,
    required this.foodName,
    required this.addeddate,
  });

  Map<String, dynamic> toMap() {
    return {
      'ngoId': ngoId,
      'foodName': foodName,
      'addeddate': addeddate,
    };
  }

  factory NGOModel.fromMap(Map<String, dynamic> map) {
    return NGOModel(
      ngoId: map['ngoId'] ?? '',
      foodName: map['foodName'] ?? '',
      addeddate: map['addeddate'] ?? Timestamp.now(),
    );
  }
}

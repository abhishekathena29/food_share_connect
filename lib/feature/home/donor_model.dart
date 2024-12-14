import 'package:cloud_firestore/cloud_firestore.dart';

class DonorModel {
  String donorId;
  String
      foodName; // Includes food name and quantity in the format "Item (Quantity)"
  Timestamp addeddate;
  bool isfulfilled;

  DonorModel({
    required this.donorId,
    required this.foodName,
    required this.addeddate,
    this.isfulfilled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'donorId': donorId,
      'foodName': foodName,
      'addeddate': addeddate,
      'isfulfilled': isfulfilled,
    };
  }

  factory DonorModel.fromMap(Map<String, dynamic> map) {
    return DonorModel(
        donorId: map['donorId'] ?? '',
        foodName: map['foodName'] ?? '',
        addeddate: map['addeddate'],
        isfulfilled: map['isfulfilled'] ?? false);
  }
}

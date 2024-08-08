import 'package:cloud_firestore/cloud_firestore.dart';

class DonorModel {
  String donorId;
  String foodName;
  Timestamp addeddate;

  DonorModel({
    required this.donorId,
    required this.foodName,
    required this.addeddate,
  });
  Map<String, dynamic> toMap() {
    return {
      'donorId': donorId,
      'foodName': foodName,
      'addeddate': addeddate,
    };
  }

  factory DonorModel.fromMap(Map<String, dynamic> map) {
    return DonorModel(
      donorId: map['donorId'] ?? '',
      foodName: map['foodName'] ?? '',
      addeddate: map['addeddate'],
    );
  }
}

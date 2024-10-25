import 'package:cloud_firestore/cloud_firestore.dart';

class NGOModel {
  final String ngoId; // Changed to ngoId for consistency
  final String foodName;
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
}

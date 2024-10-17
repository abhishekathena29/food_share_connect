import 'package:cloud_firestore/cloud_firestore.dart';

class NGOModel {
  String ngoId;
  String foodName;
  Timestamp addeddate;

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

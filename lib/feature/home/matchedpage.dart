import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngo_donor_app/feature/home/donor_model.dart';

class Matchedpage extends StatelessWidget {
  const Matchedpage({super.key, required List<String> checkedFoodItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("donorfood")
              .where("foodName", isEqualTo: "RICE")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var fooditems = snapshot.data!.docs
                  .map((food) => DonorModel.fromMap(food.data()))
                  .toList();
              return ListView.builder(
                  itemCount: fooditems.length,
                  itemBuilder: (context, index) => FutureBuilder(
                      future: null,
                      builder: (context, snapshot) {
                        return Text(fooditems[index].donorId);
                      }));
            }
            return Text("THERE IS NO DATA");
          }),
    );
  }
}

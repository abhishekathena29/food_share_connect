import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngo_donor_app/feature/home/donor_home.dart';
import 'package:ngo_donor_app/feature/home/donor_model.dart';
import 'package:ngo_donor_app/feature/home/matchedpage.dart';

class NGOHomePage extends StatelessWidget {
  const NGOHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result = await FirebaseFirestore.instance
                .collection("donorfood")
                .where("foodName", isEqualTo: "RICE")
                .get();
            var fooditems = result.docs
                .map((food) => DonorModel.fromMap(food.data()))
                .toList();
            print(fooditems.length);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Matchedpage()));
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          title: const Text("ngo Home Page"),
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 300),
                itemBuilder: (context, index) {
                  return const IandCfeatures(title: "DAL");
                },
              ),
            ),
          ],
        ));
  }
}

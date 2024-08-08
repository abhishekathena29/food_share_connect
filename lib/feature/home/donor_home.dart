import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngo_donor_app/feature/home/donor_model.dart';

List<String> checkedfood = [];

class DonorHome extends StatefulWidget {
  const DonorHome({super.key});

  @override
  State<DonorHome> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<DonorHome> {
  adddata(DonorModel data) async {
    await FirebaseFirestore.instance.collection('donorfood').add(data.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            DonorModel data1 = DonorModel(
                donorId: "ihwriguer",
                foodName: "RICE",
                addeddate: Timestamp.fromDate(DateTime.now()));
            adddata(data1);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          title: const Text("Donor Home Page"),
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

class IandCfeatures extends StatefulWidget {
  const IandCfeatures({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<IandCfeatures> createState() => _IandCfeaturesState();
}

class _IandCfeaturesState extends State<IandCfeatures> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/3_types_of_lentil.png/300px-3_types_of_lentil.png"),
          Text(widget.title),
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
                if (isChecked) {
                  checkedfood.add(widget.title);
                } else {
                  checkedfood.remove(widget.title);
                }
              });
            },
          )
        ],
      ),
    );
  }
}

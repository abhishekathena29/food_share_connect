import 'package:flutter/material.dart';

class DonorHome extends StatefulWidget {
  const DonorHome({super.key});

  @override
  State<DonorHome> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<DonorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              });
            },
          )
        ],
      ),
    );
  }
}

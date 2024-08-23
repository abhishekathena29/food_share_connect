import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ngo_donor_app/feature/home/donor_model.dart';
import 'package:ngo_donor_app/feature/home/matchedpage.dart';

List<String> checkedfood = [];

final List<Map<String, String>> foodItems = [
  {
    "name": "RICE",
    "imageUrl":
        "https://media.istockphoto.com/id/153737841/photo/rice.jpg?s=612x612&w=0&k=20&c=lfO7iLT0UsDDzra0uBOsN1rvr2d5OEtrG2uwbts33_c="
  },
  {
    "name": "DAL",
    "imageUrl":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/3_types_of_lentil.png/300px-3_types_of_lentil.png"
  },
  {
    "name": "WHEAT",
    "imageUrl":
        "https://t3.ftcdn.net/jpg/07/56/66/28/360_F_756662819_M4cJj07c4o4CWRpP07vH41nG3uhuz5jA.jpg"
  },
  {
    "name": "BEANS",
    "imageUrl":
        "https://media.istockphoto.com/id/157280488/photo/beans-diagonals.jpg?s=612x612&w=0&k=20&c=gY44S58raLHbznpSS1HKIV-QS706oRadEEaQp4i1GJI="
  },
  {
    "name": "OATS",
    "imageUrl":
        "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQk7xl1AQDWi1caZ-vEBLPfKTPuSHE_HGV1wNum6wlFuajYjwfc"
  },
  {
    "name": "FRUITS",
    "imageUrl":
        "https://t4.ftcdn.net/jpg/00/65/70/65/360_F_65706597_uNm2SwlPIuNUDuMwo6stBd81e25Y8K8s.jpg"
  },
  {
    "name": "VEGETABLES",
    "imageUrl":
        "https://t3.ftcdn.net/jpg/03/98/61/96/360_F_398619615_g8iqFtDWH5gsKjE16H6iNQ6h8BhywuFS.jpg"
  },
  {
    "name": "SUGAR",
    "imageUrl":
        "https://t3.ftcdn.net/jpg/02/22/41/82/360_F_222418209_hfwPSMzDi7pZWmCTn9NGdCJ3sijCGuQo.jpg"
  },
];

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
          if (checkedfood.isNotEmpty) {
            DonorModel data1 = DonorModel(
                donorId: FirebaseAuth.instance.currentUser!.uid,
                foodName: checkedfood.join(','),
                addeddate: Timestamp.fromDate(DateTime.now()));

            adddata(data1);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    "Thank you for submitting!An NGO will contact you shortly!")));
            // Navigate to MatchedPage after data is added
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) =>
            //           Matchedpage(checkedFoodItems: checkedfood)),
            // );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please select some foodItems")));
          }
        },
        child: const Icon(Icons.check),
        backgroundColor: Color.fromARGB(
            255, 227, 163, 2), // Mint Green for Floating Action Button
      ),
      backgroundColor: const Color(0xFFEDF2F4), // Off-White Background
      appBar: AppBar(
          title: const Text("Donor Home Page"),
          backgroundColor: Color.fromARGB(255, 227, 163, 2) // Slate Grey AppBar
          ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: foodItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 300,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return IandCfeatures(
              title: foodItems[index]['name']!,
              imageUrl: foodItems[index]['imageUrl']!,
            );
          },
        ),
      ),
    );
  }
}

class IandCfeatures extends StatefulWidget {
  const IandCfeatures({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;

  @override
  State<IandCfeatures> createState() => _IandCfeaturesState();
}

class _IandCfeaturesState extends State<IandCfeatures> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF56C6C6), // Light Blue for the container
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Light-colored text
            ),
          ),
          Checkbox(
            value: checkedfood.contains(widget.title),
            onChanged: (bool? value) {
              if (checkedfood.contains(widget.title)) {
                checkedfood.remove(widget.title);
              } else {
                checkedfood.add(widget.title);
              }
              setState(() {});
            },

            activeColor: Color.fromARGB(255, 9, 9, 9), // Coral for Checkbox
          ),
        ],
      ),
    );
  }
}

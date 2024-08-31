import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ngo_donor_app/feature/home/donor_model.dart';
import 'package:ngo_donor_app/feature/home/matchedpage.dart';

List<String> checkedFoodNGO = [];

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

class NGOHome extends StatefulWidget {
  const NGOHome({super.key});

  @override
  State<NGOHome> createState() => _NGOHomeState();
}

class _NGOHomeState extends State<NGOHome> {
  adddata(DonorModel data) async {
    await FirebaseFirestore.instance.collection('ngofood').add(data.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DonorModel data1 = DonorModel(
              donorId: FirebaseAuth.instance.currentUser!.uid,
              foodName: checkedFoodNGO.join(','),
              addeddate: Timestamp.fromDate(DateTime.now()));
          adddata(data1);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Thank you for accepting the donations!")));
          // Navigate to MatchedPage after data is added
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MatchedPage(checkedFoodItems: checkedFoodNGO)),
          );
        },
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor:
            const Color(0xFF2E3220), // Updated to match Login Page theme
      ),
      backgroundColor:
          const Color(0xFFF2F2F2), // Updated to match Login Page theme
      appBar: AppBar(
          title: const Text("NGO Home Page"),
          backgroundColor:
              const Color(0xFF608342), // Updated to match Login Page theme
          foregroundColor: Colors.white // Ensures text visibility
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
            return IandCfeaturesNGO(
              title: foodItems[index]['name']!,
              imageUrl: foodItems[index]['imageUrl']!,
            );
          },
        ),
      ),
    );
  }
}

class IandCfeaturesNGO extends StatefulWidget {
  const IandCfeaturesNGO({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String imageUrl;

  @override
  State<IandCfeaturesNGO> createState() => _IandCfeaturesNGOState();
}

class _IandCfeaturesNGOState extends State<IandCfeaturesNGO> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFFC6D8C6), // Updated to match Login Page theme
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
              color: Color(0xFF2E3220), // Updated to match Login Page theme
            ),
          ),
          Checkbox(
            value: checkedFoodNGO.contains(widget.title),
            onChanged: (bool? value) {
              if (checkedFoodNGO.contains(widget.title)) {
                checkedFoodNGO.remove(widget.title);
              } else {
                checkedFoodNGO.add(widget.title);
              }
              setState(() {});
            },
            activeColor:
                const Color(0xFF608342), // Updated to match Login Page theme
          ),
        ],
      ),
    );
  }
}

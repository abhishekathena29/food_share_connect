import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/auth/login.dart';
import 'package:food_share_connect/feature/home/donor_home.dart';
import 'package:food_share_connect/feature/home/ngo_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // getUserType(){}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodShare Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(snapshot.data!.uid)
                    .snapshots(),
                builder: (context, storeSnapshot) {
                  if (storeSnapshot.hasData &&
                      storeSnapshot.data != null &&
                      storeSnapshot.data!.data() != null) {
                    if (storeSnapshot.data!.data()!['userType'] ==
                        "UserType.ngo") {
                      return const NGOHome();
                    } else if (storeSnapshot.data!.data()!['userType'] ==
                        "UserType.donor") {
                      return const DonorHome();
                    } else {
                      return const LoginPage();
                    }
                  } else {
                    return const Scaffold(
                      backgroundColor: Color(0xff121212),
                      body: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }
                });
          }
          return const LoginPage();
        },
      ),
    );
  }
}

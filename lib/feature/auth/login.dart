import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_share_connect/feature/auth/register.dart';
import 'package:food_share_connect/feature/home/donor_home.dart';
import 'package:food_share_connect/feature/home/ngo_home.dart';
import 'package:food_share_connect/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor, // Use a vibrant background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'FoodShare',
                  style: TextStyle(
                    color: AppColors.primaryColor, // Vibrant accent color
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'CONNECT',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 28,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: AppColors.textColor),
                    filled: true,
                    fillColor: AppColors.inputBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passController,
                  obscureText: true, // Obscure text for password field
                  style: const TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: AppColors.textColor),
                    filled: true,
                    fillColor: AppColors.inputBoxColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 30),
                isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: AppColors.textColor,
                      ))
                    : GestureDetector(
                        onTap: () async {
                          print('//////////////////////');
                          print("Starting login process");
                          print(
                              "Email: ${emailController.text}"); // Print email without password

                          if (!mounted) {
                            print("Widget not mounted before authentication");
                            return;
                          }

                          setState(() {
                            isloading = true;
                          });

                          // Test Firebase connection first
                          try {
                            print("Testing Firebase connection...");
                            // Remove this line in production - only for testing
                            // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
                            print("Firebase connection successful");
                          } catch (e) {
                            print("Firebase connection test error: $e");
                            // Continue anyway as this is just a test
                          }

                          try {
                            // Attempt authentication
                            print("Attempting Firebase authentication...");
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passController.text,
                            );

                            print("Authentication successful");
                            print("User ID: ${credential.user?.uid}");

                            // Immediately verify the auth state
                            await Future.delayed(const Duration(
                                milliseconds:
                                    500)); // Short delay to ensure auth state is updated
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            print(
                                "Current user verification - UID: ${currentUser?.uid}");

                            if (!mounted) {
                              print("Widget not mounted after authentication");
                              return;
                            }

                            if (currentUser == null) {
                              print(
                                  "Error: User is null after successful authentication");
                              throw FirebaseAuthException(
                                  code: 'auth-state-error',
                                  message:
                                      'Authentication state error occurred');
                            }

                            // Test Firestore connection
                            print("Testing Firestore connection...");
                            try {
                              final userDoc = await FirebaseFirestore.instance
                                  .collection("user")
                                  .doc(currentUser.uid)
                                  .get();

                              print("Firestore fetch successful");
                              print("Document exists: ${userDoc.exists}");

                              if (!mounted) {
                                print(
                                    "Widget not mounted after Firestore fetch");
                                return;
                              }

                              if (userDoc.exists) {
                                final userData = userDoc.data();
                                final userType = userData?["userType"];
                                print("User type from Firestore: $userType");

                                // Reset loading state before navigation
                                setState(() {
                                  isloading = false;
                                });

                                if (mounted) {
                                  print(
                                      "Preparing navigation to ${userType == "UserType.donor" ? "DonorHome" : "NGOHome"}");

                                  // Wrap navigation in a microtask to avoid any potential state issues
                                  Future.microtask(() {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              userType == "UserType.donor"
                                                  ? const DonorHome()
                                                  : const NGOHome()),
                                    );
                                  });
                                }
                              } else {
                                print(
                                    "User document doesn't exist in Firestore");
                                throw FirebaseException(
                                    plugin: 'cloud_firestore',
                                    message: 'User data not found');
                              }
                            } catch (firestoreError) {
                              print("Firestore error: $firestoreError");
                              rethrow;
                            }
                          } on FirebaseAuthException catch (e) {
                            print("FirebaseAuthException: ${e.code}");
                            print("Error message: ${e.message}");
                            if (mounted) {
                              setState(() {
                                isloading = false;
                              });

                              String errorMessage = switch (e.code) {
                                'user-not-found' =>
                                  'No user found with this email.',
                                'wrong-password' => 'Incorrect password.',
                                'invalid-email' => 'Invalid email address.',
                                'user-disabled' =>
                                  'This account has been disabled.',
                                'auth-state-error' =>
                                  'Authentication state error. Please try again.',
                                _ => 'Authentication failed: ${e.message}',
                              };

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(errorMessage),
                                duration: const Duration(seconds: 3),
                              ));
                            }
                          } on FirebaseException catch (e) {
                            print(
                                "FirebaseException: ${e.plugin} - ${e.message}");
                            if (mounted) {
                              setState(() {
                                isloading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Database error: ${e.message}'),
                                duration: const Duration(seconds: 3),
                              ));
                            }
                          } catch (e) {
                            print("Unexpected error during login: $e");
                            if (mounted) {
                              setState(() {
                                isloading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'An unexpected error occurred: ${e.toString()}'),
                                duration: const Duration(seconds: 3),
                              ));
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.contrastTextColor),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(color: AppColors.textColor),
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor
                              // Accent color for 'Register'
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

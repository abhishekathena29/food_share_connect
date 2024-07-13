import 'package:flutter/material.dart';
import 'package:ngo_donor_app/feature/auth/register.dart';
import 'package:ngo_donor_app/feature/home/donor_home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'FoodShare',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'CONNECT',
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'password',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DonorHome()));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xff038C8C),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: const Text.rich(
                  TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(color: Color(0xffFFFFFF)),
                      children: [
                        TextSpan(
                            text: 'Register',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

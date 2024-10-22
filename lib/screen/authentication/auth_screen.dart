import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart_example/screen/authentication/login_screen.dart';
import 'package:shopping_cart_example/screen/product_list_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const ProductGridScreen();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}

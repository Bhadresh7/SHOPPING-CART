import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopping_cart_example/helpers/debounce_helper.dart';
import 'package:shopping_cart_example/helpers/toast_helper.dart';
import 'package:shopping_cart_example/screen/authentication/login_screen.dart';
import 'package:shopping_cart_example/screen/product_list_screen.dart';

class AuthenticationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey1 = GlobalKey<FormBuilderState>();

  // final formKey2 = GlobalKey<FormBuilderState>();
  final DebounceHelper _debounceHelper = DebounceHelper();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

//sign out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      await _googleSignIn.signOut();

      notifyListeners();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }

  //Reset password
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ToastHelper.showSuccessToast(
          context: context, message: "Password reset email sent successfully");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Handle errors
      ToastHelper.showErrorToast(
          context: context, message: e.message ?? "Error resetting password");
    }
  }

  //Form registeration
  void userSignUp(BuildContext context) {
    if (formKey1.currentState?.saveAndValidate() ?? false) {
      final email = formKey1.currentState?.fields['email']?.value;
      final password = formKey1.currentState?.fields['password']?.value;

      _debounceHelper.debounce(() async {
        final navigator = Navigator.of(context);

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          print(userCredential);

          navigator.pop();

          ToastHelper.showSuccessToast(
              context: context, message: "Registration Successful");

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ProductGridScreen()),
            (Route<dynamic> route) => false,
          );
        } on FirebaseAuthException catch (e) {
          navigator.pop();

          ToastHelper.showErrorToast(
              context: context, message: e.code.toString());
        }
      });
    }
  }

  //Google Auth
  Future<void> googleRegister(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        ToastHelper.showErrorToast(
            context: context, message: "Sign-in canceled");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        ToastHelper.showErrorToast(
            context: context, message: "Authentication failed");
        return;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductGridScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ToastHelper.showErrorToast(
              context: context, message: "Email is already in use.");
        } else {
          // Handle other FirebaseAuth exceptions
          ToastHelper.showErrorToast(
              context: context, message: "Registration failed: ${e.message}");
        }
      }
    } catch (e) {
      print("Error during Google registration: ${e.toString()}");
      ToastHelper.showErrorToast(
          context: context, message: "Error during registration");
    }
  }
}

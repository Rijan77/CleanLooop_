import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../CustomDialog.dart';
import '../../homePage.dart';

class AuthHelper {
  final AuthService _auth = AuthService();

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final user = await _auth.loginWithGoogle();

      if (user != null) {
        CustomDialog.showSuccessDialog(
          context: context,
          title: "Welcome Back!",
          message: "You have successfully signed in with Google.",
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const WasteCleaningHomePage()),
            );
          },
        );
      } else {
        CustomDialog.showSnackBar(
          context: context,
          message: "Login failed. Please check your credentials and try again.",
        );
      }
    } catch (e) {
      CustomDialog.showSnackBar(
        context: context,
        message: "An error occurred: ${e.toString()}",
      );
    }
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    try {
      final user = await _auth.loginWithFacebook();

      if (user != null) {
        CustomDialog.showSuccessDialog(
          context: context,
          title: "Welcome!",
          message: "You have successfully registered using Facebook.",
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const WasteCleaningHomePage()),
            );
          },
        );
      } else {
        CustomDialog.showSnackBar(
          context: context,
          message: "Registration was not completed. Please try again.",
        );
      }
    } catch (e) {
      CustomDialog.showSnackBar(
        context: context,
        message: "Facebook registration failed. Please try again later.",
      );
    }
  }
}

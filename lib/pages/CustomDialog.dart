import 'package:flutter/material.dart';


class CustomDialog{
  static void showSnackBar({required BuildContext context,required String message,}){
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccessDialog({ required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Text(title, style:const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )
                ,),
            ],
          ),
          content: Text(message,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black87
            ),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text("OK",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            ),
          ],
        );
      },
    );
  }
}
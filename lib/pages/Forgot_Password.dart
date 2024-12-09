import 'package:cleanloop/pages/LoginPage.dart';
import 'package:cleanloop/pages/auth_service.dart';
import 'package:flutter/material.dart';
import 'CustomDialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("lib/assets/images/Vector 2.png"),
            SizedBox(
                height: screenHeight * 0.18,
                child: Image.asset(
                  "lib/assets/images/ForgotPassword.png",
                  fit: BoxFit.cover,
                )),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              "Forgot Password",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            ),
            SizedBox(height: screenHeight * 0.1),
            const Text(
              "Enter Your Email Address",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: screenHeight * 0.01),
            SizedBox(
              height: screenHeight * 0.1,
              width: screenWidth * 0.8,
              child: TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                      hintText: "example@gmail.com",
                      hintStyle:
                      TextStyle(fontSize: 17, color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 2, color: Colors.black54)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black),
                      ))),
            ),
            SizedBox(height: screenHeight * 0.05),
            InkWell(
              onTap: () async {
                String email = _email.text.trim();
                if (email.isEmpty) {
                  CustomDialog.showSnackBar(
                    context: context,
                    message: "Please enter your email address.",
                  );
                } else {
                  try {
                    await _auth.sendPasswordResetLink(email);
                    CustomDialog.showSuccessDialog(
                      context: context,
                      title: "Success",
                      message: "A password reset link has been sent to $email.",
                      onConfirm: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Loginpage())); // Navigate back to login
                      },
                    );
                  } catch (error) {
                    CustomDialog.showSnackBar(
                      context: context,
                      message: "Failed to send the email. Please try again.",
                    );
                  }
                }
              },
              child: Container(
                height: screenHeight * 0.063,
                width: screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Center(
                  child: Text(
                    "Send",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "calistoga",
                        letterSpacing: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black54,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Or Continue with",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black54,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: screenWidth * 0.14,
                    width: screenWidth * 0.14,
                    child: Image.asset("lib/assets/images/google.logo.png"),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: screenWidth * 0.16,
                    width: screenWidth * 0.16,
                    child: Image.asset("lib/assets/images/facebook.logo.png"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cleanloop/pages/user_auth/RegistrationPage.dart';
import 'package:cleanloop/pages/user_auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../CustomDialog.dart';
import 'AuthHelper.dart';
import 'Forgot_Password.dart';
import '../../homePage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _auth = AuthService();
  final AuthHelper _authHelper = AuthHelper();

  bool _isPasswordVisible = false;

  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isLogin = false;

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "lib/assets/images/Vector 2.png",
              width: screenWidth,
              fit: BoxFit.cover,
            ),
            SizedBox(height: screenHeight * 0.02),
            Image.asset(
              "lib/assets/images/Loginpage.icon.png",
              width: screenWidth * 0.75,
            ),
            SizedBox(height: screenHeight * 0.029),
            _buildEmailTextField(screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildPasswordTextField(screenWidth),
            _buildForgotPasswordButton(screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildLoginButton(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),
            _buildDividerRow(),
            SizedBox(height: screenHeight * 0.02),
            _buildSocialLoginRow(screenWidth),
            SizedBox(height: screenHeight * 0.03),
            _buildSignUpRow(context),
          ],
        ),
      ),
    );
  }

  Padding _buildEmailTextField(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: TextField(
        controller: _email,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0x33F5F5F5),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email_outlined, size: 30),
                SizedBox(
                  height: 32,
                  child: VerticalDivider(
                    color: Colors.black54,
                    thickness: 1.5,
                    width: 15,
                  ),
                )
              ],
            ),
          ),
          labelText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }

  Padding _buildPasswordTextField(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: TextField(
        controller: _password,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0x33F5F5F5),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 30),
                SizedBox(
                  height: 32,
                  child: VerticalDivider(
                    color: Colors.black54,
                    thickness: 1.5,
                    width: 15,
                  ),
                )
              ],
            ),
          ),
          labelText: "Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }

  Padding _buildForgotPasswordButton(double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.1),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ForgotPassword()),
            );
          },
          child: const Text(
            "Forgot your Password?",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  InkWell _buildLoginButton(double screenWidth, double screenHeight) {
    return InkWell(
      onTap: _login,
      child: Container(
        height: screenHeight * 0.067,
        width: screenWidth * 0.6,
        decoration: BoxDecoration(
          color: Colors.green.shade500,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child:  _isLogin?CircularProgressIndicator(
          )  :Text(
            "Login",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: "calistoga",
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  Row _buildDividerRow() {
    return const Row(
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
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.black54,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Row _buildSocialLoginRow(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGoogleLoginButton(screenWidth),
        _buildFacebookLoginButton(screenWidth),
      ],
    );
  }

  InkWell _buildGoogleLoginButton(double screenWidth) {
    return InkWell(
      onTap: ()async{
        setState(() {
          _isGoogleLoading=true;
        });
        await _authHelper.loginWithGoogle(context);

        setState(() {
          _isGoogleLoading = false;
        });
      },

      child: _isGoogleLoading
          ? const CircularProgressIndicator()
          : SizedBox(
        height: screenWidth * 0.14,
        width: screenWidth * 0.14,
        child: Image.asset("lib/assets/images/google.logo.png"),
      ),
    );
  }

  InkWell _buildFacebookLoginButton(double screenWidth) {
    return InkWell(
      onTap: ()async{
        setState(() {
          _isFacebookLoading = true;
        });
        await _authHelper.loginWithFacebook(context);
        setState(() {
          _isFacebookLoading = false;
        });
    },
      child: _isFacebookLoading
          ? const CircularProgressIndicator()
          : SizedBox(
        height: screenWidth * 0.16,
        width: screenWidth * 0.16,
        child: Image.asset("lib/assets/images/facebook.logo.png"),
      ),
    );
  }

  Row _buildSignUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account yet?  ",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Registrationpage()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }

  _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      CustomDialog.showSnackBar(
        context: context,
        message: "Email and Password cannot be empty.",
      );
      return;
    }

    if (!_email.text.contains("@")) {
      CustomDialog.showSnackBar(
        context: context,
        message: "Please enter a valid email address.",
      );
      return;
    }

    setState(() {
      _isLogin = true;
    });

    try {
      final user = await _auth.loginUserWithEmailAndPassword(
        _email.text.trim(),
        _password.text.trim(),
      );

      if (user != null) {
        if (!user.emailVerified) {
          CustomDialog.showSnackBar(
            context: context,
            message: "Please verify your email. A new verification link has been sent to your email.",
          );
          await _auth.sendEmailVerificationLink();
          return;
        }

        CustomDialog.showSuccessDialog(
          context: context,
          title: "Welcome Back!",
          message: "You have successfully logged in.",
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
    }finally{
      setState(() {
        _isLogin = false;
      });
    }
  }

}
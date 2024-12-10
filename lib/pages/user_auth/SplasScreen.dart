import 'package:cleanloop/pages/user_auth/wrapper.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});
  // hello

  @override
  State<Splashscreen> createState() => _SplasscreenState();
}

class _SplasscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Duration for fade out
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    // Wait for 2.2 seconds, then start fade out and navigate
    Future.delayed(const Duration(milliseconds: 2200), () {
      _fadeController.forward().then((_) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const Wrapper(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Adjust based on your theme
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Image.asset(
              "lib/assets/images/cleanloop logo.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
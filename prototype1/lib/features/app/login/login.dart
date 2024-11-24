import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final Widget? child;
  const LoginScreen({super.key, this.child});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Fade-in animation
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Scale animation for the text
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start the animation
    _animationController.forward();

    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (!mounted) return; // Ensure the widget is still mounted
        if (widget.child != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => widget.child!),
            (route) => false,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: const Text(
                "Welcome to",
                style: TextStyle(
                  fontFamily: "Unica_One", // Ensure the font is added
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10), // Add a smaller gap
            FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                'assets/images/logo.png', // Path to your logo
                width: 300, // Adjusted to a smaller size
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_selection.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _markOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 24, 26),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/feeling_tired.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 15,
              left: 30,
              child: Image.asset(
                'assets/images/logos/logoandname.png',
                height: 75,
              ),
            ),
            const Positioned(
              top: 90,
              left: 30,
              right: 110,
              child: Text(
                "Feeling Tired of the Manual Work?",
                style: TextStyle(
                  fontFamily: "SpaceGrotesk",
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color.fromARGB(255, 17, 17, 17),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 0, 0, 3),
                        Color.fromRGBO(0, 0, 0, 65),
                        Color.fromRGBO(0, 0, 0, 100),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Have you ever tried being procrastinated before...",
                        style: TextStyle(
                          fontFamily: "SpaceGrotesk",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 196, 0),
                          foregroundColor:
                              const Color.fromARGB(255, 17, 17, 17),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 125, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          await _markOnboardingComplete();
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserSelectionScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontFamily: "SpaceGrotesk",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

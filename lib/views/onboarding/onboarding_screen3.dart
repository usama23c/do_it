import 'package:flutter/material.dart';

import 'onboarding_screen4.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/service3.png', // Your image
                width: 250,
                height: 250,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "create a team task, invite\npeople and manage your\nwork together",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(isActive: false),
                const SizedBox(width: 6),
                _buildDot(isActive: false),
                const SizedBox(width: 6),
                _buildDot(isActive: true),
                const SizedBox(width: 6),
                _buildDot(isActive: false),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xFFE0E0E0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Color(0xFF0D47A1),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen4(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(1.0, 0.0), // Start from right
                            end: Offset.zero,              // End at center
                          ).animate(animation);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },

                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      width: isActive ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

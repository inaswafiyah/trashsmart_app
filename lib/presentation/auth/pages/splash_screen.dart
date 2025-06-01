import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/pages/onboarding.dart'; // Halaman Onboarding
import 'package:trashsmart/presentation/auth/pages/login.dart'; // Halaman Login
import 'package:trashsmart/widget/bottom.dart'; // Halaman utama setelah login

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  bool _showContent = false;
  bool _showGreenBackground = false;

  @override
  void initState() {
    super.initState();

    // Tampilkan logo & teks dengan efek fade-in setelah 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showContent = true;
      });
    });

    // Tampilkan latar hijau setelah 2500ms
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _showGreenBackground = true;
      });
    });

    // Navigasi setelah 3500ms (kode kamu tetap)
    Future.delayed(const Duration(milliseconds: 3500), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bottom()),
        );
      } else {
        final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
        if (hasSeenOnboarding) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showGreenBackground ? const Color(0xFF00973A) : Colors.white,
      body: Center(
        child: !_showGreenBackground
            ? AnimatedOpacity(
                opacity: _showContent ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Trashsmart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00973A),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}

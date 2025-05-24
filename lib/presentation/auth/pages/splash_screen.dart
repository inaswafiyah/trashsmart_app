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
  late AnimationController _controller;
  late Animation<Offset> _textOffsetAnimation;
  bool _showContent = false;
  bool _showGreenBackground = false;

  @override
  void initState() {
    super.initState();

    // Setup animation controller untuk animasi teks
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Setup animasi untuk teks
    _textOffsetAnimation = Tween<Offset>(begin: const Offset(0.0, 2.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Tampilkan logo & teks setelah 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showContent = true;
      });
      _controller.forward();
    });

    // Tampilkan latar hijau setelah 2500ms
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _showGreenBackground = true;
      });
    });

    // Cek login status dan navigasi setelah 3500ms
    Future.delayed(const Duration(milliseconds: 3500), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token'); // Cek token di SharedPreferences

      if (token != null) {
        // Jika token ada, langsung ke halaman utama (HomePage atau Bottom)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bottom()), // Halaman utama setelah login
        );
      } else {
        // Jika token tidak ada, cek apakah sudah melihat Onboarding
        final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

        if (hasSeenOnboarding) {
          // Jika sudah melihat onboarding sebelumnya, langsung ke halaman login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Jika belum melihat onboarding, arahkan ke halaman Onboarding
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showGreenBackground ? Color(0xFF00973A) : Colors.white,
      body: Center(
        child: !_showGreenBackground && _showContent
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo aplikasi
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  // Animasi teks "Trashsmart"
                  SlideTransition(
                    position: _textOffsetAnimation,
                    child: const Text(
                      'Trashsmart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00973A),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(), // Tampilkan kosong jika latar hijau sudah muncul
      ),
    );
  }
}

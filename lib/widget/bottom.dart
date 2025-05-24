import 'package:flutter/material.dart';
import 'package:trashsmart/edukasi/edukasi_page.dart';
import 'package:trashsmart/widget/donation_card.dart';
import 'package:trashsmart/widget/home.dart';
import 'package:trashsmart/widget/profile.dart';

void main() {
  runApp(const Bottom());
}

class Bottom extends StatelessWidget {
  const Bottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
    HalamanUtama(),
    DonasiCard(),
    HalamanEdukasiPage(),
    const ProfilePages(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'assets/icons/beranda.png', 'Beranda'),
              _buildNavItem(1, 'assets/icons/donasi.png', 'Donasi'),
              _buildNavItem(2, 'assets/icons/edukasi.png', 'Edukasi'),
              _buildNavItem(3, 'assets/icons/profile.png', 'Akun'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: isSelected ? const Color(0xFF00973A) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF00973A) : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Example Pages
class BerandaPage extends StatelessWidget {
  const BerandaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Halaman Beranda', style: TextStyle(fontSize: 24)),
    );
  }
}

class DonasiPage extends StatelessWidget {
  const DonasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Halaman Donasi', style: TextStyle(fontSize: 24)),
    );
  }
}

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Halaman Edukasi', style: TextStyle(fontSize: 24)),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Halaman Profil', style: TextStyle(fontSize: 24)),
    );
  }
}

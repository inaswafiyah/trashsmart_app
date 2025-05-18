import 'package:flutter/material.dart';

class ProgresDonasiPage extends StatelessWidget {
  const ProgresDonasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama putih
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Progres Donasi',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Column(
        children: [
          // CARD HIJAU ATAS
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF00973A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progres Donasimu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24), // Diperbesar dari 16 -> 24
                Row(
                  children: const [
                    Icon(Icons.star, color: Color(0xFFFDC901), size: 50),
                    SizedBox(width: 8),
                    Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Total Bintangmu',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 4,
                    width: double.infinity,
                    color: const Color(0xFFFDC901),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kumpulkan bintang, wujudkan kebaikan!',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          // BAGIAN ABU HANYA DI ANTARA CARD HIJAU DAN IKON DONASI
          Container(
            width: double.infinity,
            height: 16,
            color: const Color(0xFFF5F5F5),
          ),

          // IKON DONASI DAN GARIS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/iconsdonasi.png',
                    width: 34,
                    height: 34,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Total Donasi: 0',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // SISA HALAMAN PUTIH
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:trashsmart/data/datasource/auth_remote_datasource.dart';

class ProgresDonasiPage extends StatefulWidget {
  const ProgresDonasiPage({super.key});

  @override
  State<ProgresDonasiPage> createState() => _ProgresDonasiPageState();
}

class _ProgresDonasiPageState extends State<ProgresDonasiPage> {
  int totalDonasi = 0;
  bool isLoadingDonasi = true;

  @override
  void initState() {
    super.initState();
    _loadTotalDonasi();
  }

  Future<void> _loadTotalDonasi() async {
    setState(() {
      isLoadingDonasi = true;
    });
    try {
      final total = await AuthRemoteDatasource().getTotalDonasi();
      if (!mounted) return;
      setState(() {
        totalDonasi = total;
        isLoadingDonasi = false;
      });
    } catch (e) {
      setState(() {
        isLoadingDonasi = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Progres Penukaranmu',
          style: TextStyle(
            fontSize: 20,
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
                  'Progres Penukaranmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFDC901), size: 50),
                    const SizedBox(width: 8),
                    Text(
                      isLoadingDonasi ? "..." : "$totalDonasi",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
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

          // BAGIAN ABU DI ANTARA CARD DAN ISI
          Container(
            width: double.infinity,
            height: 16,
            color: const Color(0xFFF5F5F5),
          ),

          // IKON DONASI & TEKS
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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/iconsdonasi.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total Bintang: ${isLoadingDonasi ? "..." : "$totalDonasi"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // SISA HALAMAN KOSONG PUTIH
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
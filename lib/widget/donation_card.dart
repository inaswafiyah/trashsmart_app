import 'package:flutter/material.dart';
import 'package:trashsmart/widget/donation_page.dart';
import 'package:trashsmart/widget/donation_page2.dart';
import 'package:trashsmart/widget/donation_page3.dart';

class DonasiCard extends StatelessWidget {
  const DonasiCard({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> bankSampahList = const [
    {
      'nama': 'Bank Sampah Kowasa',
      'alamat':
          'Jl. Raya Jonggol-Dayeuh No.19, Sukasirna, Kec. Jonggol, Kab. Bogor, Jawa Barat 16830',
    },
    {
      'nama': 'Bank Sampah Al Amin',
      'alamat':
          'Singajaya, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830',
    },
    {
      'nama': 'Bank Sampah Posal',
      'alamat':
          'Kp. Jl. Pojok Salak No.02/08, Jonggol, Kec. Jonggol, Kabupaten Bogor, Jawa Barat',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF009B3E),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Donasi',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 19), // ← Tambah jarak atas dan bawah
            child: Text(
              'Bank sampah kami',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...List.generate(bankSampahList.length, (index) {
            final bank = bankSampahList[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/map.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bank['nama'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13, // ← Ukuran lebih kecil
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bank['alamat'],
                              style: const TextStyle(fontSize: 11), // ← Ukuran lebih kecil
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Widget? targetPage;
                                switch (index) {
                                  case 0:
                                    targetPage = DonasiPage1();
                                    break;
                                  case 1:
                                    targetPage = DonasiPage2();
                                    break;
                                  case 2:
                                    targetPage = DonasiPage3();
                                    break;
                                }

                                if (targetPage != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => targetPage!),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF009B3E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Jadikan Tujuan',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
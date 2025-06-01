import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/message/resi_form.dart';
import 'dart:convert';

import 'riwayat_penukaran_model.dart';

Future<void> tambahRiwayat(RiwayatPenukaran riwayat) async {
  final prefs = await SharedPreferences.getInstance();
  final String? riwayatJson = prefs.getString('riwayat_penukaran');
  List listRiwayat = riwayatJson != null ? jsonDecode(riwayatJson) : [];
  listRiwayat.add(riwayat.toJson());
  await prefs.setString('riwayat_penukaran', jsonEncode(listRiwayat));
}

Future<List<RiwayatPenukaran>> ambilRiwayat() async {
  final prefs = await SharedPreferences.getInstance();
  final String? riwayatJson = prefs.getString('riwayat_penukaran');
  if (riwayatJson == null) return [];
  List listRiwayat = jsonDecode(riwayatJson);
  return listRiwayat.map((e) => RiwayatPenukaran.fromJson(e)).toList();
}

class RiwayatPenukaranPage extends StatelessWidget {
  final List<RiwayatPenukaran> riwayatList;
  const RiwayatPenukaranPage({super.key, required this.riwayatList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009A44),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Riwayat Penukaran',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: riwayatList.length,
        itemBuilder: (context, index) {
          final riwayat = riwayatList.reversed.toList()[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResiPenyerahanPage(
                    nama: riwayat.nama, // pastikan field ini ada di model
                    noTelepon: riwayat.noTelepon,
                    tanggalDropOff: riwayat.tanggal,
                    jenisSampah: riwayat.jenisSampah,
                    bankSampahNama: riwayat.bankSampahNama,
                    bankSampahAlamat: riwayat.bankSampahAlamat,
                    kategoriHarga: riwayat.kategoriHarga, // pastikan field ini ada
                    kategoriTerpilih: riwayat.kategoriTerpilih, // pastikan field ini ada
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6E6E6)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tanggal
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/icon_kalender.png',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        riwayat.tanggal, // dari model
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Card dua kolom
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // Jenis sampah
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Jenis sampah',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  riwayat.jenisSampah, // dari model
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Tujuan
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tujuan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  riwayat.bankSampahNama, // dari model
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status diterima
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Color(0xFF43936C),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Diterima pada ${riwayat.tanggal}', // dari model
                        style: TextStyle(
                          color: Color(0xFF43936C),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
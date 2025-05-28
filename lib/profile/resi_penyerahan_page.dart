// Tambahkan import
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:trashsmart/profile/riwayat_penukaran_model.dart';
import 'package:trashsmart/profile/resi_penyerahan_page.dart'; // atau lokasi tambahRiwayat

// Fungsi untuk menambah riwayat
Future<void> tambahRiwayat(RiwayatPenukaran riwayat) async {
  final prefs = await SharedPreferences.getInstance();
  final String? riwayatJson = prefs.getString('riwayat_penukaran');
  List listRiwayat = riwayatJson != null ? jsonDecode(riwayatJson) : [];
  listRiwayat.add(riwayat.toJson());
  await prefs.setString('riwayat_penukaran', jsonEncode(listRiwayat));
}
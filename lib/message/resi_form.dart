import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashsmart/widget/bottom.dart';
import 'package:trashsmart/riwayat_resi/riwayat_penukaran.dart';
import 'package:trashsmart/riwayat_resi/riwayat_penukaran_model.dart';

class ResiPenyerahanPage extends StatelessWidget {
  final String nama;
  final String noTelepon;
  final String tanggalDropOff;
  final String jenisSampah;
  final String bankSampahNama;
  final String bankSampahAlamat;
  final Map<String, int> kategoriHarga;
  final List<String> kategoriTerpilih;

  const ResiPenyerahanPage({
    super.key,
    required this.nama,
    required this.noTelepon,
    required this.tanggalDropOff,
    required this.jenisSampah,
    required this.bankSampahNama,
    required this.bankSampahAlamat,
    required this.kategoriHarga,
    required this.kategoriTerpilih,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF00973A);
    final NumberFormat currencyFormat = NumberFormat('#,###', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Bukti Penyerahan Sampah',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bankSampahNama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bankSampahAlamat,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(height: 20, thickness: 1),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check_circle, color: Color(0xFF43936C)),
                            SizedBox(width: 7),
                            Text(
                              'Data Dirimu Berhasil Disimpan!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Informasi Pengguna:',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        buildInfoRow('Nama', nama),
                        buildInfoRow('No. Telephone', noTelepon),
                        buildInfoRow('Tanggal Drop off', tanggalDropOff),
                        buildInfoRow('Jenis Sampah', jenisSampah),
                        const SizedBox(height: 16),
                        const Text(
                          'Harga Sampahmu:',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...kategoriTerpilih.map(
                              (kategori) => buildInfoRow(
                                kategori,
                                kategoriHarga[kategori.toLowerCase()] != null
                                    ? 'Rp. ${currencyFormat.format(kategoriHarga[kategori.toLowerCase()])}/kg'
                                    : '-',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Catatan:',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Nilai tukar akan ditambah setelah\npenimbangan di lokasi drop-off',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 31),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await tambahRiwayat(
                      RiwayatPenukaran(
                        tanggal: tanggalDropOff,
                        jenisSampah: jenisSampah,
                        bankSampahNama: bankSampahNama,
                        bankSampahAlamat: bankSampahAlamat,
                        nama: nama,
                        noTelepon: noTelepon,
                        kategoriHarga: kategoriHarga,
                        kategoriTerpilih: kategoriTerpilih,
                      ),
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => Bottom()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    'Kembali keberanda',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

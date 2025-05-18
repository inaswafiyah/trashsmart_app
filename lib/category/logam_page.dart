import 'package:flutter/material.dart';
import 'package:trashsmart/widget/form_diri.dart';

class LogamDetailPage extends StatefulWidget {
  const LogamDetailPage({super.key});

  @override
  State<LogamDetailPage> createState() => _LogamDetailPageState();
}

class _LogamDetailPageState extends State<LogamDetailPage> {
  int? selectedBankIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi Kategori"),
        centerTitle: true,
        backgroundColor: const Color(0xFF00973A),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "LOGAM",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildArtikel(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Divider full width (di luar padding!)
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: const Color(0xFFEEEEEE),
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Pilih Bank Sampah Kami",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildBankSampahItem(
                                index: 0,
                                nama: "Bank Sampah Kawasan 3",
                                alamat:
                                    "Jl. Raya Jonggol-Dayeuh No.19, Sukasirna Kec. Jonggol Kab. Bogor Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),
                              const SizedBox(height: 12),
                              _buildBankSampahItem(
                                index: 1,
                                nama: "Bank Sampah Al Amin",
                                alamat:
                                    "Singajaya, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),
                              const SizedBox(height: 12),
                              _buildBankSampahItem(
                                index: 2,
                                nama: "Bank Sampah Pucal",
                                alamat:
                                    "Kp. Jl. Pojok Salak No.02/08, Jonggol, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),

                              const SizedBox(height: 24),

                              // Tambahkan Padding bottom agar jarak tombol sama dengan KertasDetailPage
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: selectedBankIndex != null
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => FormPage(
                                                  kategoriTerpilih: "Logam",
                                                ),
                                              ),
                                            );
                                          }
                                        : null,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(const Color(0xFF00973A)),
                                      foregroundColor:
                                          MaterialStateProperty.all(Colors.white),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      elevation:
                                          MaterialStateProperty.resolveWith<double>(
                                        (states) =>
                                            states.contains(MaterialState.disabled) ? 0 : 4,
                                      ),
                                      shadowColor: MaterialStateProperty.all(
                                        Colors.grey.withOpacity(0.4),
                                      ),
                                    ),
                                    child: const Text("Donasi Sekarang"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildArtikel() {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: Image.asset(
                  "assets/kategori/logamm.png",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "♻ Sampah Logam yang Bisa Didaur Ulang: Harta Karun dari Barang Bekas!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text(
            "Daur Ulang Logam: Bernilai & Ramah Lingkungan!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Logam yang Bisa Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "1. Aluminium\nContoh: kaleng minuman, foil, tutup botol\nJadi: kaleng baru, rangka sepeda, suku cadang"),
          SizedBox(height: 6),
          Text(
              "2. Besi & Baja\nContoh: kaleng makanan, paku, alat bekas\nJadi: bahan bangunan, pipa, alat rumah tangga"),
          SizedBox(height: 6),
          Text(
              "3. Tembaga\nContoh: kabel, pipa, komponen elektronik\nJadi: kabel & komponen baru"),
          SizedBox(height: 10),
          Text("Yang Sulit Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "● Logam campur plastik/karet\n● Logam kecil banget/berkarat\n● Kaleng cat bekas\n● Bersihkan dulu & hindari campuran bahan lain."),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Tips Menyimpan Sampah Logam",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "• Cuci bersih dari sisa makanan/minuman\n• Lepas label plastik\n• Simpan di tempat kering\n• Kelompokkan jika jumlah banyak"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Manfaat Daur Ulang Logam",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "✅ Hemat sumber daya alam\n✅ Kurangi energi industri\n✅ Kurangi sampah berat & polusi tambang"),
          SizedBox(height: 10),
          Text("Hasil Daur Ulang Logam",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "• Perabot\n• Alat pertanian\n• Kendaraan & sepeda\n• Komponen elektronik\n• Kaleng baru"),
          SizedBox(height: 10),
          Text(
            "Yuk Mulai Pilah Logam dari Sekarang!\nTutup botol kecil pun bisa punya dampak besar untuk bumi!",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ]),
      ],
    );
  }

  Widget _buildCardArtikel({required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildBankSampahItem({
    required int index,
    required String nama,
    required String alamat,
    required String imagePath,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Radio<int>(
            value: index,
            groupValue: selectedBankIndex,
            onChanged: (value) {
              setState(() {
                selectedBankIndex = value;
              });
            },
            activeColor: const Color(0xFF00973A),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: double.infinity,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(alamat, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:trashsmart/widget/form_diri.dart';

class KacaDetailPage extends StatefulWidget {
  const KacaDetailPage({super.key});

  @override
  State<KacaDetailPage> createState() => _KacaDetailPageState();
}

class _KacaDetailPageState extends State<KacaDetailPage> {
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
                              "Kaca",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildArtikel(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildBankSampahItem(
                                index: 0,
                                nama: "Bank Sampah Kaca Cemerlang",
                                alamat:
                                    "Jl. Raya Jonggol-Dayeuh No.19, Sukasirna Kec. jonggol Kab. Bogor Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),
                              const SizedBox(height: 12),
                              _buildBankSampahItem(
                                index: 1,
                                nama: "Bank Sampah Recycle Glass",
                                alamat:
                                    "Singajaya, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),
                              const SizedBox(height: 12),
                              _buildBankSampahItem(
                                index: 2,
                                nama: "Bank Sampah Hijau",
                                alamat:
                                    "kp Jl. Pojok Salak No.02/08, Jonggol, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: selectedBankIndex != null
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const FormPage(
                                                      kategoriTerpilih: 'Kaca'),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(
                                            const Color(0xFF00973A)),
                                    foregroundColor:
                                        MaterialStateProperty.all(
                                            Colors.white),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.resolveWith<double>(
                                      (states) => states.contains(
                                              MaterialState.disabled)
                                          ? 0
                                          : 4,
                                    ),
                                    shadowColor: MaterialStateProperty.all(
                                      Colors.grey.withOpacity(0.4),
                                    ),
                                  ),
                                  child: const Text("Donasi Sekarang"),
                                ),
                              ),
                              const SizedBox(height: 16), // Tambahan jarak bawah tombol
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
            children: const [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: Image(
                  image: AssetImage('assets/kategori/kacaa.png'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "♻ Sampah Kaca: Rapuh Tapi Bernilai Tinggi Jika Didaur Ulang",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Manfaat Daur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("1. Kurangi Pencemaran\n2. Kurangi Sampah di TPA\n3. Hemat Sumber Daya\n4. Hemat Energi\n5. Bantu Ekonomi Sirkular\n6. Kurangi Emisi Karbon"),
          SizedBox(height: 8),
          Text("Yang Bisa Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("• Botol kaca, toples, pecahan kaca"),
          SizedBox(height: 8),
          Text("Yang Sulit Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("• Cermin, oven glass, lampu neon\n⚠ Bungkus pecahan kaca agar aman!"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Cara Mengelola",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Cuci bersih, bungkus, simpan kering\n• Drop-off ke bank sampah kaca"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Manfaatnya",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("✅ Hemat energi hingga 30%\n✅ Kurangi limbah berat\n✅ Bisa didaur ulang terus-menerus"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Hasil Daur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Botol baru, ubin, bahan bangunan\n• Kerajinan seperti mozaik & vas"),
          SizedBox(height: 8),
          Text("Yuk, kelola sampah kaca dengan bijak!"),
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
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
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
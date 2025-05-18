import 'package:flutter/material.dart';
import 'package:trashsmart/widget/form_diri.dart';

class PlastikDetailPage extends StatefulWidget {
  const PlastikDetailPage({super.key});

  @override
  State<PlastikDetailPage> createState() => _PlastikDetailPageState();
}

class _PlastikDetailPageState extends State<PlastikDetailPage> {
  int? selectedBankIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi Kategori"),
        centerTitle: true,
        backgroundColor: const Color(0xFF009B3E),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Plastik",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildArtikel(),
                    const SizedBox(height: 20),
                    const Divider(thickness: 2, color: Colors.grey),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        SizedBox(width: 30),
                        Text(
                          "Pilih Bank Sampah Kami",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildBankSampahItem(
                      index: 0,
                      nama: "Bank Sampah Kawasan",
                      alamat: "Jl. Raya Jonggol-Dayeuh No.19, Sukasirna Kec. Jonggol Kab. Bogor Jawa Barat 16830",
                      imagePath: "assets/images/map.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBankSampahItem(
                      index: 1,
                      nama: "Bank Sampah Al Amin",
                      alamat: "Singajaya, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
                      imagePath: "assets/images/map.png",
                    ),
                    const SizedBox(height: 12),
                    _buildBankSampahItem(
                      index: 2,
                      nama: "Bank Sampah Pucal",
                      alamat: "Kp. Jl. Pojok Salak No.02/08, Jonggol, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
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
                                    builder: (context) => const FormPage(kategoriTerpilih: 'Plastik'),
                                  ),
                                );
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return const Color(0xFF009B3E); // selalu hijau
                            },
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // selalu putih
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 16),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          overlayColor: MaterialStateProperty.all(Colors.white24),
                        ),
                        child: const Text("Donasi Sekarang"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: Image(
                  image: AssetImage('assets/kategori/plastikk.png'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "♻ Sampah Plastik yang Bisa Didaur Ulang:\nKenali & Kelola dengan Bijak!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Kenali Jenis Plastik & Cara Daur Ulangnya!\nPlastik ada di mana-mana—praktis, tapi berdampak bagi lingkungan."),
          SizedBox(height: 8),
          Text("Plastik yang Bisa Didaur Ulang", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("1. PET (botol air, saus) → benang, karpet\n2. HDPE (botol susu, galon) → pipa, wadah\n3. PP (wadah makanan, sedotan) → sapu, alat rumah tangga"),
          SizedBox(height: 8),
          Text("Plastik Sulit Didaur Ulang", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("• PS, PVC, multilapis\n• Kelola lewat bank sampah khusus"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Tips Pilah Plastik", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Cuci & keringkan\n• Pisahkan jenisnya\n• Simpan di tempat khusus\n• Drop di bank sampah"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Sampah Plastikmu Bernilai!", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("✅ Kurangi limbah TPA\n✅ Jaga laut & bumi\n✅ Dukung ekonomi sirkular\nYuk, mulai dari rumah!"),
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
                          Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
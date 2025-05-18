import 'package:flutter/material.dart';
import 'package:trashsmart/widget/form_diri.dart';

class OrganikDetailPage extends StatefulWidget {
  const OrganikDetailPage({super.key});

  @override
  State<OrganikDetailPage> createState() => _OrganikDetailPageState();
}

class _OrganikDetailPageState extends State<OrganikDetailPage> {
  int? selectedBankIndex;

  final List<Map<String, String>> bankSampahList = [
    {
      'nama': 'Bank Sampah Kowasa',
      'alamat': 'Jl. Raya Jonggol-Dayeuh No.19, Sukasirna Kec. Jonggol Kab. Bogor Jawa Barat 16830',
      'gambar': 'assets/images/map.png',
    },
    {
      'nama': 'Bank Sampah Al Amin',
      'alamat': 'Singajaya, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830',
      'gambar': 'assets/images/map.png',
    },
    {
      'nama': 'Bank Sampah Posal',
      'alamat': 'Kp Jl. Pojok Salah No.02/08, Jonggol, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830',
      'gambar': 'assets/images/map.png',
    },
  ];

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
                              "Organik",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildArtikel(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Divider full width (di luar padding)
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
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...bankSampahList.asMap().entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildBankSampahItem(
                                    index: entry.key,
                                    nama: entry.value['nama']!,
                                    alamat: entry.value['alamat']!,
                                    imagePath: entry.value['gambar']!,
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 24),

                              // Tombol dengan jarak bawah
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: selectedBankIndex != null
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const FormPage(kategoriTerpilih: 'Organik'),
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF00973A)),
                                    foregroundColor: MaterialStateProperty.all(Colors.white),
                                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    elevation: MaterialStateProperty.resolveWith<double>(
                                      (states) => states.contains(MaterialState.disabled) ? 0 : 4,
                                    ),
                                    shadowColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.4)),
                                  ),
                                  child: const Text("Donasi Sekarang"),
                                ),
                              ),
                              const SizedBox(height: 16),  // <-- jarak bawah tombol
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: Image(
                  image: AssetImage( 'assets/kategori/organikk.png'),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "♻ Sampah Organik: Dari Limbah Jadi Berkah untuk Bumi!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(const Text(
          "Daur Ulang Sampah Organik: Mudah & Bermanfaat!\n\n"
          "Yang Bisa Diolah\n"
          "• Sisa Makanan: nasi, sayur, buah, kulit telur, ampas kopi/teh\n"
          "• Daun & Ranting Kering: dari taman atau halaman\n"
          "• Kulit Buah & Sayur: pisang, semangka, wortel\n"
          "• Sisa Dapur Mentah: bumbu, sayur mentah, daging mentah tanpa minyak\n\n"
          "Yang Perlu Dihindari\n"
          "• Makanan berminyak, bersantan, berlemak\n"
          "• Tinja hewan\n"
          "• Daging matang\n"
          "• Kertas berminyak\n"
          "⚠ Jangan campur dengan plastik atau bahan kimia!\n\n"
          "Cara Mengelola di Rumah\n"
          "1. Pisahkan dari sampah lain\n"
          "2. Simpan di wadah tertutup\n"
          "3. Campur dengan tanah & daun kering\n"
          "4. Aduk rutin, beri lubang udara\n"
          "5. Tunggu 1-2 bulan → jadi kompos!\n"
          "(Gunakan EM4 agar lebih cepat)",
          style: TextStyle(fontSize: 15),
        )),
        const SizedBox(height: 12),
        _buildCardArtikel(const Text(
          "Manfaatnya ✅\n"
          "✅ Kurangi sampah TPA\n"
          "✅ Buat pupuk alami\n"
          "✅ Kurangi gas metana\n"
          "✅ Dukung gaya hidup hijau",
          style: TextStyle(fontSize: 15),
        )),
        const SizedBox(height: 12),
        _buildCardArtikel(const Text(
          "Ide Kreatif 💡\n"
          "• Kompos padat\n"
          "• Pupuk cair dari kulit buah\n"
          "• Pot tanaman dari kulit jeruk\n"
          "• Eco-enzyme dari limbah buah\n\n"
          "Ayo Mulai Sekarang!\n"
          "Sisa makananmu bisa jadi makanan untuk tanaman. Bumi lebih sehat, kita pun ikut bahagia!",
          style: TextStyle(fontSize: 15),
        )),
      ],
    );
  }

  Widget _buildCardArtikel(Widget child) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: child,
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
import 'package:flutter/material.dart';
import 'package:trashsmart/widget/form_diri.dart';

class TekstilDetailPage extends StatefulWidget {
  const TekstilDetailPage({super.key});

  @override
  State<TekstilDetailPage> createState() => _TekstilDetailPageState();
}

class _TekstilDetailPageState extends State<TekstilDetailPage> {
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
                              "Tekstil",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildArtikel(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Divider
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
                                nama: "Bank Sampah Kowasa",
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
                                nama: "Bank Sampah Posal",
                                alamat:
                                    "Kp. Jl. Pojok Salak No.02/08, Jonggol, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),
                              const SizedBox(height: 24),

                              // Tombol Donasi Sekarang
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
                                                      kategoriTerpilih:
                                                          'Tekstil'),
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
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>(
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

                              // Tambahan jarak bawah tombol supaya tidak mentok
                              const SizedBox(height: 16),
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
                  image: AssetImage('assets/kategori/tekstill.png'),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "♻ Sampah Tekstil: Ubah Baju Lama Jadi Peluang Baru!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text(
            "Daur Ulang Sampah Tekstil: Hemat & Kreatif!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Yang Bisa Didaur Ulang:"),
          Text("• Pakaian layak pakai\n• Kain perca\n• Seprai/gorden\n• Pakaian rusak"),
          SizedBox(height: 8),
          Text("Yang Sulit Didaur Ulang:"),
          Text("• Terkontaminasi bahan kimia\n• Berjamur\n• Campur logam/plastik"),
          SizedBox(height: 8),
          Text("⚠ Lepas kancing & resleting sebelum didaur ulang!"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Cara Mengelola di Rumah",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
              "1. Pisahkan yang masih bagus\n2. Yang rusak → ke bank sampah\n3. Potong jadi lap\n4. Simpan dalam kondisi bersih"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Manfaatnya ✅", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
              "✅ Kurangi sampah TPA\n✅ Hemat bahan baku\n✅ Kurangi polusi air\n✅ Buka peluang usaha kreatif"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Ide Kreatif 💡", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Patchwork unik\n• Keset & bantal\n• Boneka dari kain\n• Kain lap dari handuk rusak"),
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
                          Text(alamat,
                              style: const TextStyle(fontSize: 12)),
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
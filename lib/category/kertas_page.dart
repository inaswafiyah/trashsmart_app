import 'package:flutter/material.dart';
import 'package:trashsmart/widget/form_diri.dart';

class KertasDetailPage extends StatefulWidget {
  const KertasDetailPage({super.key});

  @override
  State<KertasDetailPage> createState() => _KertasDetailPageState();
}

class _KertasDetailPageState extends State<KertasDetailPage> {
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
                              "KERTAS",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildBankSampahItem(
                                index: 0,
                                nama: "Bank Sampah Kawasan 3",
                                alamat:
                                    "Jl. Raya Jonggol-Dayeuh No.19, Sukasirna Kec. jonggol Kab. Bogor Jawa Barat 16830",
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
                                    "kp Jl. Pojok Salak No.02/08, Jonggol, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830",
                                imagePath: "assets/images/map.png",
                              ),
                              const SizedBox(height: 24),

                              // Padding bottom agar tombol "melayang"
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
                                                builder: (context) =>
                                                    const FormPage(
                                                        kategoriTerpilih: 'Kertas'),
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
                                      elevation: MaterialStateProperty.resolveWith<double>(
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
        _buildCard(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                   "assets/kategori/kertass.png",
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "♻ Sampah Kertas yang Bisa Didaur Ulang: Lebih dari Sekadar Lembaran Usang!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCard(const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Daur Ulang Kertas: Mudah & Berdampak!",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Kertas yang Bisa Didaur Ulang",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("• HVS / Kertas Kantor\n• Koran\n• Majalah & Buku\n• Karton Tipis"),
            SizedBox(height: 10),
            Text("Yang Tidak Bisa Didaur Ulang",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("• Kertas berminyak\n• Tisu bekas\n• Kertas laminasi\n• Kertas karbon"),
          ],
        )),
        const SizedBox(height: 12),
        _buildCard(const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cara Simpan Kertas Daur Ulang",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("• Pisahkan jenisnya\n• Jangan diremas\n• Simpan di tempat kering"),
          ],
        )),
        const SizedBox(height: 12),
        _buildCard(const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Manfaatnya:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("✅ Kurangi penebangan pohon\n✅ Hemat energi & air\n✅ Kurangi sampah TPA"),
            SizedBox(height: 10),
            Text("Hasil Daur Ulang:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("• Buku tulis\n• Tas & kotak kemasan\n• Tisu daur ulang"),
            SizedBox(height: 10),
            Text(
              "Yuk, mulai dari rumah! Satu lembar kertas = satu langkah untuk bumi lebih hijau.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildCard(Widget child) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
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
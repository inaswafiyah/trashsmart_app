import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_state.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_event.dart';
import 'package:trashsmart/data/datasource/bank_remote_datasource.dart';
import 'package:trashsmart/widget/form_diri.dart';

class OrganikDetailPage extends StatefulWidget {
  const OrganikDetailPage({super.key});

  @override
  State<OrganikDetailPage> createState() => _OrganikDetailPageState();
}

class _OrganikDetailPageState extends State<OrganikDetailPage> {
  int? selectedBankIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BankBloc(BankRemoteDataSource())..add(LoadBankSampah()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Informasi Kategori",
            style: TextStyle(fontSize: 18),
          ),
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
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                BlocBuilder<BankBloc, BankState>(
                                  builder: (context, state) {
                                    if (state.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (state.errorMessage != null) {
                                      return Center(
                                        child: Text(
                                          'Error: ${state.errorMessage}',
                                        ),
                                      );
                                    }
                                    final bankList = state.bankList;
                                    if (bankList.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'Belum ada data bank sampah.',
                                        ),
                                      );
                                    }
                                    return Column(
                                      children: [
                                        ...List.generate(bankList.length, (
                                          index,
                                        ) {
                                          final bank = bankList[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: _buildBankSampahItem(
                                              index: index,
                                              nama: bank.bankSampahNama ?? '-',
                                              alamat:
                                                  bank.bankSampahAlamat ?? '-',
                                              imagePath:
                                                  "assets/images/map.png",
                                            ),
                                          );
                                        }),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed:
                                                selectedBankIndex != null
                                                    ? () {
                                                      final selectedBank =
                                                          bankList[selectedBankIndex!];
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => FormPage(
                                                                kategoriTerpilih:
                                                                    'Organik',
                                                                bankSampahNama:
                                                                    selectedBank
                                                                        .bankSampahNama ??
                                                                    '-',
                                                                bankSampahAlamat:
                                                                    selectedBank
                                                                        .bankSampahAlamat ??
                                                                    '-',
                                                              ),
                                                        ),
                                                      );
                                                    }
                                                    : null,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                    const Color(0xFF00973A),
                                                  ),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                    Colors.white,
                                                  ),
                                              padding:
                                                  MaterialStateProperty.all(
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                  ),
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              elevation:
                                                  MaterialStateProperty.resolveWith<
                                                    double
                                                  >(
                                                    (states) =>
                                                        states.contains(
                                                              MaterialState
                                                                  .disabled,
                                                            )
                                                            ? 0
                                                            : 4,
                                                  ),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                    Colors.grey.withOpacity(
                                                      0.4,
                                                    ),
                                                  ),
                                            ),
                                            child: const Text("Tukar Sekarang"),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    );
                                  },
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
      ),
    );
  }

  Widget _buildArtikel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image(
                  image: AssetImage('assets/kategori/organikk.png'),
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "♻️ Sampah Organik: Dari Limbah Jadi Berkah untuk Bumi!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daur Ulang Sampah Organik: Mudah & Bermanfaat!",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 8),
              Text(
                "Yang Bisa Diolah",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                "• Sisa Makanan: nasi, sayur, buah, kulit\n  telur, ampas kopi/teh",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "• Daun & Ranting Kering: dari taman\n  atau halaman",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "• Kulit Buah & Sayur: pisang, semangka,\n  wortel",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "• Sisa Dapur Mentah: bumbu, sayur\n  mentah, daging mentah tanpa minyak",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 8),
              Text(
                "Semua bisa jadi kompos atau pupuk cair!",
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Yang Perlu Dihindari",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                "• Makanan berminyak, bersantan,\n  berlemak",
                style: TextStyle(fontSize: 13),
              ),
              Text("• Tinja hewan", style: TextStyle(fontSize: 13)),
              Text("• Daging matang", style: TextStyle(fontSize: 13)),
              Text("• Kertas berminyak", style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cara Mengelola di Rumah",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                "• Pisahkan dari sampah lain",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "• Simpan di wadah tertutup",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "• Campur dengan tanah & daun kering",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "• Aduk rutin, beri lubang udara",
                style: TextStyle(fontSize: 13),
              ),
              Text(
                "• Tunggu 1–2 bulan → jadi kompos!\n  (Gunakan EM4 agar lebih cepat.)",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 12),
              Text(
                "Kalau tidak bisa mengelola di rumah,\nkamu bisa drop off sampah organikmu di Bank sampah terdekat.",
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCardArtikel(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bumi lebih sehat, kantong lebih tebal!",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                "Sampah organikmu mulai dari\nRp500/kg.",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 8),
              Text(
                "Yuk, Tukarkan Sekarang!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
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
                      errorBuilder:
                          (context, error, stackTrace) => Container(
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
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
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

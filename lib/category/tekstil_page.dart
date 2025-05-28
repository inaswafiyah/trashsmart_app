import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_state.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_event.dart';
import 'package:trashsmart/data/datasource/bank_remote_datasource.dart';
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
    return BlocProvider(
      create: (_) => BankBloc(BankRemoteDataSource())..add(LoadBankSampah()),
      child: Scaffold(
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
                                BlocBuilder<BankBloc, BankState>(
                                  builder: (context, state) {
                                    if (state.isLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (state.errorMessage != null) {
                                      return Center(
                                          child: Text('Error: ${state.errorMessage}'));
                                    }
                                    final bankList = state.bankList;
                                    if (bankList.isEmpty) {
                                      return const Center(
                                          child: Text('Belum ada data bank sampah.'));
                                    }
                                    return Column(
                                      children: [
                                        ...List.generate(bankList.length, (index) {
                                          final bank = bankList[index];
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 12),
                                            child: _buildBankSampahItem(
                                              index: index,
                                              nama: bank.bankSampahNama ?? '-',
                                              alamat: bank.bankSampahAlamat ?? '-',
                                              imagePath: "assets/images/map.png",
                                            ),
                                          );
                                        }),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: selectedBankIndex != null
                                                ? () {
                                                    final selectedBank = bankList[selectedBankIndex!];
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => FormPage(
                                                          kategoriTerpilih: 'Tekstil',
                                                          bankSampahNama: selectedBank.bankSampahNama ?? '-',
                                                          bankSampahAlamat: selectedBank.bankSampahAlamat ?? '-',
                                                        ),
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
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  "♻️ Sampah Tekstil: Ubah Baju Lama Jadi Peluang Baru!",
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
          ),
          SizedBox(height: 8),
          Text("Yang Bisa Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold),),
          Text("• Pakaian layak pakai: bisa didonasi,\n  dijual,atau diubah jadi produk baru"),
          Text("• Kain perca: cocok untuk kerajinan (tas,\n  boneka, dompet)"),
          Text("• Seprai, handuk, gorden lama: bisa jadi\n  keset, lap pel"),
          Text("• Pakaian rusak: bisa jadi isi bantal,\n  bahan isolasi, atau bangunan"),
          SizedBox(height: 8),
          Text("Yang Sulit Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("• Terkena bahan kimia"),
          Text("• Sangat kotor atau berjamur"),
          Text("• Campur logam/plastik yang sulit\n  dipisah"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Cara Mengelola:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("• Pisahkan yang masih bagus\n  → donasi/preloved"),
          Text("• Yang rusak → drop-off ke bank\n  sampah"),
          Text("• Potong jadi lap, isian boneka, dll"),
          Text("• Simpan dalam kondisi bersih & kering"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Satu kilo tekstil = Rp2.500! Yuk, bersihkan lemari sambil bantu lingkungan.",
            ),
          SizedBox(height: 8),
          Text("Yuk, Tukarkan Sekarang!",
              style: TextStyle(fontWeight: FontWeight.bold)),
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
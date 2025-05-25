import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_state.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_event.dart';
import 'package:trashsmart/data/datasource/bank_remote_datasource.dart';
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
                                BlocBuilder<BankBloc, BankState>(
                                  builder: (context, state) {
                                    if (state.isLoading) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if (state.errorMessage != null) {
                                      return Center(child: Text('Error: ${state.errorMessage}'));
                                    }
                                    final bankList = state.bankList;
                                    if (bankList.isEmpty) {
                                      return const Center(child: Text('Belum ada data bank sampah.'));
                                    }
                                    return Column(
                                      children: [
                                        ...List.generate(bankList.length, (index) {
                                          final bank = bankList[index];
                                          return Column(
                                            children: [
                                              _buildBankSampahItem(
                                                index: index,
                                                nama: bank.bankSampahNama ?? '-',
                                                alamat: bank.bankSampahAlamat ?? '-',
                                                imagePath: "assets/images/map.png",
                                              ),
                                              const SizedBox(height: 12),
                                            ],
                                          );
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 24),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: selectedBankIndex != null
                                                  ? () {
                                                      final selectedBank = bankList[selectedBankIndex!];
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => FormPage(
                                                            kategoriTerpilih: "Logam",
                                                            bankSampahNama: selectedBank.bankSampahNama ?? '-',
                                                            bankSampahAlamat: selectedBank.bankSampahAlamat ?? '-',
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
                                              child: const Text("Tukar Sekarang"),
                                            ),
                                          ),
                                        ),
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
                  "♻️ Sampah Logam yang Bisa Didaur Ulang: Harta Karun dari Barang Bekas!",
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
          ),
          SizedBox(height: 5),
          Text("Logam yang Bisa Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Text(
              "1. Aluminium\n    Contoh: kaleng minuman, foil, tutup\n    botol Jadi: kaleng baru, rangka\n    sepeda, suku cadang"),
          SizedBox(height: 6),
          Text(
              "2. Besi & Baja\n    Contoh: kaleng makanan, paku, alat\n    bekas Jadi: bahan bangunan, pipa,\n    alat rumah tangga"),
          SizedBox(height: 6),
          Text(
              "3. Tembaga\n    Contoh: kabel, pipa, komponen\n    elektronik Jadi: kabel & komponen\n   baru"),
          SizedBox(height: 10),
          Text("Yang Sulit Didaur Ulang",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "• Logam campur plastik/karet\n• Logam kecil banget/berkarat\n• Kaleng cat bekas (mengandung bahan\n  kimia)"),
          SizedBox(height: 10),
          Text(
              "⚠ Bersihkan dulu dan hindari campuran bahan lain."),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Tips Menyimpan Sampah Logam",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              "• Cuci bersih dari sisa makanan/\n  minuman\n• Lepas label plastik\n• Simpan di tempat kering\n• Kelompokkan jika jumlah banyak"),
        ]),
        const SizedBox(height: 12),
        _buildCardArtikel(children: const [
          Text("Logammu Bernilai Tinggi! Mulai dari Rp5.000/kg — donasikan dan raih manfaatnya!"),
          SizedBox(height: 10),
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
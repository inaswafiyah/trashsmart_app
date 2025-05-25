import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trashsmart/data/datasource/bank_remote_datasource.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_bloc.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_state.dart';
import 'package:trashsmart/presentation/auth/bloc/bank/bank_event.dart';
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
                                                            kategoriTerpilih: 'Kertas',
                                                            bankSampahNama: selectedBank.bankSampahNama ?? '-',
                                                            bankSampahAlamat: selectedBank.bankSampahAlamat ?? '-',
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  : null,
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(const Color(0xFF00973A)),
                                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                                padding: MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(vertical: 16),
                                                ),
                                                shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                elevation: MaterialStateProperty.resolveWith<double>(
                                                  (states) => states.contains(MaterialState.disabled) ? 0 : 4,
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
                "♻️ Sampah Kertas yang Bisa Didaur Ulang: Lebih dari Sekadar Lembaran Usang!",
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
            SizedBox(height: 5),
            Text("Kertas yang Bisa Didaur Ulang",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("• HVS / Kertas Kantor\n  Lepas penjepit & plastik\n• Koran\n  Jadi kertas daur ulang, pembungkus\n• Majalah & Buku\n  Donasi jika layak, daur ulang jika rusak\n  (asal tidak dilaminasi)\n• Karton Tipis\n  Contoh: kotak sereal, kemasan pasta\n  gigi"),
            SizedBox(height: 12),
            Text("Yang Tidak Bisa Didaur Ulang",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("• Kertas berminyak (nasi bungkus, pizza\n  box)\n• Tisu bekas\n• Kertas laminasi\n• Kertas karbon"),
            SizedBox(height: 8),
            Text("⚠ Jangan daur ulang kertas kotor atau lembab bisa merusak proses!"),
          ],
        )),
        const SizedBox(height: 12),
        _buildCard(const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cara Simpan Kertas Daur Ulang",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("• Pisahkan jenisnya\n• Jangan dilipat/robek terlalu kecil\n• Simpan di tempat kering\n• Jangan campur sampah basah"),
          ],
        )),
        const SizedBox(height: 12),
        _buildCard(const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jangan buang kertas sembarangan! Tukar mulai Rp1.500/kg dan bantu bumi!"),
            SizedBox(height: 10),
            Text("Yuk, Tukarkan Sekarang!", style: TextStyle(fontWeight: FontWeight.bold)),          
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
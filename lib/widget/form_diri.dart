import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trashsmart/data/datasource/auth_local_datasource.dart';
import 'package:trashsmart/message/popup_form.dart';
import 'package:trashsmart/core/constants/variable.dart';
import 'package:trashsmart/message/resi_form.dart';

class FormPage extends StatefulWidget {
  final String kategoriTerpilih;
  final String bankSampahNama;
  final String bankSampahAlamat;

  const FormPage({
    super.key,
    required this.kategoriTerpilih,
    required this.bankSampahNama,
    required this.bankSampahAlamat,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController trashAmountController = TextEditingController();

  final List<String> categories = [
    "Plastik",
    "Kertas",
    "Logam",
    "Tekstil",
    "Kaca",
    "Jelantah",
    "Organik",
  ];

  Set<String> selectedCategories = {};

  final Color primaryColor = const Color(0xFF00973A);

  final AuthLocalDatasource authLocalDatasource = AuthLocalDatasource();

  late final String? lockedCategory;

  Map<String, int> kategoriHarga = {};

  BuildContext? dialogContext;

  @override
  void initState() {
    super.initState();
    lockedCategory =
        widget.kategoriTerpilih.isNotEmpty ? widget.kategoriTerpilih : null;
    if (lockedCategory != null) {
      selectedCategories.add(lockedCategory!);
    }
    fetchKategoriHarga();
  }

  Future<void> fetchKategoriHarga() async {
    final authData = await authLocalDatasource.getAuthData();
    final token = authData.token ?? '';
    print('TOKEN YANG DIKIRIM: $token');

    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/api/api-categories'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        print('DATA API: $data');
        for (var item in data['data']) {
          print('Kategori: ${item['name']} - Harga: ${item['price']}');
          kategoriHarga[item['name']] = item['price'];
        }
        setState(() {});
      } catch (e) {
        print('Gagal decode JSON: $e');
        print('Body: ${response.body}');
      }
    } else {
      print('Status bukan 200: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  }

  bool get isFormComplete =>
      nameController.text.isNotEmpty &&
      phoneController.text.isNotEmpty &&
      trashAmountController.text.isNotEmpty &&
      selectedCategories.where((c) => c.isNotEmpty).isNotEmpty;

  Future<void> submitForm() async {
    final filteredCategories =
        selectedCategories.where((c) => c.isNotEmpty).toList();

    if (filteredCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori harus dipilih minimal satu')),
      );
      return;
    }

    final jumlahSampahText = trashAmountController.text.trim();

    if (jumlahSampahText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah Sampah harus diisi')),
      );
      return;
    }

    try {
      final authData = await authLocalDatasource.getAuthData();
      final token = authData.token ?? '';
      final baseUrl = Variable.baseUrl;

      if (token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token tidak ditemukan, silakan login ulang'),
          ),
        );
        return;
      }

      final url = Uri.parse('$baseUrl/api/api-trashsmart');

      final body = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "jumlah_sampah": jumlahSampahText,
        "category": filteredCategories,
        "bank_sampah_nama": widget.bankSampahNama,
        "bank_sampah_alamat": widget.bankSampahAlamat,
      };

      print(jsonEncode(body));

      showCustomLoading(context);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }

      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => ResiPenyerahanPage(
                  nama: nameController.text.trim(),
                  noTelepon: phoneController.text.trim(),
                  tanggalDropOff: DateTime.now().toString().substring(0, 10),
                  jenisSampah: selectedCategories.join(', '),
                  bankSampahNama: widget.bankSampahNama,
                  bankSampahAlamat: widget.bankSampahAlamat,
                  kategoriHarga: kategoriHarga,
                  kategoriTerpilih: selectedCategories.toList(),
                ),
          ),
        );
      } else {
        try {
          final resBody = jsonDecode(response.body);
          final message = resBody['message'] ?? 'Terjadi kesalahan saat submit';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim data: $message')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Gagal mengirim data: respons tidak valid\nStatus: ${response.statusCode}\n${response.body}',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi error: $e')));
    }
  }

  void showCustomLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return Center(
          child: SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 7,
              color: Color(0xE500973A),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Form Data Diri",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Jenis Sampah yang diterima",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            buildTextField("Nama", nameController),
            buildTextField(
              "No Telephone",
              phoneController,
              keyboardType: TextInputType.phone,
            ),
            buildTextField(
              "Jumlah Sampah",
              trashAmountController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            const Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(children: _buildCategoryRows()),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isFormComplete ? () => submitForm() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isFormComplete
                        ? primaryColor
                        : Colors.grey.shade400.withOpacity(0.5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Selesai",
                style: TextStyle(
                  color:
                      isFormComplete
                          ? Colors.white
                          : const Color.fromARGB(255, 85, 84, 84),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryRows() {
    List<Widget> rows = [];

    for (int i = 0; i < categories.length; i += 3) {
      List<Widget> rowItems = [];

      for (int j = i; j < i + 3 && j < categories.length; j++) {
        final isLocked =
            lockedCategory != null && categories[j] == lockedCategory;
        final isDisabled =
            lockedCategory != null && categories[j] != lockedCategory;
        final isChecked = selectedCategories.contains(categories[j]);

        rowItems.add(
          Expanded(
            child: GestureDetector(
              onTap:
                  isDisabled
                      ? null
                      : () {
                        setState(() {
                          if (lockedCategory == null) {
                            if (isChecked) {
                              selectedCategories.remove(categories[j]);
                            } else {
                              selectedCategories.add(categories[j]);
                            }
                          } else {
                            selectedCategories.clear();
                            selectedCategories.add(categories[j]);
                          }
                        });
                      },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isChecked ? Color(0xFF0A7C36) : Color(0xFFF5F5F5),
                      border: Border.all(color: Color(0xFFAEA9B1), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        isChecked
                            ? Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      categories[j],
                      overflow: TextOverflow.visible,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      while (rowItems.length < 3) {
        rowItems.add(const Expanded(child: SizedBox()));
      }

      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(children: rowItems),
        ),
      );
    }

    return rows;
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    final bool isFilled = controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Masukan ${label.toLowerCase()}",
            hintStyle: const TextStyle(
              color: Color(0xFF757575),
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: isFilled ? Colors.white : Colors.grey.shade300,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder:
                isFilled
                    ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                    )
                    : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 2),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

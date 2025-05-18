import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final String kategoriTerpilih;

  const FormPage({super.key, required this.kategoriTerpilih});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final List<String> categories = [
    "Plastik",
    "Kertas",
    "Logam",
    "Tekstil",
    "Kaca",
    "Jelantah",
    "Organik"
  ];
  final Set<String> selectedCategories = {};

  final Color primaryColor = const Color(0xFF0F7A32);

  @override
  void initState() {
    super.initState();
    // Automatically select the category passed from the previous page
    selectedCategories.add(widget.kategoriTerpilih);
  }

  bool get isFormComplete =>
      nameController.text.isNotEmpty &&
      phoneController.text.isNotEmpty &&
      addressController.text.isNotEmpty &&
      selectedCategories.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Form Data Diri"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text("Jenis Sampah yang diterima", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            buildTextField("Nama", nameController),
            buildTextField("No Telephone", phoneController, keyboardType: TextInputType.phone),
            buildTextField("Alamat", addressController),
            const SizedBox(height: 16),
            const Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(children: _buildCategoryRows()),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isFormComplete ? _submitForm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isFormComplete
                    ? primaryColor
                    : Colors.grey.shade400.withOpacity(0.5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Selesai", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  // Submit form
  void _submitForm() {
    // Here you would handle the form submission (e.g., save data or send to API)
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Form Submitted"),
          content: Text("Nama: ${nameController.text}\n"
              "Telephone: ${phoneController.text}\n"
              "Alamat: ${addressController.text}\n"
              "Kategori: ${selectedCategories.join(', ')}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to previous page after submission
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Build category checkboxes
  List<Widget> _buildCategoryRows() {
    List<Widget> rows = [];

    for (int i = 0; i < categories.length; i += 3) {
      List<Widget> rowItems = [];

      for (int j = i; j < i + 3 && j < categories.length; j++) {
        rowItems.add(
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: selectedCategories.contains(categories[j]),
                    activeColor: primaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedCategories.add(categories[j]);
                        } else {
                          selectedCategories.remove(categories[j]);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    categories[j],
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
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

  // Build individual text fields
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: "Masukan ${label.toLowerCase()}",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

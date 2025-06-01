import 'package:flutter/material.dart';

class ReusableCategoryDetailPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final List<Widget> content;

  const ReusableCategoryDetailPage({
    required this.title,
    required this.imagePath,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel Kategori"),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(imagePath),
                ),
                const SizedBox(height: 16),
                ...content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

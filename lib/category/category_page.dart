import 'package:flutter/material.dart';
import 'package:trashsmart/category/jelantah_page.dart';
import 'package:trashsmart/category/kaca_page.dart';
import 'package:trashsmart/category/kertas_page.dart';
import 'package:trashsmart/category/logam_page.dart';
import 'package:trashsmart/category/organik_page.dart';
import 'package:trashsmart/category/plastik_page.dart';
import 'package:trashsmart/category/tekstil_page.dart';

class CategoryPage extends StatelessWidget {
  final String label;

  const CategoryPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    switch (label) {
      case 'Plastik':
        return const PlastikDetailPage();
      case 'Kertas':
        return const KertasDetailPage();
      case 'Logam':
        return const LogamDetailPage();
      case 'Organik':
        return const OrganikDetailPage();
      case 'Tekstil':
        return const TekstilDetailPage();
      case 'Kaca':
        return const KacaDetailPage();
      case 'Jelantah':
        return const JelantahDetailPage();
    }

    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text("Ini halaman untuk kategori: $label")),
    );
  }
}
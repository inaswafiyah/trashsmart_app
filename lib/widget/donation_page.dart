import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trashsmart/maps/kowasa_map.dart';
import 'package:trashsmart/widget/form_diri.dart';

class DonasiPage1 extends StatefulWidget {
  const DonasiPage1({super.key});

  @override
  State<DonasiPage1> createState() => _DonasiPage1State();
}

class _DonasiPage1State extends State<DonasiPage1> {
  String? kategoriTerpilih;

  void _pilihKategori(String kategori) {
    setState(() {
      kategoriTerpilih = kategori;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Donasi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF00973A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(-6.5036956, 107.0473927),
                  initialZoom: 17.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(-6.5036956, 107.0473927),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bank Sampah Kowasa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jl. Raya Jonggol-Dayeuh No.19, Sukasirna Kec. jonggol Kab. Bogor Jawa Barat 16830',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 110,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KowasaPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00973A),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        elevation: 2,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      child: const Text(
                        'Lihat Maps',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1.5, color: Colors.black12),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Jenis Sampah yang diterima',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSampahItem('plastik', 'Plastik'),
                  _buildSampahItem('kertas', 'Kertas'),
                  _buildSampahItem('logam', 'Logam'),
                  _buildSampahItem('organik', 'Organik'),
                  _buildSampahItem('tekstil', 'Tekstil'),
                  _buildSampahItem('kaca', 'Kaca'),
                  _buildSampahItem('jelantah', 'Jelantah'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FormPage(
                              kategoriTerpilih: kategoriTerpilih ?? '',
                              bankSampahNama: 'Bank Sampah Kowasa',
                              bankSampahAlamat: 'Jl. Raya Jonggol-Dayeuh No.19, Sukasirna Kec. jonggol Kab. Bogor Jawa Barat 16830',
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00973A),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Donasi Sekarang',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSampahItem(String iconName, String label) {
    final bool selected = kategoriTerpilih == label;
    return GestureDetector(
      onTap: () => _pilihKategori(label),
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFF00973A) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/$iconName.png',
                  color: selected ? Colors.white : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

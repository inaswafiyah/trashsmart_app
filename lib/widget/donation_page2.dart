import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trashsmart/maps/al_amin_map.dart';
import 'package:trashsmart/widget/form_diri.dart';

class DonasiPage2 extends StatelessWidget {
  final String? kategoriTerpilih;

  const DonasiPage2({super.key, this.kategoriTerpilih});

  @override
  Widget build(BuildContext context) {
    // Daftar semua kategori sampah
    final List<Map<String, String>> semuaKategori = [
      {'icon': 'plastik', 'label': 'Plastik'},
      {'icon': 'kertas', 'label': 'Kertas'},
      {'icon': 'logam', 'label': 'Logam'},
      {'icon': 'organik', 'label': 'Organik'},
      {'icon': 'tekstil', 'label': 'Tekstil'},
      {'icon': 'kaca', 'label': 'Kaca'},
      {'icon': 'jelantah', 'label': 'Jelantah'},
    ];

    // Menampilkan kategori sesuai dengan kategori yang dipilih atau semua kategori
    final List<Map<String, String>> kategoriDitampilkan =
        kategoriTerpilih == null
            ? semuaKategori
            : semuaKategori
                .where(
                  (item) =>
                      item['label']!.toLowerCase() ==
                      kategoriTerpilih!.toLowerCase(),
                )
                .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Donasi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF009B3E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(-6.4561302, 107.0368269),
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    enableMultiFingerGestureRace: true,
                  ),
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
                        point: LatLng(-6.4561302, 107.0368269),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 36,
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
                    'Bank Sampah Al Amin',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Singajaya, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830',
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
                            builder: (context) => const AlAminMapPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009B3E),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Jenis Sampah yang diterima',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children:
                    kategoriDitampilkan.map((item) {
                      return SampahItem(
                        iconName: item['icon']!,
                        label: item['label']!,
                      );
                    }).toList(),
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
                            ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFF009B3E),
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
}

class SampahItem extends StatelessWidget {
  final String iconName;
  final String label;

  const SampahItem({super.key, required this.iconName, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('assets/images/$iconName.png'),
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

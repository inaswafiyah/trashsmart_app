import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trashsmart/maps/posal_map.dart';
import 'package:trashsmart/widget/form_diri.dart';
import 'package:url_launcher/url_launcher.dart';

class DonasiPage3 extends StatefulWidget {
  final String bankSampahNama;
  final String bankSampahAlamat;
  final String mapsUrl;
  const DonasiPage3({
    super.key,
    required this.bankSampahNama,
    required this.bankSampahAlamat,
    required this.mapsUrl,
  });

  @override
  _DonasiPage3State createState() => _DonasiPage3State();
}

class _DonasiPage3State extends State<DonasiPage3> {
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
        backgroundColor: const Color(0xFF009B3E),
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
                  initialCenter: LatLng(-6.200000, 106.816666), // gunakan data dinamis
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
                        point: LatLng(-6.200000, 106.816666), // gunakan data dinamis
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
                  Text(
                    widget.bankSampahNama,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.bankSampahAlamat,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 130, // Lebar sesuai gambar, bisa diubah 120-140 sesuai selera
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = widget.mapsUrl;
                        if (url.isNotEmpty && await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        minimumSize: const Size(0, 40), // tinggi 40, lebar mengikuti SizedBox
                        padding: EdgeInsets.zero, // padding nol agar tidak melebar
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text(
                        'Lihat Maps',
                        style: TextStyle(
                          color: Colors.black, // text hitam
                          fontWeight: FontWeight.w600,
                        ),
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
                  _buildSampahDisplay('plastik', 'Plastik'),
                  _buildSampahDisplay('kertas', 'Kertas'),
                  _buildSampahDisplay('logam', 'Logam'),
                  _buildSampahDisplay('organik', 'Organik'),
                  _buildSampahDisplay('tekstil', 'Tekstil'),
                  _buildSampahDisplay('kaca', 'Kaca'),
                  _buildSampahDisplay('jelantah', 'Jelantah'),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                        builder: (context) => FormPage(
                          kategoriTerpilih: '',
                          bankSampahNama: widget.bankSampahNama,
                          bankSampahAlamat: widget.bankSampahAlamat,
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

  // Fungsi untuk menampilkan jenis sampah
  Widget _buildSampahDisplay(String iconName, String label) {
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

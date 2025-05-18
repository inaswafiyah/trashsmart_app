import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class AlAminMapPage extends StatefulWidget {
  const AlAminMapPage({super.key});

  @override
  State<AlAminMapPage> createState() => _AlAminMapPageState();
}

class _AlAminMapPageState extends State<AlAminMapPage> {
  final LatLng lokasiBankSampah = LatLng(-6.4561302, 107.0368269);
  LatLng? posisiUser;
  double? _jarak;

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _hitungJarak();
  }

  Future<void> _hitungJarak() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position posisi = await Geolocator.getCurrentPosition();
    double jarak = Geolocator.distanceBetween(
      posisi.latitude,
      posisi.longitude,
      lokasiBankSampah.latitude,
      lokasiBankSampah.longitude,
    );

    setState(() {
      posisiUser = LatLng(posisi.latitude, posisi.longitude);
      _jarak = jarak / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lokasi AL Amin"),
        backgroundColor: const Color(0xFF0F7A32),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: lokasiBankSampah,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: lokasiBankSampah,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                    ),
                    if (posisiUser != null)
                      Marker(
                        point: posisiUser!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Bank Sampah AL Amin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Singajaya, Kec. Jonggol, Kabupaten Bogor, Jawa Barat 16830',
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (_jarak != null)
                  Text(
                    'Jarak ke lokasi: ${_jarak!.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
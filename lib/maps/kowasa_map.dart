import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class KowasaPage extends StatefulWidget {
  final String nama;
  final String alamat;
  final double latitude;
  final double longitude;

  const KowasaPage({
    super.key,
    required this.nama,
    required this.alamat,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<KowasaPage> createState() => _KowasaPageState();
}

class _KowasaPageState extends State<KowasaPage> {
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
      widget.latitude,
      widget.longitude,
    );

    setState(() {
      posisiUser = LatLng(posisi.latitude, posisi.longitude);
      _jarak = jarak / 1000;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lokasiBankSampah = LatLng(widget.latitude, widget.longitude);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Lokasi"),
        backgroundColor: const Color(0xFF00973A),
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
                Text(
                  widget.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.alamat,
                  style: const TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (_jarak != null)
                  Text(
                    'Jarak ke lokasi: ${_jarak!.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      color:  Color(0xFF00973A),
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
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final double _destinationLat = -6.4615281;
  final double _destinationLng = 107.0686715;
  LatLng? _userLocation;
  double? _distanceInKm;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _distanceInKm = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            _destinationLat,
            _destinationLng,
          ) /
          1000;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng destination = LatLng(_destinationLat, _destinationLng);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Lokasi'),
        backgroundColor: Colors.green[0xFF00973A],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: destination,
                    initialZoom: 17.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: destination,
                          child: const Icon(Icons.location_pin,
                              size: 40, color: Colors.red),
                        ),
                        if (_userLocation != null)
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: _userLocation!,
                            child: const Icon(Icons.person_pin_circle,
                                size: 40, color: Colors.blue),
                          ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Bank Sampah Posal Mandiri',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kp. Jl. Pojok Salak No.02/08, Jonggol\nKec. Jonggol, Kab. Bogor, Jawa Barat 16830',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _distanceInKm != null
                              ? 'Jarak ke lokasi: ${_distanceInKm!.toStringAsFixed(2)} km'
                              : 'Jarak ke lokasi: Tidak tersedia',
                          style: const TextStyle(
                              color:  Color(0xFF00973A),
                              fontWeight: FontWeight.w500),
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

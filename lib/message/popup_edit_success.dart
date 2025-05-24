// In popup_edit_success.dart file
import 'package:flutter/material.dart';

// Update to return a Future<bool>
Future<bool> showSuccessDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lingkaran hijau dengan centang putih - warna yang tepat sesuai gambar
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: const Color(0xFF00973A), // Warna hijau yang lebih sesuai dengan gambar
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              // Text "Berhasil"
              const Text(
                'Berhasil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Text body - Persis seperti di gambar (tiga baris)
              const Text(
                'kamu sudah berhasil!\nmengedit data diri,\nData Dirimu Berhasil Disimpan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              // Tombol Oke berwarna hijau
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Return false ketika tombol Oke ditekan
                    Navigator.of(context).pop(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00973A), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Oke',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).then((value) => value ?? false); // Handle null case by returning false
}
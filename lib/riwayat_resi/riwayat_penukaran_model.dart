class RiwayatPenukaran {
  final String tanggal;
  final String jenisSampah;
  final String bankSampahNama;
  final String bankSampahAlamat;
  final String nama; // TAMBAH
  final String noTelepon; // TAMBAH
  final Map<String, int> kategoriHarga; // TAMBAH
  final List<String> kategoriTerpilih; // TAMBAH

  RiwayatPenukaran({
    required this.tanggal,
    required this.jenisSampah,
    required this.bankSampahNama,
    required this.bankSampahAlamat,
    required this.nama, // TAMBAH
    required this.noTelepon, // TAMBAH
    required this.kategoriHarga, // TAMBAH
    required this.kategoriTerpilih, // TAMBAH
  });

  factory RiwayatPenukaran.fromJson(Map<String, dynamic> json) {
    return RiwayatPenukaran(
      tanggal: json['tanggal'],
      jenisSampah: json['jenisSampah'],
      bankSampahNama: json['bankSampahNama'],
      bankSampahAlamat: json['bankSampahAlamat'],
      nama: json['nama'] ?? '', // TAMBAH
      noTelepon: json['noTelepon'] ?? '', // TAMBAH
      kategoriHarga: Map<String, int>.from(json['kategoriHarga'] ?? {}), // TAMBAH
      kategoriTerpilih: List<String>.from(json['kategoriTerpilih'] ?? []), // TAMBAH
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'jenisSampah': jenisSampah,
      'bankSampahNama': bankSampahNama,
      'bankSampahAlamat': bankSampahAlamat,
      'nama': nama, // TAMBAH
      'noTelepon': noTelepon, // TAMBAH
      'kategoriHarga': kategoriHarga, // TAMBAH
      'kategoriTerpilih': kategoriTerpilih, // TAMBAH
    };
  }
}
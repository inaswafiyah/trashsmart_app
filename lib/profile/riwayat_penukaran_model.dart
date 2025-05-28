class RiwayatPenukaran {
  final String tanggal;
  final String jenisSampah;
  final String bankSampahNama;
  final String bankSampahAlamat;

  RiwayatPenukaran({
    required this.tanggal,
    required this.jenisSampah,
    required this.bankSampahNama,
    required this.bankSampahAlamat,
  });

  factory RiwayatPenukaran.fromJson(Map<String, dynamic> json) {
    return RiwayatPenukaran(
      tanggal: json['tanggal'],
      jenisSampah: json['jenisSampah'],
      bankSampahNama: json['bankSampahNama'],
      bankSampahAlamat: json['bankSampahAlamat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'jenisSampah': jenisSampah,
      'bankSampahNama': bankSampahNama,
      'bankSampahAlamat': bankSampahAlamat,
    };
  }
}
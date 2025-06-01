import 'dart:convert';

class BankRequestModel {
  final String? bankSampahNama;
  final String? bankSampahAlamat;

  BankRequestModel({this.bankSampahNama, this.bankSampahAlamat});

  factory BankRequestModel.fromJson(String str) =>
      BankRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankRequestModel.fromMap(Map<String, dynamic> json) =>
      BankRequestModel(
        bankSampahNama: json["bank_sampah_nama"],
        bankSampahAlamat: json["bank_sampah_alamat"],
      );

  Map<String, dynamic> toMap() => {
    "bank_sampah_nama": bankSampahNama,
    "bank_sampah_alamat": bankSampahAlamat,
  };
}

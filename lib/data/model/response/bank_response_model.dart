import 'dart:convert';

class BankResponseModel {
    final String? message;
    final Data? data;

    BankResponseModel({
        this.message,
        this.data,
    });

    factory BankResponseModel.fromJson(String str) => BankResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory BankResponseModel.fromMap(Map<String, dynamic> json) => BankResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "data": data?.toMap(),
    };
}

class Data {
    final String? bankSampahNama;
    final String? bankSampahAlamat;
    final DateTime? updatedAt;
    final DateTime? createdAt;
    final int? id;
    final String? mapsUrl; // Tambahkan ini

    Data({
        this.bankSampahNama,
        this.bankSampahAlamat,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.mapsUrl, // Tambahkan ini
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        bankSampahNama: json["bank_sampah_nama"],
        bankSampahAlamat: json["bank_sampah_alamat"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        mapsUrl: json["maps_url"], // Tambahkan ini
    );

    Map<String, dynamic> toMap() => {
        "bank_sampah_nama": bankSampahNama,
        "bank_sampah_alamat": bankSampahAlamat,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "maps_url": mapsUrl, // Tambahkan ini
    };
}

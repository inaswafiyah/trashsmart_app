import 'dart:convert';

class AvatarResponseModel {
    final String? status;
    final List<Avatar>? data;

    AvatarResponseModel({
        this.status,
        this.data,
    });

    factory AvatarResponseModel.fromJson(String str) => AvatarResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AvatarResponseModel.fromMap(Map<String, dynamic> json) => AvatarResponseModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Avatar>.from(json["data"]!.map((x) => Avatar.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Avatar {
    final int? id;
    final String? name;
    final String? imagePath;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    Avatar({
        this.id,
        this.name,
        this.imagePath,
        this.createdAt,
        this.updatedAt,
    });

    factory Avatar.fromJson(String str) => Avatar.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Avatar.fromMap(Map<String, dynamic> json) => Avatar(
        id: json["id"],
        name: json["name"],
        imagePath: json["image_path"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image_path": imagePath,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

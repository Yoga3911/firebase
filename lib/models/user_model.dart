import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
    Users({
        required this.nama,
        required this.umur,
        required this.gambar,
    });

    final String nama;
    final String umur;
    final String gambar;

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        nama: json["nama"],
        umur: json["umur"],
        gambar: json["gambar"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
        "umur": umur,
        "gambar": gambar,
    };
}

import 'dart:convert';

class RegisterRequestModel {
  final String username;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequestModel({
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
  return {
    'username': username, // <- ganti ini
    'phone': phone,
    'email': email,
    'password': password,
    'password_confirmation': confirmPassword,
  };
}

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      username: json['username'], // sesuaikan dengan field input dari Laravel
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['password_confirmation'],
    );
  }
}

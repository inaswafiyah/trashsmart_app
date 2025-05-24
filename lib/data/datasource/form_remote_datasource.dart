import 'dart:convert';
import 'package:http/http.dart' as http;

class FormRemoteDatasource {
  final String baseUrl;
  final http.Client client;
  final String? token; // token auth

  FormRemoteDatasource({required this.baseUrl, this.token, http.Client? client})
      : client = client ?? http.Client();

  Future<String> submitForm(Map<String, dynamic> formData) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api-form'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(formData),
    );

    if (response.statusCode == 201) {
      return 'Form submitted successfully';
    } else {
      throw Exception('Failed to submit form: ${response.body}');
    }
  }
}

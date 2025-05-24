import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'form_event.dart';
import 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final String baseUrl;
  final String token; // token auth

  FormBloc({required this.baseUrl, required this.token}) : super(FormInitial()) {
    on<FormSubmitted>(_onFormSubmitted);
  }

  Future<void> _onFormSubmitted(FormSubmitted event, Emitter<FormState> emit) async {
    emit(FormSubmitting());

    try {
      // Kirim satu kategori saja (ambil dari set pertama)
      final String category = event.categories.isNotEmpty ? event.categories.first : '';

      final response = await http.post(
        Uri.parse('$baseUrl/api-form'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "name": event.name,
          "phone": event.phone,
          "address": event.address,
          "category": category,
        }),
      );

      if (response.statusCode == 201) {
        emit(FormSuccess());
      } else {
        final resBody = jsonDecode(response.body);
        final message = resBody['message'] ?? 'Unknown error';
        emit(FormFailure('Gagal submit: $message'));
      }
    } catch (e) {
      emit(FormFailure('Terjadi kesalahan: $e'));
    }
  }
}

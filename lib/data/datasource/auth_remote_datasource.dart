import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashsmart/data/datasource/auth_local_datasource.dart';
import 'package:trashsmart/data/model/request/login_request_model.dart';
import 'package:trashsmart/data/model/request/register_request_model.dart';
import 'package:trashsmart/data/model/response/auth_response_model.dart';
import 'package:trashsmart/core/constants/variable.dart';
import 'dart:convert';

import 'package:trashsmart/data/model/response/avatar_response_model.dart';

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel data,
  ) async {
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: data.toJson(),
    );
    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromJson(response.body));
    } else {
      return Left(response.body);
    }
  }

  Future<Either<String, String>> logout() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variable.baseUrl}/api/logout'),
      headers: <String, String>{
        'Authorization': 'Bearer ${authData.token}',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Right('Logout Successful');
    } else {
      return left(response.body);
    }
  }

  Future<Either<String, AuthResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Variable.baseUrl}/api/register'),
        body: json.encode(request.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        final authResponse = AuthResponseModel.fromMap(data);
        return Right(authResponse);
      } else {
        final error = json.decode(response.body);
        return Left(error.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${Variable.baseUrl}/api/update-password/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return Right('Kata sandi berhasil diperbarui');
      } else {
        final error = json.decode(response.body);
        return Left(error.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  Future<Either<String, List<Avatar>>> getAvatars() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final currentToken = authData.token;

      final response = await http.get(
        Uri.parse('${Variable.baseUrl}/api/avatars'),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final avatarResponse = AvatarResponseModel.fromMap(data);
        return Right(avatarResponse.data ?? []);
      } else {
        return Left(response.body);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, AuthResponseModel>> updateAvatar(int avatarId) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final currentToken = authData.token;

      if (currentToken == null || currentToken.isEmpty) {
        return const Left('tidak ada token yang ditemukan');
      }

      final response = await http.post(
        Uri.parse('${Variable.baseUrl}/api/update-avatar'),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentToken',
        },
        body: json.encode({'avatar_id': avatarId}),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        responseData['token'] = currentToken;

        final authResponse = AuthResponseModel.fromMap(responseData);
        return Right(authResponse);
      } else {
        return Left('Gagal memperbarui avatar: ${response.body}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, List<Map<String, dynamic>>>> getAllVideos() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final currentToken = authData.token;

      final response = await http.get(
        Uri.parse('${Variable.baseUrl}/api/api-video'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $currentToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final videos = data.cast<Map<String, dynamic>>();
        return Right(videos);
      } else {
        return Left('Gagal mengambil video: ${response.body}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<int> getTotalDonasi() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final token = authData.token;
    final response = await http.get(
      Uri.parse('${Variable.baseUrl}/api/user/total-donasi'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['total'] ?? 0;
    }
    return 0;
  }
}

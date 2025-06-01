import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:trashsmart/core/constants/variable.dart';
import 'package:trashsmart/data/model/request/bank_request_model.dart';
import 'package:trashsmart/data/model/response/bank_response_model.dart';
import 'auth_local_datasource.dart';

class BankRemoteDataSource {
  Future<Either<String, List<Data>>> getBankSampahList() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      final response = await http.get(
        Uri.parse('${Variable.baseUrl}/api/api-banksampah'),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        },
      );

      if (response.statusCode == 200) {
        final List jsonList = json.decode(response.body);
        final listData = jsonList.map((e) => Data.fromMap(e)).toList();
        return Right(listData);
      } else {
        return Left('Gagal ambil data bank sampah: ${response.body}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, BankResponseModel>> createBankSampah(
    BankRequestModel request,
  ) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();

      final response = await http.post(
        Uri.parse('${Variable.baseUrl}/api/api-banksampah'),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        },
        body: request.toJson(),
      );

      if (response.statusCode == 201) {
        return Right(BankResponseModel.fromJson(response.body));
      } else {
        return Left('Gagal tambah bank sampah: ${response.body}');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:admin_smartfunding/data/model/company/company.dart';
import 'package:admin_smartfunding/di/di.dart';
import 'package:admin_smartfunding/utils/apiExeption.dart';
import 'package:admin_smartfunding/utils/auth_manager.dart';
import 'package:dio/dio.dart';

import '../model/company/root_company.dart';

abstract class ICompanyDatasource {
  Future<List<Company>> getCompany();
}

class CompanyDatasource extends ICompanyDatasource {
  final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();
  @override
  Future<List<Company>> getCompany() async {
    try {
      var res = await _dio.get(
        '/admin/companies',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return (res.data['data'] as List<dynamic>)
          .map((json) => Company.fromJson(json))
          .toList();
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }
}

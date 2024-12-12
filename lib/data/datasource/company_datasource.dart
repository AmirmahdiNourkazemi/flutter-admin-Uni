import 'dart:async';

import 'package:admin_smartfunding/di/di.dart';
import 'package:admin_smartfunding/utils/apiExeption.dart';
import 'package:admin_smartfunding/utils/auth_manager.dart';
import 'package:dio/dio.dart';

import '../model/company/root_company.dart';

abstract class ICompanyDatasource {
Future<RootCompany> getCompany();

}


class CompanyDatasource extends ICompanyDatasource {
    final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();
  @override
  Future<RootCompany> getCompany() async{
   try {
    var res = await _dio.get('/companies',   options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),);
        return RootCompany.fromJson(res.data);

   }on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } 
   catch (e) {
     throw Exception(e);
   }
  }
}
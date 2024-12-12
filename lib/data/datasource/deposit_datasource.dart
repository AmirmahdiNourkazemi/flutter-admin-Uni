import 'package:dio/dio.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../../utils/auth_manager.dart';
import '../model/deposit/data_source.dart';

abstract class IDepositDtasource {
  Future<DepositData> getDeposit(
      String? mobile, int per_page, int? status, int page);
      Future<void> changeDepositStatus(int status, String uuid);
}

class DepositDatasource extends IDepositDtasource {
  final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();

  @override
  Future<DepositData> getDeposit(
      String? mobile, int per_page, int? status, int page) async {
    try {
      var response = await _dio.get(
        '/admin/deposits',
        queryParameters: status == null
            ? {
                'search': mobile,
                'per_page': per_page,
                'page': page,
              }
            : mobile == null
                ? {
                    'per_page': per_page,
                    'status': status,
                    'page': page,
                  }
                : {
                    'search': mobile,
                    'per_page': per_page,
                    'status': status,
                    'page': page,
                  },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return DepositData.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex.toString());  
    }
  }

  @override
  Future<void> changeDepositStatus(int status, String uuid) async {
    try {
      var response = await _dio.post(
        '/admin/deposits/$uuid',
        data: {'status': status},
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex);
      //throw ApiExeption('unknown error happend', 0);
    }
  }
}

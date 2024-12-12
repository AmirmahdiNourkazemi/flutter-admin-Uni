import 'package:admin_smartfunding/utils/auth_manager.dart';
import 'package:dio/dio.dart';

import '../../../di/di.dart';
import '../../../utils/apiExeption.dart';
import '../model/otp/userData.dart';

abstract class IAuthenthicationDatasource {
  Future<UserData> login(String mobile, String nationalCode);
  Future<UserData> getcheckOtp(
      String mobileNumber, String nationalCode, String sms);
  Future<void> logout();
}

class AuthenthicationDatasource extends IAuthenthicationDatasource {
  final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();
  @override
  Future<UserData> login(String mobile, String nationalCode) async {
    try {
      Response response = await _dio.post('/auth/login',
          options: Options(headers: {
            'Accept': 'application/json',
          }),
          data: {'mobile': mobile, 'national_code': nationalCode});
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        // Retrieve the JSON data from the response
        print(response.data);
        return UserData.fromJson(jsonData);
        // return Ckeck.fromJson(jsonData); // Map the JSON data to your model
      } else {
        throw Exception('Failed to fetch data');
      }
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<UserData> getcheckOtp(
      String mobileNumber, String nationalCode, String sms) async {
    try {
      var response = await _dio.post('/auth/check-otp', data: {
        'mobile': mobileNumber,
        'national_code': nationalCode,
        'token': sms
      }); // Make the API request
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        // Retrieve the JSON data from the response
        return UserData.fromJson(jsonData);
        // return Ckeck.fromJson(jsonData); // Map the JSON data to your model
      } else {
        throw Exception('Failed to fetch data');
      }
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.put(
        '/auth/logout',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }
}

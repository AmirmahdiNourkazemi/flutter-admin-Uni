import 'package:admin_smartfunding/data/model/profile/responseData.dart';
import 'package:dio/dio.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../../utils/auth_manager.dart';
import '../model/message_template/message_template.dart';

import '../model/users/userResponse.dart';

abstract class IUserDatasource {
  Future<UserResponse> getUsers(
    String? search,
    int perPage,
    int page,
    int? paid,
    int? completedProfile,
    int? notEmptyWallet,
    int? hasSellingTrade,
    String? projectUUid,
  );
  Future<UserResponse> getMobileUsers(String mobile);
  Future<UserResponse> getPaid(int perPage, int page, int paid);
  Future<String> getExcelUsers(String? mobile, int? paid, int? completedProfile,
      int? notEmptyWallet, int? hasSellingTrade, String? projectUUid);
  Future<UserResponse> getCompletedProfile(
      int perPage, int page, int completedProfile);
  Future<ResponseData> getUserPivot(String uuid);
  Future<void> sendBulkRemindSms(
    String? mobile,
    int? paid,
    int? completedProfile,
    int? notEmptyWallet,
    int? hasSellingTrade,
    String template,
    String projectUuid,
  );
  Future<void> updateUser(
      String uuid,
      String firstName,
      String lastName,
      String email,
      String fatherName,
      String birthday,
      String phone,
      String workPhone,
      String address,
      String workAddress,
      String nationalCode);
  Future<List<MessageTemplate>> getMessageTemplate();
  Future<String> sendRemindSms(String uuid);
}

class UserDatasource extends IUserDatasource {
  final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();
  Future<UserResponse> getUsers(
      String? search,
      int perPage,
      int page,
      int? paid,
      int? completedProfile,
      int? notEmptyWallet,
      int? hasSellingTrade,
      String? projectUUid) async {
    try {
      var response = await _dio.get(
        '/admin/user',
        queryParameters: {
          'search': search,
          'per_page': perPage,
          'page': page,
          'paid': paid,
          'completed_profile': completedProfile,
          'not_empty_wallet': notEmptyWallet,
          'has_inviter': hasSellingTrade,
          'project_uuid': projectUUid,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex);
      //throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<UserResponse> getMobileUsers(String mobile) async {
    try {
      var response = await _dio.get(
        '/admin/users',
        queryParameters: {'search': mobile},
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<ResponseData> getUserPivot(String uuid) async {
    try {
      var response = await _dio.get(
        '/admin/users/$uuid',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ResponseData.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<void> updateUser(
      String uuid,
      String firstName,
      String lastName,
      String email,
      String fatherName,
      String birthday,
      String phone,
      String workPhone,
      String address,
      String workAddress,
      String nationalCode) async {
    try {
      var response = await _dio.patch(
        '/admin/users/$uuid',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'father_name': fatherName,
          'birthday': birthday,
          'phone': phone,
          'work_phone': workPhone,
          'address': address,
          'work_address': workAddress,
          'national_code': nationalCode,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      ); // Make the API request
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<String> sendRemindSms(String uuid) async {
    try {
      var response = await _dio.post(
        '/admin/users/$uuid/send-remind-sms',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data['message'];
      // Make the API request
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<UserResponse> getPaid(int perPage, int page, int paid) async {
    try {
      var response = await _dio.get(
        '/admin/users',
        queryParameters: {'per_page': perPage, 'page': page, 'paid': paid},
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<UserResponse> getCompletedProfile(
      int perPage, int page, int completedProfile) async {
    try {
      var response = await _dio.get(
        '/admin/users',
        queryParameters: {
          'per_page': perPage,
          'page': page,
          'completed_profile': completedProfile
        },
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return UserResponse.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<String> getExcelUsers(String? mobile, int? paid, int? completedProfile,
      int? notEmptyWallet, int? hasSellingTrade, String? projectUUid) async {
    try {
      var response = await _dio.get('/admin/users/excel/export',
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: mobile != null && mobile.isNotEmpty
              ? {
                  'search': mobile,
                  'paid': paid,
                  'completed_profile': completedProfile,
                  'not_empty_wallet': notEmptyWallet,
                  'has_selling_trade': hasSellingTrade,
                  'project_uuid': projectUUid
                }
              : {
                  'paid': paid,
                  'completed_profile': completedProfile,
                  'not_empty_wallet': notEmptyWallet,
                  'has_selling_trade': hasSellingTrade,
                  'project_uuid': projectUUid,
                });
      return response.data['link'];
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<List<MessageTemplate>> getMessageTemplate() async {
    try {
      var response = await _dio.get(
        '/admin/message-templates',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return getTemplates(response.data);
    } on DioException catch (ex) {
      // throw Exception(ex);
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      //throw Exception(ex);
      throw ApiExeption('unknown error happend', 0);
    }
  }

  Future<void> sendBulkRemindSms(
      String? mobile,
      int? paid,
      int? completedProfile,
      int? notEmptyWallet,
      int? hasSellingTrade,
      String template,
      String projectUuid) async {
    try {
      var response = await _dio.post('/admin/send-bulk-sms',
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {
            'search': mobile,
            'paid': paid,
            'completed_profile': completedProfile,
            'not_empty_wallet': notEmptyWallet,
            'has_selling_trade': hasSellingTrade,
            'template_name': template,
            'project_uuid': projectUuid
          });
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }
}

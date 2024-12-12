import 'package:dio/dio.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../../utils/auth_manager.dart';
import '../model/comments/root_comment.dart';

abstract class ICommentDataSource {
  Future<Root> getComments(String uuid);
  Future<void> changeVerify(String prrojectUuid, String commentUUid);
}

class CommentDatasource extends ICommentDataSource {
  final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();
  @override
  Future<Root> getComments(String uuid) async {
    try {
      var response = await _dio.get(
        '/admin/projects/$uuid/comments',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return Root.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  @override
  Future<void> changeVerify(String prrojectUuid, String commentUUid) async {
    try {
      var response = await _dio.put(
        '/admin/projects/$prrojectUuid/comments/$commentUUid/verify',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex);
    }
  }
}

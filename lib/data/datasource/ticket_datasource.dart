import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../../utils/auth_manager.dart';
import '../model/ticket/pagination.dart';
import '../model/ticket_uuid/get_ticket.dart';

abstract class ITicketDataSource {
  Future<Pagination> getTicket(
      int perPage, int page, int? status, int? category , String? mobile);
  Future<void> changeTicketStatus(int status, String uuid);
  Future<GetTicket> uuidTicket(String uuid);
  Future<void> sendMessage(
    String uuid,
    String text,
  );
}

class TicketDatasource extends ITicketDataSource {
  @override
  final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();
  Future<Pagination> getTicket(
      int perPage, int page, int? status, int? category , String? mobile) async {
    try {
      var response = await _dio.get(
        '/admin/tickets',
        queryParameters: {
          'per_page': perPage,
          'page': page,
          'category': category,
          'status': status,
          'search':mobile
        },
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return Pagination.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex);
      //throw ApiExeption('unknown error happend', 0);
    }
  }

  Future<GetTicket> uuidTicket(String uuid) async {
    try {
      var response = await _dio.get(
        '/admin/tickets/$uuid',
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      return GetTicket.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  @override
  Future<void> changeTicketStatus(int status, String uuid) async {
    try {
      var response = await _dio.put(
        '/admin/tickets/$uuid/status',
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

  Future<void> sendMessage(String uuid, String text) async {
    try {
      var response = await _dio.post(
        '/admin/tickets/$uuid/messages',
        data: {'text': text},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('Unknown error happened', 0);
    }
  }
}

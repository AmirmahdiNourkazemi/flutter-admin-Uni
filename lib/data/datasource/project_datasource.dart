import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../../utils/auth_manager.dart';
import '../model/project_response_create/project_response.dart';
import '../model/projects/Root.dart';
import 'package:image_picker/image_picker.dart';

abstract class IProjectsDatasource {
  Future<Root> getProjects();
  Future<ProjectResponse> createProject(
    String title,
    String description,
    int type,
    int priority,
    String minInvest,
    String fundNeeded,
    String expectedProfit,
    String finishAt,
    String startAt,
    List<Map<String, String>> keyValues,
    List<Map<String, String>> timeTable,
    String shortDescription,
    String ifbUuid,
    String profit,
  );

  ///
  ///
  Future<void> UpdateProject(
    String uuid,
    String title,
    String description,
    int type,
    int status,
    int priority,
    String minInvest,
    String fundNeeded,
    String expectedProfit,
    String finishAt,
    String startAt,
    List<Map<String, String>> keyValues,
    List<Map<String, String>> timeTable,
    String shortDescription,
    String ifbUuid,
    String profit,
  );
  Future<void> UploadMedia(
      String uuid, String name, String collection, XFile file);
  Future<void> deleteMedia(String uuid, String mediaUuid);
  Future<void> deleteProject(String uuid);
  Future<void> deleteProjectForce(String uuid);
    Future<void> restoreProject(String uuid);
  Future<void> UploadVideo(String uuid, String name, PlatformFile file);
  Future<void> uploadFile(
      String uuid, String name, PlatformFile file, String collection);
}

class ProjectsDtasource extends IProjectsDatasource {
  final Dio _dio = locator.get();
  @override
  Future<Root> getProjects() async {
    Response response = await _dio.get(
      '/admin/projects',
       options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
    );
    if (response.statusCode == 200) {
      var responsedata = Root.fromJson(response.data);

      return responsedata;
      //print(responsedata.projects[0].images[7].originalUrl);
    } else {
      throw Exception();
    }
  }

  String token = AuthMnager.readAuth();
  @override
  Future<ProjectResponse> createProject(
    String title,
    String description,
    int type,
    int priority,
    String minInvest,
    String fundNeeded,
    String expectedProfit,
    String finishAt,
    String startAt,
    List<Map<String, String>> keyValues,
    List<Map<String, String>> timeTable,
    String shortDescription,
    String ifbUuid,
    String profit,
  ) async {
    try {
      var response = await _dio.post(
        '/admin/projects',
        data: {
          'title': title,
          'description': description,
          'type': type,
          'fund_needed': fundNeeded,
          'min_invest': minInvest,
          'expected_profit': expectedProfit,
          'finish_at': finishAt,
          'start_at': startAt,
          'properties': keyValues,
          'time_table': timeTable,
          'short_description': shortDescription,
          'ifb_uuid': ifbUuid,
          'profit': profit,
        },
        options: Options(headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
      var responsedata = ProjectResponse.fromJson(response.data);
      return responsedata;
    } on DioException catch (ex) {
      //throw Exception(ex);
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      print(ex);
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<void> UpdateProject(
    String uuid,
    String title,
    String description,
    int type,
    int status,
    int priority,
    String minInvest,
    String fundNeeded,
    String expectedProfit,
    String finishAt,
    String startAt,
    List<Map<String, String>> keyValues,
    List<Map<String, String>> timeTable,
    String shortDescription,
    String ifbUuid,
    String profit,
  ) async {
    try {
      await _dio.patch(
        '/admin/projects/$uuid',
        data: {
          'title': title,
          'description': description,
          'type': type,
          'status': status,
          'fund_needed': fundNeeded,
          'min_invest': minInvest,
          'priority': priority,
          'expected_profit': expectedProfit,
          'finish_at': finishAt,
          'start_at': startAt,
          'properties': keyValues,
          'time_table': timeTable,
          'short_description': shortDescription,
          'ifb_uuid': ifbUuid,
          'profit': profit,
        },
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

  @override
  Future<void> UploadMedia(
      String uuid, String name, String collection, XFile file) async {
    final fileName = file.path.split('/').last;
    final Uint8List bytes = await file.readAsBytes();
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "collection": collection,
        //"file": file

        "file": file == null
            ? null
            : await MultipartFile.fromBytes(bytes,
                filename: fileName, contentType: MediaType("image", "png"))
      });

      var response = await _dio.post(
        '/admin/projects/$uuid/media',
        data: formData,
        options: Options(contentType: 'multipart/form-data', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<void> deleteMedia(String uuid, String mediaUuid) async {
    try {
      await _dio.delete('/admin/projects/$uuid/media/$mediaUuid',
          options: Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<void> deleteProject(String uuid) async {
    try {
      await _dio.delete('/admin/projects/$uuid',
          options: Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }


   Future<void> restoreProject(String uuid) async {
    try {
      await _dio.put('/admin/projects/$uuid/restore',
          options: Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }
  Future<void> deleteProjectForce(String uuid) async {
    try {
      await _dio.delete('/admin/projects/$uuid/force',
          options: Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          }));
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }
  @override
  Future<void> UploadVideo(String uuid, String name, PlatformFile file) async {
    // final fileName = file.path!.split('/').last;
    final Uint8List bytes = await file.bytes!;
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "collection": 'videos',
        //"file": file

        "file": file == null
            ? null
            : await MultipartFile.fromBytes(bytes, filename: name)
      });
      var response = await _dio.post(
        '/admin/projects/$uuid/media',
        data: formData,
        options: Options(contentType: 'multipart/form-data', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<void> uploadFile(
      String uuid, String name, PlatformFile file, String collection) async {
    final Uint8List bytes = await file.bytes!;
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "collection": collection,
        //"file": file

        "file": file == null
            ? null
            : await MultipartFile.fromBytes(bytes, filename: name)
      });
      var response = await _dio.post(
        '/admin/projects/$uuid/media',
        data: formData,
        options: Options(contentType: 'multipart/form-data', headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }
}

import 'dart:js_interop';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../../utils/auth_manager.dart';
import '../model/withdraw/withdraw_data.dart';

abstract class IWithdrawDatasouce {
  Future<WithdrawData> getWithdraw(String? mobile, int per_page, int page,int? status);
  Future<void> answerWithdraw(int status, String? refID, String? withdrawDate,
      String? imageName, XFile? file, String? withdraw_uuid);
}

class WithdrawDatasource extends IWithdrawDatasouce {
  final Dio _dio = locator.get();
  String token = AuthMnager.readAuth();
  @override
  Future<WithdrawData> getWithdraw(
      String? mobile, int per_page, int page, int? status) async {
    try {
      var response = await _dio.get(
        '/admin/withdraws',
        queryParameters: status == null
            ? {
                'search': mobile,
                'per_page': per_page,
                'page':page
              }
            : mobile == null
                ? {
                    'per_page': per_page,
                    'status': status,
                    'page':page
                  }
                : {
                    'search': mobile,
                    'per_page': per_page,
                    'page':page,
                    'status': status,
                  },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return WithdrawData.fromJson(response.data);
    } on DioException catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw Exception(ex);
      //throw ApiExeption('unknown error happend', 0);
    }
  }

  @override
  Future<void> answerWithdraw(int status, String? refID, String? withdrawDate,
      String? imageName, XFile? file, String? withdraw_uuid) async {
    //    final   fileName;
    //    final Uint8List bytes;
    //  if (!file.isNull) {
    //     final   fileName = file!.path.split('/').last;
    //   final Uint8List bytes = await file.readAsBytes();

    //  }
    try {
      FormData formData = FormData.fromMap({
        "status": status,
        "ref_id": refID,
        "withdraw_date": withdrawDate,
        "images[0][name]": imageName,
        "images[0][image]": file == null
            ? null
            : await MultipartFile.fromBytes(await file.readAsBytes(),
                filename: file.path.split('/').last,
                contentType: MediaType("image", "png"))
      });
      FormData formData1 = FormData.fromMap({
        "status": status,
        "ref_id": refID,
        "withdrawDate": withdrawDate,
      });

      var response = await _dio.post(
        '/admin/withdraws/$withdraw_uuid',
        data: file == null ? formData1 : formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioError catch (ex) {
      throw ApiExeption(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiExeption('unknown error happend', 0);
    }
  }
}

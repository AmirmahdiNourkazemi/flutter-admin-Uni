import 'package:dartz/dartz.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../datasource/user_datasource.dart';
import '../model/message_template/message_template.dart';
import '../model/profile/responseData.dart';
import '../model/users/userResponse.dart';

abstract class IUserRepository {
  Future<Either<String, UserResponse>> getUsers(
      String? search,
      int perPage,
      int page,
      int? paid,
      int? completedProfile,
      int? notEmptyWallet,
      int? hasSellingTrade,
      String? projectUUid);
  Future<Either<String, UserResponse>> getMobileUsers(String mobile);
  Future<Either<String, UserResponse>> getPaid(int perPage, int page, int paid);
  Future<Either<String, String>> getExcelUsers(String? mobile, int? paid,
      int? completedProfile, int? notEmptyWallet, int? hasSellingTrade,String? projectUUid);
  Future<Either<String, UserResponse>> getCompletedProfile(
      int perPage, int page, int completedProfile);
  Future<Either<String, ResponseData>> getUserPivot(String uuid);
  Future<Either<String, String>> updateUser(
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
  Future<Either<String, List<MessageTemplate>>> getMessageTemplate();
  Future<Either<String, String>> sendRemindSms(String uuid);
  Future<Either<String, String>> sendBulkRemindSms(
    String? mobile,
    int? paid,
    int? completedProfile,
    int? notEmptyWallet,
    int? hasSellingTrade,
    String template,
    String projectUuid,
  );
}

class UserRepository extends IUserRepository {
  final IUserDatasource _userDatasource = locator.get();
  @override
  Future<Either<String, UserResponse>> getUsers(
    String? search,
    int perPage,
    int page,
    int? paid,
    int? completedProfile,
    int? notEmptyWallet,
    int? hasSellingTrade,
    String? projectUUid,
  ) async {
    try {
      var response = await _userDatasource.getUsers(search, perPage, page, paid,
          completedProfile, notEmptyWallet, hasSellingTrade , projectUUid);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, UserResponse>> getMobileUsers(String mobile) async {
    try {
      var response = await _userDatasource.getMobileUsers(mobile);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, ResponseData>> getUserPivot(String uuid) async {
    try {
      var response = await _userDatasource.getUserPivot(uuid);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, String>> updateUser(
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
      var response = await _userDatasource.updateUser(
          uuid,
          firstName,
          lastName,
          email,
          fatherName,
          birthday,
          phone,
          workPhone,
          address,
          workAddress,
          nationalCode);
      return right('پروفایل کاربر ویرایش شد.');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, String>> sendRemindSms(String uuid) async {
    try {
      var response = await _userDatasource.sendRemindSms(uuid);
      return right('پیامک به کاربر ارسال شد');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, UserResponse>> getCompletedProfile(
      int perPage, int page, int completedProfile) async {
    try {
      var response = await _userDatasource.getCompletedProfile(
          perPage, page, completedProfile);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, UserResponse>> getPaid(
      int perPage, int page, int paid) async {
    try {
      var response = await _userDatasource.getPaid(perPage, page, paid);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, String>> getExcelUsers(String? mobile, int? paid,
      int? completedProfile, int? notEmptyWallet, int? hasSellingTrade , String? projectUUid) async {
    try {
      var response = await _userDatasource.getExcelUsers(
          mobile, paid, completedProfile, notEmptyWallet, hasSellingTrade,projectUUid);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, List<MessageTemplate>>> getMessageTemplate() async {
    try {
      var response = await _userDatasource.getMessageTemplate();
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, String>> sendBulkRemindSms(
      String? mobile,
      int? paid,
      int? completedProfile,
      int? notEmptyWallet,
      int? hasSellingTrade,
      String template,
      String projectUuid) async {
    try {
      var response = await _userDatasource.sendBulkRemindSms(
          mobile,
          paid,
          completedProfile,
          notEmptyWallet,
          hasSellingTrade,
          template,
          projectUuid);
      return right('پیام برای افراد دارای فیلتر ارسال شد');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}

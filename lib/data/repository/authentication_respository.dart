
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../di/di.dart';
import '../../../utils/apiExeption.dart';
import '../../../utils/auth_manager.dart';
import '../datasource/authentication_datasource.dart';
import '../model/otp/userData.dart';

abstract class IAuthenticationRepository {
  Future<Either<String, String>> logout();
      Future<Either<String , UserData>> login(String mobileNumber,String nationalCode);
      Future<Either<  String,UserData>> getcheckOtp(String mobileNumber,String nationalCode,String sms);
}

class AuthenticationRemote extends IAuthenticationRepository {
  final IAuthenthicationDatasource _datasource = locator.get();
  final SharedPreferences _sharedPreferences = locator.get();

  
  @override
  Future<Either< String,UserData>> getcheckOtp(String mobileNumber , String nationalCode,String sms) async{
 try {
      var checkOtp = await _datasource.getcheckOtp(
        mobileNumber,
         nationalCode
        ,sms
      );
      if (checkOtp.token!.isNotEmpty) {
        AuthMnager.saveToken(checkOtp.token!);
        return right(checkOtp);
      }else {
        throw Exception();
      }
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }
  
  @override
  Future<Either<String, UserData>> login(String mobileNumber , String nationalCode) async{
   try {
      var res = await _datasource.login(
        mobileNumber,
         nationalCode,
      );

     if (res.token!.isNotEmpty) {
        AuthMnager.saveToken(res.token!);
        return right(res);
      }else {
        throw Exception();
      }
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }
  
  @override
  Future<Either<String, String>> logout() async {
    try {
      var response = await _datasource.logout();
      AuthMnager.isLogin();
      return right('خروج');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}

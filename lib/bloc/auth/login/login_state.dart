import 'package:admin_smartfunding/data/model/otp/userData.dart';
import 'package:dartz/dartz.dart';


abstract class CheckLoginState {}

class CheckLoginStartState extends CheckLoginState{}

class CheckLoadingState extends CheckLoginState{}

class CheckLoginResponse extends CheckLoginState {
  Either<String , UserData> getCheck;
  CheckLoginResponse(this.getCheck);
}

class CheckLogoutResponse extends CheckLoginState {
  Either<String , String> logout;
  CheckLogoutResponse(this.logout);
}
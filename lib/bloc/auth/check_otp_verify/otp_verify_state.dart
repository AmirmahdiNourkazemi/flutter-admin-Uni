import 'package:dartz/dartz.dart';

import '../../../data/model/otp/userData.dart';
abstract class OtpVerifyState {}

class OtpVerifyStartState extends OtpVerifyState{}

class OtpVerifyLoadingState extends OtpVerifyState{}
class OtpVerifyClearSms extends OtpVerifyState {}
class OtpVerifyResponse extends OtpVerifyState {
  Either<String , UserData> getcheckOtp;
  OtpVerifyResponse(this.getcheckOtp);
}
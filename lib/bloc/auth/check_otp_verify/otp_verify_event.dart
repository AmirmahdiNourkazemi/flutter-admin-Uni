abstract class OtpVerifyEvent {}

class OtpVerifyInitEvent extends OtpVerifyEvent{}
class OtpVerifyResendCode extends OtpVerifyEvent{}
class OtpVerifyButtonClick extends OtpVerifyEvent{
  String mobileNumber;
  String nationalCode;
  String token;
  OtpVerifyButtonClick(this.mobileNumber,this.nationalCode,this.token);
}
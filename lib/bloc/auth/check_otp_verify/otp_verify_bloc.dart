import 'package:bloc/bloc.dart';


import '../../../data/repository/authentication_respository.dart';
import '../../../di/di.dart';
import 'otp_verify_event.dart';
import 'otp_verify_state.dart';

class OtpVerifyBloc extends Bloc<OtpVerifyEvent, OtpVerifyState> {
  final IAuthenticationRepository _authenticationRepository = locator.get();
  OtpVerifyBloc() : super(OtpVerifyStartState()) {
    on(
      (event, emit) async {
        if (event is OtpVerifyInitEvent) {
          emit(OtpVerifyStartState());
        } else if (event is OtpVerifyButtonClick) {
          emit(OtpVerifyLoadingState());
          var response = await _authenticationRepository.getcheckOtp(
              event.mobileNumber,
              event.nationalCode,
              event.token
              );
          emit(OtpVerifyResponse(response));
        }else if(event is OtpVerifyResendCode){
           emit(OtpVerifyClearSms());
        }
      },
    );
  }
}
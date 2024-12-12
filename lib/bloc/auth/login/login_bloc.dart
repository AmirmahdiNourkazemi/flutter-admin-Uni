import 'package:bloc/bloc.dart';

import '../../../data/repository/authentication_respository.dart';
import '../../../di/di.dart';
import 'login_event.dart';
import 'login_state.dart';

class CheckLoginBloc extends Bloc<CheckLoginEvent, CheckLoginState> {
  final IAuthenticationRepository _authenticationRepository = locator.get();
  CheckLoginBloc() : super(CheckLoginStartState()) {
    on(
      (event, emit) async {
        if (event is CheckLoginInitEvent) {
          emit(CheckLoginStartState());
        } else if (event is CheckLoginButtonClick) {
          emit(CheckLoadingState());
          var response = await _authenticationRepository.login(
            event.mobileNumber,event.nationalCode
          );
          emit(CheckLoginResponse(response));
        } else if (event is CheckLogoutButtonClick) {
          emit(CheckLoadingState());
          var response = await _authenticationRepository.logout();
          emit(
            CheckLogoutResponse(response),
          );
        }
      },
    );
  }
}

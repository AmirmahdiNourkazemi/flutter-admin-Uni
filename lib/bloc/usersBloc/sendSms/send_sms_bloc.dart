import 'package:bloc/bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/di.dart';
import 'send_sms_event.dart';
import 'send_sms_state.dart';

class SendSmsBloc extends Bloc<SendSmsEvent, SendSmsState> {
  final IUserRepository _userRepository = locator.get();
  SendSmsBloc() : super(SendSmsInitState()) {
    on(
      (event, emit) async {
          if (event is SendRemindSmsEvent) {
            emit(SendSmsLoadingState());
          var send = await _userRepository.sendRemindSms(event.uuid);
          emit(SendRemindSmsState(send));
        
        }
      },
    );
  }
}
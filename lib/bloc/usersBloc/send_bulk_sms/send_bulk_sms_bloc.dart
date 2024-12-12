import 'package:bloc/bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/di.dart';
import 'send_bulk_sms_event.dart';
import 'send_bulk_sms_state.dart';

class SendBulkSmsBloc extends Bloc<SendBulkSmsEvent, SendBulkSmsState> {
  final IUserRepository _userRepository = locator.get();
  SendBulkSmsBloc() : super(SendSmsBulkInitState()) {
    on(
      (event, emit) async {
        if (event is SendBulkSmsEventClick) {
          emit(SendSmsBulkLoadingState());
          var send = await _userRepository.sendBulkRemindSms(
              event.mobile,
              event.paid,
              event.completedProfile,
              event.notEmptyWallet,
              event.hasSellingTrade,
              event.template,event.projectUuid);
          emit(SendBulkRemindSmsState(send));
        }
      },
    );
  }
}

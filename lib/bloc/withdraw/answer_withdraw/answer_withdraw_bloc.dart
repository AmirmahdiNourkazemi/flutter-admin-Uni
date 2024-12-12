import 'package:bloc/bloc.dart';

import '../../../data/repository/withdraw_repository.dart';
import '../../../di/di.dart';
import 'answer_withdraw_event.dart';
import 'answer_withdraw_state.dart';

class AnswerWithdrawBloc
    extends Bloc<AnswerWithdrawEvent, AnswerWithdrawState> {
  final IWithdrawRepository _withdrawRepository = locator.get();
  AnswerWithdrawBloc() : super(AnswerWithdrawInitState()) {
    on(
      (event, emit) async {
        if (event is AnswerWithdrawStartEvent) {
        } else if (event is AnswerWithdrawClickEvent) {
          emit(AnswerWithdrawLoadingState());
          var answerWithdraw = await _withdrawRepository.answerWithdraw(
              event.status,
              event.refID,
              event.withdrawDate,
              event.imageName,
              event.file,
              event.withdraw_uuid);
          emit(AnswerWithdrawResponseState(answerWithdraw));
        }
      },
    );
  }
}

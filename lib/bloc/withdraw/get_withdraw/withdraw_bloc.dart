  import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../data/model/withdraw/withdraw_data.dart';
import '../../../data/repository/withdraw_repository.dart';
import '../../../di/di.dart';

part 'withdraw_event.dart';
part 'withdraw_state.dart';

class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
   final IWithdrawRepository _withdrawRepository = locator.get();
  WithdrawBloc() : super(WithdrawInitState()) {
    on((event, emit) async{
      if (event is WithdrawStartEvent) {
        emit(WithdrawLoadingState());
        var getWithdraw = await _withdrawRepository.getWithdraw(event.mobile, event.per_page, event.page,event.status);
        emit(WithdrawResponseState(getWithdraw));
      }
    });
  }
}

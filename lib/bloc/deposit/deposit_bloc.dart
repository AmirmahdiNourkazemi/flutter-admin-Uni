import 'package:admin_smartfunding/data/repository/deposit_repository.dart';
import 'package:bloc/bloc.dart';

import '../../di/di.dart';
import 'deposit_event.dart';
import 'deposit_state.dart';

class DepositBloc extends Bloc<DepositEvent, DepositState> {
  final IDepositRepository _depositRepository = locator.get();
  DepositBloc() : super(DepositInitState()) {
    on((event, emit) async {
      if (event is DepositStartEvent) {
        emit(DepositLoadingState());
        var getWithdraw = await _depositRepository.getDeposit(
            event.mobile, event.per_page, event.status, event.page);
        emit(DepositResponseState(getWithdraw));
      } else if (event is ChangeDepositStatusEvent) {
        emit(ChangeDepositStatusState(await _depositRepository
            .changeDepositStatus(event.status, event.uuid)));
        emit(DepositLoadingState());
        var getWithdraw = await _depositRepository.getDeposit(
            event.mobile, event.perPage, null, event.page);
        emit(DepositResponseState(getWithdraw));
      }
    });
  }
}

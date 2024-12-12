import 'package:bloc/bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/di.dart';
import 'excel_event.dart';
import 'excel_state.dart';

class ExcelBloc extends Bloc<ExcelEvent, ExcelState> {
  final IUserRepository _userRepository = locator.get();
  ExcelBloc() : super(ExcelInitState()) {
    on(
      (event, emit) async {
        if (event is ExcelInitEvent) {
          //emit(ProjectLoadingState());
        }
        if (event is GetExcelEvent) {
          emit(ExcelLoadingState());
          var getExcel = await _userRepository.getExcelUsers(
              event.mobile,
              event.paid,
              event.completedProfile,
              event.notEmptyWallet,
              event.hasSellingTrade,event.projectUUid);
          emit(GetExcelState(getExcel));
        }
      },
    );
  }
}

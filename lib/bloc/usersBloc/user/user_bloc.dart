import 'package:bloc/bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/di.dart';
import 'user_event.dart';
import 'user_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final IUserRepository _userRepository = locator.get();
  UsersBloc() : super(UsersInitState()) {
    on(
      (event, emit) async {
        if (event is UsersStartEvent) {
          emit(UsersLoadingState());
          var getUnits = await _userRepository.getUsers(
            event.search,
              event.perPage,
              event.page,
              event.paid,
              event.completedProfile,
              event.notEmptyWallet,
              event.hasSellingTrade,
              event.projectUUid,
              );
          emit(UsersResponseState(getUnits));
          //emit(ProjectLoadingState());
        }
        if (event is UsersMobileEvent) {
          emit(UsersLoadingState());
          var getUnits = await _userRepository.getMobileUsers(event.mobile);

          emit(UsersResponseState(getUnits));
        }

        if (event is UserPivotEvent) {
          emit(UsersLoadingState());
          var getPivot = await _userRepository.getUserPivot(event.uuid);
          emit(UserPivotState(getPivot));
        }

        if (event is GetPaidEvent) {
          emit(UsersLoadingState());
          var getPaid = await _userRepository.getPaid(
              event.perPage, event.page, event.paid);
          emit(UsersResponseState(getPaid));
        }

        if (event is ComProfileEvent) {
          emit(UsersLoadingState());
          var getPaid = await _userRepository.getCompletedProfile(
              event.perPage, event.page, event.completedProfile);
          emit(UsersResponseState(getPaid));
        }

        if (event is UserExcelEvent) {
          emit(UsersLoadingState());
          var getExcel = await _userRepository.getExcelUsers(
              event.mobile,
              event.paid,
              event.completedProfile,
              event.hasSellingTrade,
              event.notEmptyWallet,
              event.projectUUid
              );
          emit(UserExcelState(getExcel));
          emit(UsersLoadingState());
         
        }
      },
    );
  }
}

import 'dart:math';

import 'package:admin_smartfunding/bloc/usersBloc/pivot/pivot_event.dart';
import 'package:admin_smartfunding/bloc/usersBloc/pivot/pivot_state.dart';
import 'package:bloc/bloc.dart';

import '../../../data/repository/user_repository.dart';
import '../../../di/di.dart';

class PivotBloc extends Bloc<PivotEvent, PivotState> {
  final IUserRepository _userRepository = locator.get();
  PivotBloc() : super(PivotInitState()) {
    on(
      (event, emit) async {
        if (event is PivotStartEvent) {
          //  emit(PivotLoadingState());
        }
        if (event is UserPivottEvent) {
          emit(PivotLoadingState());
          var getUnits = await _userRepository.getUserPivot(event.uuid);
          emit(PivotResponseState(getUnits));
        }
          if (event is UserProfileEvent) {
          emit(PivotLoadingState());
          var getUnits = await _userRepository.getUserPivot(event.uuid);
          emit(ProfileResponseState(getUnits));
        }
      },
    );
  }
}

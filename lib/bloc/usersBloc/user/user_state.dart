import 'package:dartz/dartz.dart';

import '../../../data/model/profile/responseData.dart';
import '../../../data/model/users/userResponse.dart';

abstract class UsersState {}

class UsersInitState extends UsersState {}

class UsersLoadingState extends UsersState {}

class UsersResponseState extends UsersState {
  Either<String, UserResponse> getUsers;
  UsersResponseState(this.getUsers);
}

class UserPivotState extends UsersState {
  Either<String, ResponseData> getPivot;
  UserPivotState(this.getPivot);
}

class UserExcelState extends UsersState {
  Either<String, String> getExcel;
  UserExcelState(this.getExcel);
}

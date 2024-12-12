import 'package:dartz/dartz.dart';

import '../../../data/model/profile/responseData.dart';


abstract class PivotState {}

class PivotInitState extends PivotState {}

class PivotLoadingState extends PivotState {}

class PivotResponseState extends PivotState {
  Either<String, ResponseData> getPivot;
  PivotResponseState(this.getPivot);
}


class ProfileResponseState extends PivotState {
  Either<String, ResponseData> getPivot;
  ProfileResponseState(this.getPivot);
}

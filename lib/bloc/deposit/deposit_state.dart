
import 'package:dartz/dartz.dart';

import '../../data/model/deposit/data_source.dart';

abstract class DepositState {}

class DepositInitState extends DepositState {}
class DepositLoadingState extends DepositState {}
class DepositResponseState extends DepositState {
  Either<String, DepositData> getDeposit;
  DepositResponseState(this.getDeposit);
}
class ChangeDepositStatusState extends DepositState {
 Either<String, String> changeDepositStatus;
  ChangeDepositStatusState(this.changeDepositStatus);
}
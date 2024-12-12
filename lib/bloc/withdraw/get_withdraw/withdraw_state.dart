part of 'withdraw_bloc.dart';

abstract class WithdrawState {}

class WithdrawInitState extends WithdrawState {}
class WithdrawLoadingState extends WithdrawState {}
class WithdrawResponseState extends WithdrawState {
  Either<String, WithdrawData> getWithdraw;
  WithdrawResponseState(this.getWithdraw);
}

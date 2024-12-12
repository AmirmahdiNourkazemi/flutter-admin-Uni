part of 'withdraw_bloc.dart';

abstract class WithdrawEvent {}

class WithdrawStartEvent  extends WithdrawEvent{
  int per_page;
  int page;
  int? status ;
  String? mobile;
  WithdrawStartEvent({this.mobile , this.per_page = 5 ,this.page = 1 , this.status});
}

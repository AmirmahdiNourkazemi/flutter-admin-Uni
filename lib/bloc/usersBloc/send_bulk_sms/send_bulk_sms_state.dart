
import 'package:dartz/dartz.dart';

abstract class SendBulkSmsState {}

class SendSmsBulkInitState extends SendBulkSmsState {}

class SendSmsBulkLoadingState extends SendBulkSmsState {}

class SendBulkRemindSmsState extends SendBulkSmsState {
  Either<String , String> sendBulkRemind;
  SendBulkRemindSmsState(this.sendBulkRemind);
}

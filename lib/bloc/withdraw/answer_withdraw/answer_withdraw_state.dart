import 'package:dartz/dartz.dart';

abstract class AnswerWithdrawState {}

class AnswerWithdrawInitState extends AnswerWithdrawState {}

class AnswerWithdrawLoadingState extends AnswerWithdrawState{

}

class AnswerWithdrawResponseState extends AnswerWithdrawState {
  Either<String , String> answerWithdraw;
  AnswerWithdrawResponseState(this.answerWithdraw);
}
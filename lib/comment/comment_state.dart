import 'package:admin_smartfunding/data/model/comments/root_comment.dart';
import 'package:dartz/dartz.dart';

abstract class CommentState {}

class CommentInitState extends CommentState {}

class CommentLoadingState extends CommentState {}

class CommentResponseState extends CommentState {
  Either<String, Root> getComments;
  CommentResponseState(this.getComments);
}

class CommentChangeVerifyState extends CommentState {
  Either<String, String> changeVerify;
  CommentChangeVerifyState(this.changeVerify);
}
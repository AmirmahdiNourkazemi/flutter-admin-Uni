import 'package:dartz/dartz.dart';

abstract class DeleteMediaState {}

class DeleteMediaInitState extends DeleteMediaState {}

class DeleteMediaLoadingState extends DeleteMediaState {}

class DeleteMediaResponseState extends DeleteMediaState {
  Either<String, String> response;
  DeleteMediaResponseState(this.response);
}
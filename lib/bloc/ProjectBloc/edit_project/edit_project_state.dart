import 'package:dartz/dartz.dart';

abstract class EditProjectState {}

class EditProjectInitState extends EditProjectState {}

class EditProjectLoadingState extends EditProjectState {}

class EditProjectResponseState extends EditProjectState {
  Either<String, String> response;
  EditProjectResponseState(this.response);
}
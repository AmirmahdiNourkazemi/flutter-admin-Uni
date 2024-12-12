import 'package:dartz/dartz.dart';
import '../../../data/model/project_response_create/project_response.dart';

abstract class CreateProjectState {}

class CreateProjectInitState extends CreateProjectState {}

class CreateProjectLoadingState extends CreateProjectState {}

class CreateProjectResponseState extends CreateProjectState {
  Either<String, ProjectResponse> response;
  CreateProjectResponseState(this.response);
}
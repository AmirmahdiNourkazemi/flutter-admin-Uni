import 'package:dartz/dartz.dart';


abstract class UploadMediaState {}

class UploadMediaInitState extends UploadMediaState {}

class UploadMediaLoadingState extends UploadMediaState {}

class UploadMediaResponseState extends UploadMediaState {
  Either<String, String> response;
  UploadMediaResponseState(this.response);
}



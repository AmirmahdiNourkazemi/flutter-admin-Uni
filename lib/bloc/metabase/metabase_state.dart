import 'package:dartz/dartz.dart';

abstract class MetabaseState {}

class MetabaseInitState extends MetabaseState {}

class MetabaseLoadingState extends MetabaseState {}

class MetabaseResponseState extends MetabaseState {
  Either<String , String> getMetabase;
  MetabaseResponseState(this.getMetabase);
}
import 'package:dartz/dartz.dart';

abstract class ExcelState {}

class ExcelInitState extends ExcelState {}

class ExcelLoadingState extends ExcelState{}

class GetExcelState extends ExcelState {
  Either<String, String> getExcel;
  GetExcelState(this.getExcel);
}
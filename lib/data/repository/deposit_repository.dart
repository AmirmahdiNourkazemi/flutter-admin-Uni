import 'package:dartz/dartz.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../datasource/deposit_datasource.dart';
import '../model/deposit/data_source.dart';

abstract class IDepositRepository {
  Future<Either<String, DepositData>> getDeposit(
      String? mobile, int per_page, int? status, int page);
  Future<Either<String, String>> changeDepositStatus(int status, String uuid);
}

class DepositRepository extends IDepositRepository {
  final IDepositDtasource depositDtasource = locator.get();
  @override
  Future<Either<String, DepositData>> getDeposit(
      String? mobile, int per_page, int? status, int page) async {
    try {
      var response =
          await depositDtasource.getDeposit(mobile, per_page, status, page);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, String>> changeDepositStatus(
      int status, String uuid) async {
    try {
      var response = await depositDtasource.changeDepositStatus(status, uuid);
      return right('وضعیت فیش تغییر داده شد');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}

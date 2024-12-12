import 'package:admin_smartfunding/data/datasource/metabase_datasource.dart';
import 'package:dartz/dartz.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';

abstract class IMetaBaseRepository {
  Future<Either<String, String>> getMetabase();
}

class MetaBaseRepository extends IMetaBaseRepository {
  final IMetaBaseDatasource _baseDatasource = locator.get();
  @override
  Future<Either<String, String>> getMetabase() async {
    try {
      var response = await _baseDatasource.getMetabase();
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}

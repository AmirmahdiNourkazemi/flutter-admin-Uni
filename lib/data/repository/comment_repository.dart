import 'package:admin_smartfunding/data/model/comments/root_comment.dart';
import 'package:admin_smartfunding/utils/apiExeption.dart';
import 'package:dartz/dartz.dart';

import '../../di/di.dart';
import '../datasource/comment_datasource.dart';

abstract class ICommentRepository{
  Future<Either<String , Root>> getComments(String uuid);
  Future<Either<String,String>> changeVerify(String prrojectUuid, String commentUUid);
}


class CommentRepository extends ICommentRepository{
  final ICommentDataSource _commentDataSource = locator.get();
  @override
  Future<Either<String, Root>> getComments(String uuid) async{
    try {
      var response = await _commentDataSource.getComments(uuid);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String,String>> changeVerify(String prrojectUuid, String commentUUid) async{
    try {
      var response = await _commentDataSource.changeVerify(prrojectUuid, commentUUid);
      return right('تغییر وضعیت انجام شد');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}


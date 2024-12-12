import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../datasource/withdraw_datasource.dart';
import '../model/withdraw/withdraw_data.dart';

abstract class IWithdrawRepository {
  Future<Either<String , WithdrawData>> getWithdraw(String? mobile  , int per_page,int page , int? status);
  Future<Either<String , String >> answerWithdraw(int status, String? refID, String? withdrawDate,
      String? imageName, XFile? file, String? withdraw_uuid);
}

class WithdrawRepository extends IWithdrawRepository {
   final IWithdrawDatasouce withdrawDatasource = locator.get();
  @override
  Future<Either<String, WithdrawData>> getWithdraw(String? mobile, int per_page,int page, int? status) async{
     
  
      try {
       var response =  await withdrawDatasource.getWithdraw(mobile, per_page, page,status);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
  
  @override
  Future<Either<String, String>> answerWithdraw(int status, String? refID, String? withdrawDate, String? imageName, XFile? file, String? withdraw_uuid) async{
        try {
       var response =  await withdrawDatasource.answerWithdraw(status , refID , withdrawDate , imageName , file, withdraw_uuid);
      return right('تغییرات انجام شد');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
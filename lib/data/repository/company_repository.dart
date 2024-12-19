import 'package:admin_smartfunding/data/datasource/company_datasource.dart';
import 'package:admin_smartfunding/data/model/company/root_company.dart';
import 'package:admin_smartfunding/di/di.dart';
import 'package:admin_smartfunding/utils/apiExeption.dart';
import 'package:dartz/dartz.dart';

import '../model/company/company.dart';

abstract class ICompanyRespository {
Future<Either<String , List<Company>>> getCompany();

}


class CompanyRespository extends ICompanyRespository {
   final ICompanyDatasource _companyDatasource = locator.get();
  @override
  Future<Either<String, List<Company>>> getCompany() async{
   try {
     var res  = await _companyDatasource.getCompany();
     return Right(res);
   }  on ApiExeption catch (e) {
      return left(e.message ?? 'خطا');
   }
    // } catch (e){
    //   return left(Exception(e).toString());
    // }
  }
}
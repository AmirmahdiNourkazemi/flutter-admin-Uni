import 'package:admin_smartfunding/data/model/company/root_company.dart';
import 'package:dartz/dartz.dart';

abstract class CompanyState {}

class CompanyInitState extends CompanyState {}

class CompanyLoadingState extends CompanyState {}

class CompanyResponseState extends CompanyState {
  Either<String , RootCompany> getCompany;
  CompanyResponseState(this.getCompany);
}
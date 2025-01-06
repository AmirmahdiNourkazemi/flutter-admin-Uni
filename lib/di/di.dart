import 'package:admin_smartfunding/data/datasource/comment_datasource.dart';
import 'package:admin_smartfunding/data/datasource/company_datasource.dart';
import 'package:admin_smartfunding/data/datasource/deposit_datasource.dart';
import 'package:admin_smartfunding/data/datasource/metabase_datasource.dart';
import 'package:admin_smartfunding/data/repository/comment_repository.dart';
import 'package:admin_smartfunding/data/repository/company_repository.dart';
import 'package:admin_smartfunding/data/repository/deposit_repository.dart';
import 'package:admin_smartfunding/data/repository/metabase_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasource/authentication_datasource.dart';
import '../data/datasource/project_datasource.dart';
import '../data/datasource/ticket_datasource.dart';
import '../data/datasource/user_datasource.dart';
import '../data/datasource/withdraw_datasource.dart';
import '../data/repository/authentication_respository.dart';
import '../data/repository/project_repository.dart';
import '../data/repository/ticket_repository.dart';
import '../data/repository/user_repository.dart';
import '../data/repository/withdraw_repository.dart';
import '../utils/auth_manager.dart';

var locator = GetIt.instance;

Future<void> getItInit() async {
  locator.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  String token = AuthMnager.readAuth();
  locator.registerSingleton<Dio>(
    Dio(
      BaseOptions(baseUrl: 'http://127.0.0.1:8000/api', headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Access-Control-Allow-Origin': '*',
        //'Content-Type': 'multipart/form-data',
      }),
    ),
  );

  //datasource
  locator.registerFactory<IAuthenthicationDatasource>(
      () => AuthenthicationDatasource());

  locator.registerFactory<IProjectsDatasource>(() => ProjectsDtasource());
  locator.registerFactory<IMetaBaseDatasource>(() => MetaBaseDatasource());
  //  locator.registerFactory<IUnitsDatasource>(() => UnitsDtatasource());
  locator.registerFactory<IUserDatasource>(() => UserDatasource());
  //  locator.registerFactory<ICompanyDatasource>(() => CompanyDatasource());
  locator.registerFactory<ITicketDataSource>(() => TicketDatasource());
  locator.registerFactory<IWithdrawDatasouce>(() => WithdrawDatasource());
  locator.registerFactory<ICommentDataSource>(() => CommentDatasource());
  locator.registerFactory<IDepositDtasource>(() => DepositDatasource());
  locator.registerFactory<ICompanyDatasource>(() => CompanyDatasource());
  // //repository
  locator
      .registerFactory<IAuthenticationRepository>(() => AuthenticationRemote());
  locator.registerFactory<IProjectsRepository>(() => ProjectsRepository());
  locator.registerFactory<IMetaBaseRepository>(() => MetaBaseRepository());
  // locator.registerFactory<IUnitRepository>(() => UnitRepository());
  locator.registerFactory<IUserRepository>(() => UserRepository());
  //   locator.registerFactory<ICompanyRepository>(() => CompanyRepository());
  locator.registerFactory<ITicketRepository>(() => TicketRepository());
  locator.registerFactory<IWithdrawRepository>(() => WithdrawRepository());
  locator.registerFactory<ICommentRepository>(() => CommentRepository());
  locator.registerFactory<IDepositRepository>(() => DepositRepository());
  locator.registerFactory<ICompanyRespository>(() => CompanyRespository());

  //   //
  //   locator.registerSingleton<CompanyBloc>(CompanyBloc());
}

import 'package:admin_smartfunding/bloc/company/company_event.dart';
import 'package:admin_smartfunding/data/repository/company_repository.dart';
import 'package:admin_smartfunding/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final ICompanyRespository _iCompanyRepository = locator.get();
  CompanyBloc() : super(CompanyInitState()) {
    on((event, emit) async {
      if (event is CompanyStartEvent) {
        emit(CompanyLoadingState());
        var getCompany = await _iCompanyRepository.getCompany();
        emit(CompanyResponseState(getCompany));
        //emit(ProjectLoadingState());
      }
    });
  }
}

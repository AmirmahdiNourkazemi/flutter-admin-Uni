import 'package:admin_smartfunding/bloc/metabase/metabase_event.dart';
import 'package:admin_smartfunding/bloc/metabase/metabase_state.dart';
import 'package:admin_smartfunding/data/repository/metabase_repository.dart';
import 'package:bloc/bloc.dart';

import '../../di/di.dart';

class MetabaseBloc extends Bloc<MetabaseEvent, MetabaseState> {
  final IMetaBaseRepository _iMetaBaseRepository = locator.get();
  MetabaseBloc() : super(MetabaseInitState()) {
    on((event, emit) async {
      if (event is MetabaseStartEvent) {
        emit(MetabaseLoadingState());
        //emit(ProjectLoadingState());
      }
      if (event is MetabaseClickEvent) {
        emit(MetabaseLoadingState());
        var getProjet = await _iMetaBaseRepository.getMetabase();
        emit(MetabaseResponseState(getProjet));
        //emit(ProjectLoadingState());
      }
    });
  }
}

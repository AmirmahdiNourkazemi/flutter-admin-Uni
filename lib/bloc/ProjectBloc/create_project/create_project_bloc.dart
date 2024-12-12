import 'package:bloc/bloc.dart';

import '../../../data/repository/project_repository.dart';
import '../../../di/di.dart';
import 'create_project_event.dart';
import 'create_project_state.dart';

class CreateProjectBloc extends Bloc<CreateProjectEvent, CreateProjectState> {
  final IProjectsRepository _projectsRepository = locator.get();
  CreateProjectBloc() : super(CreateProjectInitState()) {
    on(
      (event, emit) async {
        if (event is CreateProjectStartEvent) {
          emit(CreateProjectInitState());
        } else if (event is CreateProjectRequestEvent) {
          emit(CreateProjectLoadingState());
          var response = await _projectsRepository.createProject(
            event.title,
            event.description,
            event.type,
            event.priority,
            event.minInvest,
            event.fundNeeded,
            event.expectedProfit,
            event.finishAt,
            event.startAt,
            event.keyValues,
        
            event.shortDescription,
            event.profit,
          );
          emit(CreateProjectResponseState(response));
        }
      },
    );
  }
}

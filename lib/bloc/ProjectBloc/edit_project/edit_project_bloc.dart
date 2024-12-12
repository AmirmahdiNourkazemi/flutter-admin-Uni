import 'package:bloc/bloc.dart';
import '../../../data/repository/project_repository.dart';
import '../../../di/di.dart';
import 'edit_project_event.dart';
import 'edit_project_state.dart';

class EditProjectBloc extends Bloc<EditProjectEvent, EditProjectState> {
  final IProjectsRepository _projectsRepository = locator.get();
  EditProjectBloc() : super(EditProjectInitState()) {
    on(
      (event, emit) async {
        if (event is EditProjectStartEvent) {
          emit(EditProjectInitState());
        }
        if (event is EditProjectRequestEvent) {
          emit(EditProjectLoadingState());
          var response = await _projectsRepository.UpdateProject(
            event.uuid,
            event.title,
            event.description,
            event.type,
            event.status,
            event.priority,
            event.minInvest,
            event.fundNeeded,
            event.expectedProfit,
            event.finishAt,
            event.startAt,
            event.keyValues,
            
            event.shortDescription,
            event.profit
          );
          emit(EditProjectResponseState(response));
          emit(EditProjectLoadingState());
        }
      },
    );
  }
}

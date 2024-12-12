import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_event.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../data/repository/project_repository.dart';
import '../../../di/di.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final IProjectsRepository _iProjectsRepository = locator.get();
  ProjectBloc() : super(ProjectInitState()) {
    on((event, emit) async {
      if (event is ProjectStartEvent) { 
        emit(ProjectLoadingState());
        var getProjet = await _iProjectsRepository.getProjects();
        emit(ProjectResponseState(getProjet));
        //emit(ProjectLoadingState());
      }
      if (event is ProjectDeleteEvent) {
        emit(ProjectLoadingState());
        var deleteRes = await _iProjectsRepository.DeleteProject(event.uuid);
        emit(ProjectDeleteState(deleteRes));
        var getProjet = await _iProjectsRepository.getProjects();
        emit(ProjectResponseState(getProjet));
      }
       if (event is ProjectDeleteForceEvent) {
        emit(ProjectLoadingState());
        var deleteRes = await _iProjectsRepository.DeleteProjectForce(event.uuid);
        emit(ProjectDeleteState(deleteRes));
        var getProjet = await _iProjectsRepository.getProjects();
        emit(ProjectResponseState(getProjet));
      }
      if (event is ProjectRestoreEvent) {
        emit(ProjectLoadingState());
        var deleteRes = await _iProjectsRepository.restoreProject(event.uuid);
        emit(ProjectDeleteState(deleteRes));
        var getProjet = await _iProjectsRepository.getProjects();
        emit(ProjectResponseState(getProjet));
      }
    });

  }
}


import 'package:bloc/bloc.dart';

import '../../../data/repository/project_repository.dart';
import '../../../di/di.dart';
import 'delete_media_event.dart';
import 'delete_media_state.dart';

class DeleteMediaBloc extends Bloc<DeleteMediaEvent, DeleteMediaState> {
  final IProjectsRepository _projectsRepository = locator.get();
  DeleteMediaBloc() : super(DeleteMediaInitState()) {
    on(
      (event, emit) async {
        if (event is DeleteMediaStartEvent) {
          emit(DeleteMediaInitState());
        } else if (event is DeleteMediaRequestEvent) {
          emit(DeleteMediaLoadingState());
          var response = await _projectsRepository.DeleteMedia(event.uuid, event.mediaUuid);
          emit(DeleteMediaResponseState(response));
        }
      },
    );
  }
}
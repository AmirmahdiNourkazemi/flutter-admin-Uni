import 'package:admin_smartfunding/bloc/ProjectBloc/upload_media/upload_media_event.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/upload_media/upload_media_state.dart';
import 'package:bloc/bloc.dart';

import '../../../data/repository/project_repository.dart';
import '../../../di/di.dart';

class UploadMediaBloc extends Bloc<UploadMediaEvent, UploadMediaState> {
  final IProjectsRepository _projectsRepository = locator.get();
  UploadMediaBloc() : super(UploadMediaInitState()) {
    on(
      (event, emit) async {
        if (event is UploadMediaStartEvent) {
          emit(UploadMediaInitState());
        } else if (event is UploadMediaRequestEvent) {
          emit(UploadMediaLoadingState());
          var response = await _projectsRepository.UploadMedia(
              event.uuid, event.name, event.collection, event.file);
          emit(UploadMediaResponseState(response));
        }
        if (event is UploadVideoRequestEvent) {
          emit(UploadMediaLoadingState());
          var response = await _projectsRepository.UploadVideo(
              event.uuid, event.name, event.file);
          emit(UploadMediaResponseState(response));
        }
        if (event is UploadFileRequestEvent) {
          emit(UploadMediaLoadingState());
          var response = await _projectsRepository.uploadFile(
              event.uuid, event.name, event.file,event.collection);
          emit(UploadMediaResponseState(response));
        }
      },
    );
  }
}

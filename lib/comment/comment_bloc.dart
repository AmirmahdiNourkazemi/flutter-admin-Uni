import 'package:admin_smartfunding/comment/comment_event.dart';
import 'package:admin_smartfunding/comment/comment_state.dart';
import 'package:admin_smartfunding/data/repository/comment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/di.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ICommentRepository _commentRepository = locator.get();
  CommentBloc() : super(CommentInitState()) {
    on(
      (event, emit) async {
        if (event is CommentGetEvent) {
          emit(CommentLoadingState());
          var getComment = await _commentRepository.getComments(event.uuid);
          emit(CommentResponseState(getComment));
        }
        if (event is CommentChangeVerifyEvent) {
          emit(CommentLoadingState());
          var changeVerify = await _commentRepository.changeVerify(
              event.prrojectUuid, event.commentUUid);
          emit(CommentChangeVerifyState(changeVerify));
          emit(CommentLoadingState());
          var getComment =
              await _commentRepository.getComments(event.prrojectUuid);
          emit(CommentResponseState(getComment));
        }
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/message_template/message_template.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../di/di.dart';

part 'message_template_event.dart';
part 'message_template_state.dart';

class MessageTemplateBloc extends Bloc<MessageTemplateEvent, MessageTemplateState> {
  final IUserRepository _userRepository = locator.get();
  MessageTemplateBloc() : super(MessageTemplateInitial()) {
    on<MessageTemplateEvent>((event, emit) async{
      if (event is MessageTemplateStartEvent) {
        emit(MessageTemplateLoadingState());
       var response = await _userRepository.getMessageTemplate();
       emit(MessageTemplateResponseState(response));
      }
    });
  }
}

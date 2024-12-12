
import 'package:dartz/dartz.dart';

import '../../../data/model/message_template/message_template.dart';

abstract class SendSmsState {}

class SendSmsInitState extends SendSmsState {}

class SendSmsLoadingState extends SendSmsState {}

class SendRemindSmsState extends SendSmsState {
  Either<String , String> sendRemind;
  SendRemindSmsState(this.sendRemind);
}

class GetMessageTemplateState extends SendSmsState {
  Either<List<MessageTemplate> , String> getMessageTemplate;
  GetMessageTemplateState(this.getMessageTemplate);
}
part of 'message_template_bloc.dart';


abstract class MessageTemplateState {}

 class MessageTemplateInitial extends MessageTemplateState {}


class MessageTemplateLoadingState extends MessageTemplateState {}


class MessageTemplateResponseState extends MessageTemplateState {
  Either< String,List<MessageTemplate> > getMessageTemplate;
  MessageTemplateResponseState(this.getMessageTemplate);
}
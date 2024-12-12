abstract class SendSmsEvent {}

class SendSmsStartEvent extends SendSmsEvent {
  //PivotStartEvent();
}

class SendRemindSmsEvent extends SendSmsEvent { 
  String uuid;
  SendRemindSmsEvent(this.uuid);
}
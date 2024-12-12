abstract class SendTicketEvent {}

class SendTicketStartEvent extends SendTicketEvent {
 
  SendTicketStartEvent();
}


class SendAnswerBtnClickedEvent extends SendTicketEvent {
  String uuid;
  String text;
  int status;
  SendAnswerBtnClickedEvent(this.text, this.uuid,{this.status=2});
}

class GetTicketEvent extends SendTicketEvent {
  String uuid;
  GetTicketEvent(this.uuid);
}

class CreateMessageClickedEvent extends SendTicketEvent {
  String text;
  String uuid;
  CreateMessageClickedEvent(this.uuid, this.text);
}

// class ChangeTicketStatusEvent extends SendTicketEvent {
//   int status;
//   String uuid;
//   int perPage;
//   int page;
//   ChangeTicketStatusEvent(this.status, this.uuid,
//       {this.perPage = 5, this.page = 1});
// }
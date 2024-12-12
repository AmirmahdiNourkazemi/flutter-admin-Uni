abstract class TicketEvent {}

class TicketStartEvent extends TicketEvent {
  int perPage;
  int page;
  int? status ;
  int? category;
  String? mobile;
  TicketStartEvent({this.perPage = 5, this.page = 1,this.status,this.category,this.mobile});
}

class ChangeTicketStatusEvent extends TicketEvent {
  int status;
  int? category;
  String? mobile;
  String uuid;
  int perPage;
  int page;
  ChangeTicketStatusEvent(this.status, this.uuid,
      {this.perPage = 5, this.page = 1 , this.category,this.mobile});
}

class GetTicketEvent extends TicketEvent {
  String uuid;
  GetTicketEvent(this.uuid);
}

class CreateMessageClickedEvent extends TicketEvent {
  String text;
  String uuid;
  int status;
  CreateMessageClickedEvent(this.uuid, this.text,this.status);
}
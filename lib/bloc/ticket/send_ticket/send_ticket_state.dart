import 'package:dartz/dartz.dart';

import '../../../data/model/ticket_uuid/get_ticket.dart';

abstract class SendTicketState {}

class SendTicketInitState extends SendTicketState {}

class SendTicketLoadingState extends SendTicketState {}


class SendTicketAnswerState extends SendTicketState {
  Either<String , String> sendTicket;
  SendTicketAnswerState(this.sendTicket);
}

class GetTicketResponseState extends SendTicketState {
  Either<String , GetTicket> getTicket;
  GetTicketResponseState(this.getTicket);
}

class CreateMessageResponseState extends SendTicketState {
  Either<String, String> response;
  CreateMessageResponseState(this.response);
}
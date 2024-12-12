import 'package:dartz/dartz.dart';

import '../../../data/model/ticket/pagination.dart';
import '../../../data/model/ticket_uuid/get_ticket.dart';

abstract class TicketState {}

class TicketInitState extends TicketState {}

class TicketLoadingState extends TicketState {}
class GetTicketLoadingState extends TicketState {}
class TicketResponseState extends TicketState {
  Either<String , Pagination> getTicket;
  TicketResponseState(this.getTicket);
}

class GetTicketResponseState extends TicketState {
  Either<String , GetTicket> getTicket;
  GetTicketResponseState(this.getTicket);
}

class CreateMessageResponseState extends TicketState {
  Either<String, String> response;
  CreateMessageResponseState(this.response);
}
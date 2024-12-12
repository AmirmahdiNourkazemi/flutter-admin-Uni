import 'package:bloc/bloc.dart';

import '../../../data/repository/ticket_repository.dart';
import '../../../di/di.dart';
import 'send_ticket_event.dart';
import 'send_ticket_state.dart';

class SendTicketBloc extends Bloc<SendTicketEvent, SendTicketState> {
  final ITicketRepository _ticketRepository = locator.get();
  SendTicketBloc() : super(SendTicketInitState()) {
    on(
      (event, emit) async {
        if (event is SendAnswerBtnClickedEvent) {
          emit(SendTicketLoadingState());
          var changeTicketStatus =
              _ticketRepository.changeTicketStatus(event.status, event.uuid);
          var sendTicket =
              await _ticketRepository.sendTicketMessage(event.uuid, event.text);
          emit(SendTicketAnswerState(sendTicket));
        }else if (event is GetTicketEvent) {
          emit(SendTicketLoadingState());
          var getTicket = await _ticketRepository.uuidTicket(event.uuid);
          emit(GetTicketResponseState(getTicket));
        } else if (event is CreateMessageClickedEvent) {
          emit(SendTicketLoadingState());
          var getTicket = await _ticketRepository.uuidTicket(event.uuid);
          emit(GetTicketResponseState(getTicket));
        }
      },
    );
  }
}

import 'package:bloc/bloc.dart';

import '../../../data/repository/ticket_repository.dart';
import '../../../di/di.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final ITicketRepository _ticketRepository = locator.get();
  TicketBloc() : super(TicketInitState()) {
    on(
      (event, emit) async {
        if (event is TicketStartEvent) {
          emit(TicketLoadingState());
          var getUnits =
              await _ticketRepository.getTicket(event.perPage, event.page , event.status,event.category,event.mobile);
          emit(TicketResponseState(getUnits));
        } else if (event is ChangeTicketStatusEvent) {
          var changeTicketStatus = await _ticketRepository.changeTicketStatus(
              event.status, event.uuid);
          emit(TicketLoadingState());
          var getUnits =
              await _ticketRepository.getTicket(event.perPage, event.page,null,event.category,event.mobile);
          emit(
            TicketResponseState(getUnits),
          );
        } else if (event is GetTicketEvent) {
          emit(GetTicketLoadingState());
          var getTicket = await _ticketRepository.uuidTicket(event.uuid);
          emit(GetTicketResponseState(getTicket));
        } else if (event is CreateMessageClickedEvent) {
          emit(GetTicketLoadingState());
           var changeTicketStatus =
              _ticketRepository.changeTicketStatus(event.status, event.uuid);
           var res =
              await _ticketRepository.sendTicketMessage(event.uuid, event.text);
          emit(CreateMessageResponseState(res));
          emit(GetTicketLoadingState());
          var getTicket = await _ticketRepository.uuidTicket(event.uuid);
          emit(GetTicketResponseState(getTicket));
        }
      },
    );
  }
}

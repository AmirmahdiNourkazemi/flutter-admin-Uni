import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../datasource/ticket_datasource.dart';
import '../model/ticket/pagination.dart';
import '../model/ticket_uuid/get_ticket.dart';

abstract class ITicketRepository {
Future<Either<String, Pagination>> getTicket(int perPage, int page ,  int? status , int? category , String? mobile);
Future<Either<String, String>> changeTicketStatus(int status , String uuid);
 Future<Either<String, GetTicket>> uuidTicket(String uuid);
Future<Either<String, String>> sendTicketMessage(String uuid, String text);
}


class TicketRepository extends ITicketRepository {
   final ITicketDataSource _ticketDataSource = locator.get();
  @override
    Future<Either<String, Pagination>> getTicket(int perPage, int page, int? status , int? category , String? mobile) async {
    try {
      var response = await _ticketDataSource.getTicket(perPage,page,status,category,mobile);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
    Future<Either<String, GetTicket>> uuidTicket(String uuid) async {
    try {
      var response = await _ticketDataSource.uuidTicket(uuid);
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
  @override
  Future<Either<String, String>> changeTicketStatus(int status, String uuid) async{
    try {
      var response = await _ticketDataSource.changeTicketStatus(status , uuid);
      return right('وضعیت تیکت تغییر داده شد');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
  
  @override
  Future<Either<String, String>> sendTicketMessage(String uuid, String text) async{
     try {
      var response = await _ticketDataSource.sendMessage(uuid,text);
      return right('پیام با موفقیت ارسال شد ');
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }
}
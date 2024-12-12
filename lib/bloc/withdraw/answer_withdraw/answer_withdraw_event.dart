import 'package:image_picker/image_picker.dart';

abstract class AnswerWithdrawEvent {}

class AnswerWithdrawStartEvent extends AnswerWithdrawEvent {}

class AnswerWithdrawClickEvent extends AnswerWithdrawEvent {

int status; 
String? refID; 
String? withdrawDate;
 String? imageName;
  XFile? file; 
  String withdraw_uuid;
AnswerWithdrawClickEvent(this.status , this.refID , this.withdrawDate , this.imageName , this.file , this.withdraw_uuid);
}
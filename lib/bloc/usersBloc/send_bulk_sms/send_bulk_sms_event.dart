abstract class SendBulkSmsEvent {}

class SendBulkSmsStartEvent extends SendBulkSmsEvent {
  //PivotStartEvent();
}

class SendBulkSmsEventClick extends SendBulkSmsEvent { 
   String? mobile;
   int? paid;
 
  int? completedProfile;
  int? notEmptyWallet;
  int? hasSellingTrade;
  String template;
  String projectUuid;
  SendBulkSmsEventClick(this.mobile ,this.paid ,  this.completedProfile , this.notEmptyWallet , this.hasSellingTrade,this.template,this.projectUuid);
}
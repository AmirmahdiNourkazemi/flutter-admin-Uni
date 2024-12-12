abstract class DepositEvent {}

class DepositStartEvent extends DepositEvent {
  int page;
  int per_page;
  int? status;
  String? mobile;

  DepositStartEvent(
      {this.mobile, this.per_page = 20, this.status, this.page = 1});
}

class ChangeDepositStatusEvent extends DepositEvent {
  int status;
  String uuid;
  int page;
  int perPage;
  String? mobile;
  ChangeDepositStatusEvent(this.status, this.uuid,
      {this.perPage = 5, this.page = 1, this.mobile});
}

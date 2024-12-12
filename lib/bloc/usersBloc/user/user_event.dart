abstract class UsersEvent {}

class UsersStartEvent extends UsersEvent {
    String? search;
  int perPage;
  int page;
  int? paid;
  int? completedProfile;
  int? notEmptyWallet;
  int? hasSellingTrade;
  String? projectUUid;
  UsersStartEvent(
      {this.search,this.perPage = 20,
      this.page = 1,
      this.paid,
      this.completedProfile,
      this.notEmptyWallet,
      this.hasSellingTrade,
      this.projectUUid,
      });
}

class UsersMobileEvent extends UsersEvent {
  String mobile;
  UsersMobileEvent(this.mobile);
}

class UserExcelEvent extends UsersEvent {
  int? paid;
  String? mobile;
  int? completedProfile;
  int? notEmptyWallet;
  int? hasSellingTrade;
  String? projectUUid;
  UserExcelEvent({this.mobile,this.paid,this.completedProfile,this.hasSellingTrade,this.notEmptyWallet,this.projectUUid});
}

class UserPivotEvent extends UsersEvent {
  String uuid;
  UserPivotEvent(this.uuid);
}

class GetPaidEvent extends UsersEvent {
  int perPage;
  int page;
  int paid;
  GetPaidEvent(this.paid, {this.perPage = 5, this.page = 1});
}

class ComProfileEvent extends UsersEvent {
  int perPage;
  int page;
  int completedProfile;
  ComProfileEvent(this.completedProfile, {this.perPage = 5, this.page = 1});
}

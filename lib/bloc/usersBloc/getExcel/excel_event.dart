abstract class ExcelEvent {}

class ExcelInitEvent extends ExcelEvent {}

class GetExcelEvent extends ExcelEvent {
  int? paid;
  String? mobile;
  int? completedProfile;
  int? notEmptyWallet;
  int? hasSellingTrade;
  String? projectUUid;
  GetExcelEvent(
      {this.mobile,
      this.paid,
      this.completedProfile,
      this.hasSellingTrade,
      this.notEmptyWallet,
      this.projectUUid
      });
}

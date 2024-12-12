abstract class CreateProjectEvent {}

class CreateProjectStartEvent extends CreateProjectEvent {}

class CreateProjectRequestEvent extends CreateProjectEvent {
  String title;
  String description;
  int type;
  int priority;
  String minInvest;
  String fundNeeded;
  String expectedProfit;
  String finishAt;
  String startAt;
  String shortDescription;
  List<Map<String, String>> keyValues;
  List<Map<String, String>> timeTable;
  String ifbUuid;
    String profit;
  CreateProjectRequestEvent(
    this.title,
    this.description,
    this.type,
    this.priority,
    this.minInvest,
    this.fundNeeded,
    this.expectedProfit,
    this.finishAt,
    this.startAt,
    this.keyValues,
    this.timeTable,
    this.shortDescription,
    this.ifbUuid,
    this.profit
  );
}

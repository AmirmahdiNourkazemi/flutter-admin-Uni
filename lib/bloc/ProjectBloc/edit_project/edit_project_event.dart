abstract class EditProjectEvent {}

class EditProjectStartEvent extends EditProjectEvent {}

class EditProjectRequestEvent extends EditProjectEvent {
  String uuid;
  String title;
  String description;
  int type;
  int status;
  int priority;
  String minInvest;
  String fundNeeded;
  String expectedProfit;
  String finishAt;
  String startAt;
  String shortDescription;
  List<Map<String, String>> keyValues;
    String profit;
  EditProjectRequestEvent(
    this.uuid,
    this.title,
    this.description,
    this.type,
    this.status,
    this.priority,
    this.minInvest,
    this.fundNeeded,
    this.expectedProfit,
    this.finishAt,
    this.startAt,
    this.keyValues,
   
    this.shortDescription,
    this.profit,
  );
}

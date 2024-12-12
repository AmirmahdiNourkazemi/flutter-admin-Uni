class TimeTable{
  final String? title;
  final String? date;

  TimeTable({
    this.title,
    this.date,
  });

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      title: json['title'],
      date: json['date'],
    );
  }
}
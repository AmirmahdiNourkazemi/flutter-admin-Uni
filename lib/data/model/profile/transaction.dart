class Transaction {
  int id;
  int userId;
  int? projectId;
  num amount;
  String uuid;
  int type;
  String? traceCode;
  String createdAt;
  String updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    this.projectId,
    this.traceCode,
    required this.amount,
    required this.type,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      projectId: json['project_id'],
      type: json['type'],
      traceCode: json['trace_code'],
      amount: json['amount'],
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

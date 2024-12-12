class Transactions {
  int id;
  int userId;
  int amount;
  String area;
  String createdAt;
  int status;

  Transactions({
    required this.id,
    required this.userId,
    required this.amount,
    required this.area,
    required this.createdAt,
    required this.status,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      area: json['area'],
      createdAt: json['created_at'],
      status: json['status'],
    );
  }
}
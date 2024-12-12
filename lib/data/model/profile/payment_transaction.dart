class PaymentTransaction {
  int id;
  int userId;
  int projectId;
  double amount;
  double walletAmount;
  String uuid;
  int status;
  String authority;
  double commission;
  double tax;
  dynamic refId;
  String createdAt;
  String updatedAt;

  PaymentTransaction({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.amount,
    required this.walletAmount,
    required this.uuid,
    required this.status,
    required this.authority,
    required this.commission,
    required this.tax,
    this.refId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'],
      userId: json['user_id'],
      projectId: json['project_id'],
      amount: json['amount'].toDouble(),
      walletAmount: json['wallet_amount'].toDouble(),
      uuid: json['uuid'],
      status: json['status'],
      authority: json['authority'],
      commission: json['commission'].toDouble(),
      tax: json['tax'].toDouble(),
      refId: json['ref_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
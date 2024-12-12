class TradingAccount {
   int? id;
   int? userId;
   dynamic? type; // Can be null
   String? code;
   String? createdAt;
   String? updatedAt;

  TradingAccount({
     this.id,
     this.userId,
     this.type,
     this.code,
     this.createdAt,
     this.updatedAt,
  });

  factory TradingAccount.fromJson(Map<String, dynamic> json) {
    return TradingAccount(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      code: json['code'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
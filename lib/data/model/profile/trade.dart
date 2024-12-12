class Trade {
  int? id;
  int? userId;
  int? unitId;
  int? amount;
  String? area;
  int? type;
  String? uuid;
  String? createdAt;
  String? updatedAt;
  int? commission;
  int? tax;

  Trade({
     this.id,
     this.userId,
     this.unitId,
     this.amount,
     this.area,
     this.type,
     this.uuid,
     this.createdAt,
     this.updatedAt,
     this.commission,
     this.tax,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      id: json['id'],
      userId: json['user_id'],
      unitId: json['unit_id'],
      amount: json['amount'],
      area: json['area'],
      type: json['type'],
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      commission: json['commission'],
      tax: json['tax'],
    );
  }
}

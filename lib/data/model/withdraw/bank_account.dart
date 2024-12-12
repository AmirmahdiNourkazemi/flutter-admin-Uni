class BankAccount {
  int? id;
  int? userId;
  String? iban;
  String? bankName;
  String? number;
  String? branchCode; // Can be null
  String? branchName; // Can be null
  String? branchCity; // Can be null
  String? uuid;
  String? createdAt;
  String? updatedAt;

  BankAccount({
    this.id,
    this.userId,
    this.iban,
    this.bankName,
    this.number,
    this.branchCode,
    this.branchName,
    this.branchCity,
    this.uuid,
    this.createdAt,
    this.updatedAt,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'],
      userId: json['user_id'],
      iban: json['iban'] ?? 'نامشخص',
      bankName: json['bank_name'] ?? 'نامشخص',
      number: json['number'] ?? 'نامشخص',
      branchCode: json['branch_code'] ?? 'نامشخص',
      branchName: json['branch_name'] ?? 'نامشخص',
      branchCity: json['branch_city'] ?? 'نامشخص',
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

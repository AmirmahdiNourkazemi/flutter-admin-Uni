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
      iban: json['iban'],
      bankName: json['bank_name'],
      number: json['number'],
      branchCode: json['branch_code'],
      branchName: json['branch_name'],
      branchCity: json['branch_city'],
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
import 'bank_account.dart';
import 'user.dart';

class WithdrawItem {
  int id;
  int userId;
  int amount;
  int status;
  String uuid;
  String createdAt;
  String updatedAt;
  int? ibanId;
  String? refId;
  String? withdrawDate;
  List<dynamic>? images;
  User user;
  BankAccount? bankAccount;

  WithdrawItem({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
    this.ibanId,
    this.refId,
    this.withdrawDate,
    this.images,
    required this.user,
    this.bankAccount,
  });

  factory WithdrawItem.fromJson(Map<String, dynamic> json) {
    return WithdrawItem(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      status: json['status'],
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      ibanId: json['bank_account_id'],
      refId: json['ref_id'] ?? 'نامشخص',
      withdrawDate: json['withdraw_date'] ?? 'نامشخص',
      images: json['images'] != null ? List<dynamic>.from(json['images']) : [],
      user: User.fromJson(json['user']),
      // bankAccount: json['bank_account'] != null
      //     ? BankAccount.fromJson(json['bank_account'])
      //     : null,
    );
  }
}

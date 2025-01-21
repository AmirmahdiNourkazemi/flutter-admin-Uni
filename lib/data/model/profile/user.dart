import 'address.dart';
import 'bank_account.dart';
import 'id_info.dart';
import 'invite/invite.dart';
import 'legal_person.dart';
import 'payment_transaction.dart';
import 'private_person.dart';
import 'trading_account.dart';

class User {
  int id;
  int? type;
  String? email;
  String mobile;
  String? nationalCode;
  String? idCode;
  String uuid;
  String? fullName;
  bool isAdmin;
  // bool verified;
  int? wallet;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  List<BankAccount>? bankAccounts;
  List<Address>? addresses;
  IdInfo? idInfo;
  List<TradingAccount>? tradingAccounts;
  PrivatePersonInfo? privatePersonInfo;
  LegalPersonInfo? legalPersonInfo;
  List<PaymentTransaction>? paymentTransactions;
  // List<Invites>? invites;
  //List<Iban>? ibans;

  User({
    required this.id,
    this.type,
    this.email,
    required this.mobile,
    this.nationalCode,
    this.idCode,
    required this.uuid,
    this.fullName,
    required this.isAdmin,
    // required this.verified,
    this.wallet,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.privatePersonInfo,
    this.legalPersonInfo,
    this.bankAccounts,
    this.tradingAccounts,
    // this.invites,
    //this.ibans,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // List<dynamic> invitesJson = json['user']['invites'];
    // List<Invites> invitesList =
    //     invitesJson.map((invite) => Invites.fromJson(invite)).toList();
    List<dynamic>? bankAccountsJson = json['user']['bank_accounts'];
    List<BankAccount>? bankAccountsList = bankAccountsJson != null
        ? bankAccountsJson
            .map((account) => BankAccount.fromJson(account))
            .toList()
        : null;

    List<dynamic>? tradingAccountsJson = json['user']['trading_accounts'];
    List<TradingAccount>? tradingAccountsList = tradingAccountsJson != null
        ? tradingAccountsJson
            .map((account) => TradingAccount.fromJson(account))
            .toList()
        : null;

    return User(
        id: json['user']['id'],
        type: json['user']['type'],
        email: json['user']['email'],
        mobile: json['user']['mobile'],
        nationalCode: json['user']['national_code'],
        idCode: json['user']['id_code'],
        uuid: json['user']['uuid'],
        fullName: json['user']['name'] ?? 'نامشخص',
        isAdmin: json['user']['is_admin'],
        //verified: json['user']['verified'],
        wallet: json['user']['wallet'],
        createdAt: json['user']['created_at'],
        updatedAt: json['user']['updated_at'],
        deletedAt: json['user']['deleted_at'],
        privatePersonInfo: json['user']['private_person_info'] != null
            ? PrivatePersonInfo.fromJson(json['user']['private_person_info'])
            : null,
        legalPersonInfo: json['user']['legal_person_info'] != null
            ? LegalPersonInfo.fromJson(json['user']['legal_person_info'])
            : null,
        bankAccounts: bankAccountsList,
        tradingAccounts: tradingAccountsList
        //  invites: invitesList,
        // ibans: ibanList,
        );
  }
}

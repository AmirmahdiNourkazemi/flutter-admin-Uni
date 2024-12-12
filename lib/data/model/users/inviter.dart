import 'legal_person.dart';
import 'private_person.dart';

class Inviter {
  int id;
  int? type;
  String? email;
  String? mobile;
  String? nationalCode;
  String? idCode;
  String uuid;
  String? fullName;
  bool isAdmin;
  int? wallet;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  PrivatePersonInfo? privatePersonInfo;
  LegalPersonInfo? legalPersonInfo;

  Inviter({
    required this.id,
    this.type,
    this.email,
    this.mobile,
    this.nationalCode,
    this.idCode,
    required this.uuid,
    required this.isAdmin,
    this.fullName,
    this.wallet,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.privatePersonInfo,
    this.legalPersonInfo,
  });

  factory Inviter.fromJson(Map<String, dynamic> json) {
    return Inviter(
      id: json['id'],
      type: json['type'],
      email: json['email'],
      mobile: json['mobile'] ?? 'نامشخص',
      nationalCode: json['national_code'] ?? 'نامشخص',
      idCode: json['id_code'],
      fullName: json['full_name'] ?? 'نامشخص',
      uuid: json['uuid'],
      isAdmin: json['is_admin'],
      wallet: json['wallet'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      privatePersonInfo: json['private_person_info'] != null
          ? PrivatePersonInfo.fromJson(json['private_person_info'])
          : null,
      legalPersonInfo: json['legal_person_info'] != null
          ? LegalPersonInfo.fromJson(json['legal_person_info'])
          : null,
    );
  }

}

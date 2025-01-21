import 'inviter.dart';
import 'legal_person.dart';
import 'private_person.dart';

class User {
  int id;
  bool? type;
  String? email;
  String? mobile;
  String? nationalCode;
  // String? idCode;
  String uuid;
  String? name;
  bool isAdmin;
  // bool verified;
  int? wallet;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  // PrivatePersonInfo? privatePersonInfo;
  // LegalPersonInfo? legalPersonInfo;
  // Inviter? inviter;
  //List<Iban>? ibans;

  User({
    required this.id,
    this.type,
    this.email,
    this.mobile,
    this.nationalCode,
    // this.idCode,
    required this.uuid,
    required this.isAdmin,
    this.name,
    // required this.verified,
    this.wallet,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    // this.privatePersonInfo,
    // this.legalPersonInfo,

    // this.inviter,
    //this.ibans,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // List<dynamic> invitesJson = json['user']['invites'];
    // List<Invites> invitesList =
    //     invitesJson.map((invite) => Invites.fromJson(invite)).toList();

    return User(
      id: json['id'],
      type: json['type'],
      email: json['email'],
      mobile: json['mobile'] ?? 'نامشخص',
      nationalCode: json['national_code'] ?? 'نامشخص',
      // idCode: json['id_code'],
      name: json['name'] ?? 'نامشخص',
      uuid: json['uuid'],
      isAdmin: json['is_admin'],
      //verified: json['user']['verified'],
      // wallet: json['wallet'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      // privatePersonInfo: json['private_person_info'] != null
      //     ? PrivatePersonInfo.fromJson(json['private_person_info'])
      //     : null,
      // legalPersonInfo: json['legal_person_info'] != null
      //     ? LegalPersonInfo.fromJson(json['legal_person_info'])
      //     : null,
      //   inviter: json['inviter'] != null
      //     ? Inviter.fromJson(json['inviter'])
      //     : null,
      //  invites: invitesList,
      // ibans: ibanList,
    );
  }
}

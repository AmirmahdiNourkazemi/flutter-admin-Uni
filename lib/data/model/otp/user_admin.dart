
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? fatherName;
  String? email;
  String? mobile;
  String? nationalCode;
  String? idCode;
  String? birthday;
  String? phone;
  String? workPhone;
  String? uuid;
  String? address;
  String? workAddress;
  bool? isAdmin;
  bool? verified;
  double? wallet;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? fullName;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.email,
    this.mobile,
    this.nationalCode,
    this.idCode,
    this.birthday,
    this.phone,
    this.workPhone,
    this.uuid,
    this.address,
    this.workAddress,
    this.isAdmin,
    this.verified,
    this.wallet,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      firstName: json['user']['first_name'],
      lastName: json['user']['last_name'],
      fatherName: json['user']['father_name'],
      email: json['user']['email'],
      mobile: json['user']['mobile'],
      nationalCode: json['user']['national_code'],
      idCode: json['user']['id_code'],
      birthday: json['user']['birthday'],
      phone: json['user']['phone'],
      workPhone: json['user']['work_phone'],
      uuid: json['user']['uuid'],
      address: json['user']['address'],
      workAddress: json['user']['work_address'],
      isAdmin: json['user']['is_admin'],
      verified: json['user']['verified'],
      wallet: json['user']['wallet'].toDouble(),
      createdAt: json['user']['created_at'],
      updatedAt: json['user']['updated_at'],
      deletedAt: json['user']['deleted_at'],
      fullName: json['user']['full_name'],
    );
  }
}
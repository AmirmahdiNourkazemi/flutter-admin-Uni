class User {
  int id;
  String firstName;
  String lastName;
  String? fatherName;
  String? email;
  String? mobile;
  String nationalCode;
  dynamic idCode;
  String? birthday;
  String? phone;
  String? workPhone;
  String uuid;
  String? address;
  String? workAddress;
  bool is_admin;
  bool verified;
  int wallet;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  dynamic inviterId;
  String fullName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.fatherName,
    this.email,
    this.mobile,
    required this.nationalCode,
    this.idCode,
    this.birthday,
    this.phone,
    this.workPhone,
    required this.uuid,
    this.address,
    this.workAddress,
    required this.is_admin,
    required this.verified,
    required this.wallet,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.inviterId,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fatherName: json['father_name'],
      email: json['email'],
      mobile: json['mobile'],
      nationalCode: json['national_code'],
      idCode: json['id_code'],
      birthday: json['birthday'],
      phone: json['phone'],
      workPhone: json['work_phone'],
      uuid: json['uuid'],
      address: json['address'],
      workAddress: json['work_address'],
      is_admin: json['is_admin'],
      verified: json['verified'],
      wallet: json['wallet'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      inviterId: json['inviter_id'],
      fullName: json['name'],
    );
  }
}

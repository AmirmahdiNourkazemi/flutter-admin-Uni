class User {
  int id;
  int? type;
  String? email;
  String? fullName;
  String? mobile;
  String nationalCode;

  String uuid;

  bool? isAdmin;
  int wallet;
  String createdAt;
  String? updatedAt;
  String? deletedAt;

  User({
    required this.id,
    this.type,
    this.fullName,
    this.email,
    this.mobile,
    required this.nationalCode,
    required this.uuid,
    this.isAdmin,
    required this.wallet,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      type: json['type'],
      fullName: json['name'] ?? 'نامشخص',
      email: json['email'] ?? 'نامشخص',
      mobile: json['mobile'] ?? 'نامشخص',
      nationalCode: json['national_code'] ?? 'نامشخص',
      // Set a default value if it's null
      uuid: json['uuid'] ?? '',
      isAdmin: json['is_admin'] ?? false, // Set a default value if it's null

      wallet: json['wallet'] ?? 0, // Set a default value if it's null
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'], // Set a default value if it's null
      deletedAt: json['deleted_at'], // Set a default value if it's null
    );
  }
}

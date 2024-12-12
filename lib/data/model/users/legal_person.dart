class LegalPersonInfo {
  int id;
  int userId;
  String? name;
  String? registerNumber;
  String? registerPlace;
  DateTime? registerDate;
  String? economicCode;
  DateTime createdAt;
  DateTime updatedAt;

  LegalPersonInfo({
    required this.id,
    required this.userId,
    this.name,
    this.registerNumber,
    this.registerPlace,
    this.registerDate,
    this.economicCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LegalPersonInfo.fromJson(Map<String, dynamic> json) {
    return LegalPersonInfo(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      registerNumber: json['register_number'],
      registerPlace: json['register_place'],
      registerDate: json['register_date'] != null
          ? DateTime.parse(json['register_date'])
          : null,
      economicCode: json['economic_code'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

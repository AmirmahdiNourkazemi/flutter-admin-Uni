class PrivatePersonInfo {
  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? fatherName;
  int? gender;
  String? birthday;
  String? createdAt;
  String? updatedAt;

  PrivatePersonInfo({
     this.id,
     this.userId,
     this.firstName,
     this.lastName,
     this.fatherName,
     this.gender,
     this.birthday,
     this.createdAt,
     this.updatedAt,
  });

  factory PrivatePersonInfo.fromJson(Map<String, dynamic> json) {
    return PrivatePersonInfo(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fatherName: json['father_name'],
      gender: json['gender'],
      birthday: json['birthday'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
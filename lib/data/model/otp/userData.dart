
class UserData {
  String? message;
  // User? user;
  String? token;

  UserData({this.message, this.token});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      message: json['message'],
      // user: User.fromJson(json),
      token: json['token'],
    );
  }
}

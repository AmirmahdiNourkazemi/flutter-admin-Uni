import '../users/User.dart';
import 'message.dart';

class GetTicket {
  int id;
  int userId;
  String? title;
  String? description;
  int category;
  int status;
  String uuid;
  String createdAt;
  String? updatedAt;
  User user;
  List<Message>? messages;

  GetTicket({
    required this.id,
    required this.userId,
    this.title,
    this.description,
    required this.category,
    required this.status,
    required this.uuid,
    required this.createdAt,
    this.updatedAt,
    required this.user,
    this.messages,
  });

  factory GetTicket.fromJson(Map<String, dynamic> json) {
    return GetTicket(
      id: json['id'],
      userId: json['user_id'] ?? 'نامشخص',
      title: json['title'] ?? 'نامشخص',
      description: json['description'] ?? 'نامشخص',
      category: json['category'] ?? 'نامشخص',
      status: json['status'] ?? 'نامشخص',
      uuid: json['uuid'] ?? 'نامشخص',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
      messages:
          List<Message>.from(json['messages'].map((x) => Message.fromJson(x))),
    );
  }
}

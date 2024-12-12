import '../users/User.dart';

class Message {
  int id;
  int userId;
  int ticketId;
  String? text;
  String uuid;
  String createdAt;
  String updatedAt;
  // List<dynamic> attachments;
  User user;

  Message({
    required this.id,
    required this.userId,
    required this.ticketId,
    required this.text,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
    // required this.attachments,
    required this.user,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      userId: json['user_id'],
      ticketId: json['ticket_id'],
      text: json['text'],
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      // attachments: List<dynamic>.from(json['attachments'].map((x) => x)),
      user: User.fromJson(json['user']),
    );
  }
}

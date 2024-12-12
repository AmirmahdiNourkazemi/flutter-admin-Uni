import 'user.dart';

class Ticket {
  final int id;
  final int userId;
  final String title;
  final String description;
  final int category;
  final int status;
  final String uuid;
  final String createdAt;
  final String updatedAt;
  final User user;

  Ticket({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      status: json['status'],
      uuid: json['uuid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: User.fromJson(json['user']),
    );
  }
}

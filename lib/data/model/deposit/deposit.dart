import '../users/user.dart';
import '../withdraw/image_data.dart';
import 'project.dart';

class Deposit {
  final int id;
  final int userId;
  final double? amount; // Nullable
  final int status;
  final String uuid;
  final String? refId; // Nullable
  final DateTime? depositDate; // Nullable
  final DateTime createdAt;
  final DateTime updatedAt;
  final ImageData? image; // Nullable
  final User? user; // Nullable
   final Project? project;
   
  Deposit({
    required this.id,
    required this.userId,
    this.amount, // Nullable
    required this.status,
    required this.uuid,
    this.refId, // Nullable
    this.depositDate, // Nullable
    required this.createdAt,
    required this.updatedAt,
    this.image, // Nullable
    this.user, // Nullable
    this.project,
   
  });

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount']?.toDouble(), // Convert to double and make nullable
      status: json['status'],
      uuid: json['uuid'],
      refId: json['ref_id'], // Nullable
      depositDate: json['deposit_date'] != null
          ? DateTime.parse(json['deposit_date']) // Parse if not null
          : null, // Nullable
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
       image: json['image'] != null
          ? ImageData.fromJson(json['image'])
          : null,// Nullable list of ImageData // Nullable
      user: json['user'] != null
          ? User.fromJson(json['user'])
          : null, // Nullable user
     project: json['project'] != null
          ? Project.fromJson(json['project'])
          : null, 
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'status': status,
      'uuid': uuid,
      'ref_id': refId,
      'deposit_date': depositDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'images': image,
      'user': user,
    };
  }
}


import 'transaction.dart';

class Invites {
  int id;
  int inviterId;
  String uuid;
  String firstName;
  String lastName;
  String createdAt;
  String fullName;
  List<Transactions> transactions;

  Invites({
    required this.id,
    required this.inviterId,
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.fullName,
    required this.transactions,
  });

  factory Invites.fromJson(Map<String, dynamic> json) {
    List<dynamic> transactionsJson = json['transactions'];
    List<Transactions> transactionsList = transactionsJson.map((transaction) => Transactions.fromJson(transaction)).toList();

    return Invites(
      id: json['id'],
      inviterId: json['inviter_id'],
      uuid: json['uuid'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      createdAt: json['created_at'],
      fullName: json['full_name'],
      transactions: transactionsList,
    );
  }
}
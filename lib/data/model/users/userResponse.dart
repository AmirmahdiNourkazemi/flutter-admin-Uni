
import 'User.dart';
import 'links.dart';

class UserResponse {
  int? currentPage;
  List<User> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String? path;
  int perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  UserResponse({
     this.currentPage,
    required this.data,
     this.firstPageUrl,
     this.from,
     this.lastPage,
     this.lastPageUrl,
    required this.links,
     this.nextPageUrl,
     this.path,
    required this.perPage,
     this.prevPageUrl,
     this.to,
     this.total,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      currentPage: json['current_page'],
      data: List<User>.from(json['data'].map((user) => User.fromJson(user))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<Link>.from(json['links'].map((link) => Link.fromJson(link))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}
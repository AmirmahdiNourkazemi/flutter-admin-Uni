import '../ticket/link.dart';
import 'comment_data.dart';

class Root {
  int? currentPage;
  List<CommentData>? data;
  String? firstPageUrl;
  int? from;
  int lastPage;
  String? lastPageUrl;
  List<Link> links;
  String? nextPageUrl;
  String path;
  int perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Root({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory Root.fromJson(Map<String, dynamic> json) {
    return Root(
      currentPage: json['current_page'],
      data: List<CommentData>.from(
          json['data'].map((x) => CommentData.fromJson(x))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<Link>.from(json['links'].map((x) => Link.fromJson(x))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

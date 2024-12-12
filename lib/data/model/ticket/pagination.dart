
import 'package:admin_smartfunding/data/model/ticket/ticket.dart';

import 'link.dart';

class Pagination {
  int? currentPage;
  final List<Ticket> data;
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

 Pagination({
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

  factory Pagination.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List;
    final dataItems = data.map((item) => Ticket.fromJson(item)).toList();

    final links = json['links'] as List;
    final linkItems = links.map((link) => Link.fromJson(link)).toList();

    return Pagination(
      currentPage: json['current_page'],
      data: dataItems,
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: linkItems,
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}
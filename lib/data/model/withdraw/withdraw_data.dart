
import 'link.dart';
import 'withdraw_item.dart';

class WithdrawData {
  int? currentPage;
  List<WithdrawItem>? data ; 
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  WithdrawData({
     this.currentPage,
     this.data,
     this.firstPageUrl,
     this.from,
     this.lastPage,
     this.lastPageUrl,
     this.links,
     this.nextPageUrl,
     this.path,
     this.perPage,
    this.prevPageUrl,
     this.to,
     this.total,
  });

  factory WithdrawData.fromJson(Map<String, dynamic> json) {
    return WithdrawData(
      currentPage: json['current_page'],
      data:  json['data'] != null
        ? (json['data'] as List).map((item) => WithdrawItem.fromJson(item)).toList()
        : null,
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: (json['links'] as List).map((item) => Link.fromJson(item)).toList(),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}









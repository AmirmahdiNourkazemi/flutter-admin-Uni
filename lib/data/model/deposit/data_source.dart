import 'deposit.dart';

class DepositData {
  final int currentPage;
  final List<Deposit>? data; // Now nullable
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  // final List<Link>? links; // Nullable in case it doesn't exist
  final String path;
  final int perPage;
  final String? nextPageUrl; // Already nullable
  final String? prevPageUrl; // Already nullable
  final int? to;
  final int total;

  DepositData({
    required this.currentPage,
    this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    // this.links, // Made nullable
    required this.path,
    required this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory DepositData.fromJson(Map<String, dynamic> json) {
    return DepositData(
      currentPage: json['current_page'],
      data:(json['data'] as List?)?.map((item) => Deposit.fromJson(item)).toList(), // Handle nullable data
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      // links: json['links'] != null
      //     ? (json['links'] as List).map((item) => Link.fromJson(item)).toList()
      //     : null, // Handle nullable links
      path: json['path'],
      perPage: json['per_page'],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }


}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}

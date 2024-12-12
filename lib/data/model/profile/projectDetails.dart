class ProjectDetails {
  int id;
  int? companyId;
  String title;
  String address;
  String description;
  int type;
  int floors;
  int area;
  num minInvest;
  String latitude;
  String longitude;
  String expectedProfit;
  String uuid;
  String finishAt;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  int status;
  int commission;
  String startedAt;
  List<dynamic> images;
  List<dynamic> attachments;
  num progressBar;

  ProjectDetails({
    required this.id,
    this.companyId,
    required this.title,
    required this.address,
    required this.description,
    required this.type,
    required this.floors,
    required this.area,
    required this.minInvest,
    required this.latitude,
    required this.longitude,
    required this.expectedProfit,
    required this.uuid,
    required this.finishAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
    required this.commission,
    required this.startedAt,
    required this.images,
    required this.attachments,
    required this.progressBar,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      id: json['id'],
      companyId: json['company_id'],
      title: json['title'],
      address: json['address'],
      description: json['description'],
      type: json['type'],
      floors: json['floors'],
      area: json['area'],
      minInvest: json['min_invest'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      expectedProfit: json['expected_profit'],
      uuid: json['uuid'],
      finishAt: json['finish_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      status: json['status'],
      commission: json["commission"],
      startedAt: json["start_at"] ?? json["created_at"],
      images: json['images'],
      attachments: json['attachments'],
      progressBar: json['progress_bar'],
    );
  }
}

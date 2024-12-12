class ProjectResponse {
  final String? title;
  final String? description;
  final String? startAt;
  final String? finishAt;
  final String? uuid;

  final String? updatedAt;
  final String? createdAt;

  final int? id;
  final List<String>? images;
  final List<String>? attachments;
  final num? progressBar;
  final List<String>? videos;

  ProjectResponse({
    this.title,
    this.description,
    this.startAt,
    this.finishAt,
    this.uuid,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.images,
    this.attachments,
    this.progressBar,
    this.videos,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      title: json['title'],
      description: json['description'],
      startAt: json['start_at'],
      finishAt: json['finish_at'],
      uuid: json['uuid'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
      images: List<String>.from(json['images']),
    );
  }
}

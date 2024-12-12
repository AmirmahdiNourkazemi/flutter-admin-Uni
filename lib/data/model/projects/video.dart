class Video {
  final String uuid;
  final String originalUrl;
  final String name;
  final String collectionName;

  Video({
    required this.uuid,
    required this.originalUrl,
    required this.name,
    required this.collectionName,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      uuid: json['uuid'],
      originalUrl: json['original_url'],
      name: json['name'],
      collectionName: json['collection_name'],
    );
  }
}

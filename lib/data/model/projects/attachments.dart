class Attachment {
  final String uuid;
  final String originalUrl;
  final String name;
  final String collectionName;

  Attachment({
    required this.uuid,
    required this.originalUrl,
    required this.name,
    required this.collectionName,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      uuid: json['uuid'],
      originalUrl: json['original_url'],
      name: json['name'],
      collectionName: json['collection_name'],
    );
  }
}

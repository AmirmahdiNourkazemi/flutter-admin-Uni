class ImageData {
  final String uuid;
  final String originalUrl;
  final String name;
  final String collectionName;

  ImageData({
    required this.uuid,
    required this.originalUrl,
    required this.name,
    required this.collectionName,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      uuid: json['uuid'],
      originalUrl: json['original_url'],
      name: json['name'],
      collectionName: json['collection_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'original_url': originalUrl,
      'name': name,
      'collection_name': collectionName,
    };
  }
}

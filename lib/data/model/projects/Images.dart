class Image {
  String uuid;
  String originalUrl;
  String name;
  String collectionName;

  Image({
    required this.uuid,
     required this.originalUrl,
    required this.name,
    required this.collectionName,
  });

 factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      uuid: json['uuid'],
      originalUrl: json['original_url'],
      name: json['name'],
      collectionName: json['collection_name'],
    );
  }
}

class Contract {
  String uuid;
  String originalUrl;
  String name;
  String collectionName;

  Contract({
    required this.uuid,
    required this.originalUrl,
    required this.name,
    required this.collectionName,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      uuid: json['uuid'],
      originalUrl: json['original_url'],
      name: json['name'],
      collectionName: json['collection_name'],
    );
  }
}
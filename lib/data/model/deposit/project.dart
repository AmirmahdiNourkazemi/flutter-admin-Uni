import '../withdraw/image_data.dart';

class Project {
  final int id;
  final String title;
  final String uuid;
  final List<ImageData>? images;
  final List<Attachment>? attachments;
  // final int progressBar;
  final String? contract; // Nullable

  Project({
    required this.id,
    required this.title,
    required this.uuid,
     this.images,
     this.attachments,
    // required this.progressBar,
    this.contract, // Nullable
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      uuid: json['uuid'],
      images: (json['attachments']) != null ? (json['images'] as List<dynamic>)
          .map((image) => ImageData.fromJson(image))
          .toList() : [],
      attachments: (json['attachments']) != null ? (json['attachments'] as List<dynamic>)
          .map((attachment) => Attachment.fromJson(attachment))
          .toList(): [],
      // progressBar: json['progress_bar'],
      contract: json['contract'] is String
          ? json['contract']
          : json['contract']?.toString(), // Nullable
      // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'uuid': uuid,
      'images': images != null ? images!.map((image) => image.toJson()).toList() : [],
      'attachments':
         attachments != null ?  attachments!.map((attachment) => attachment.toJson()).toList() : [],
      
      'contract': contract,
    };
  }
}

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

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'original_url': originalUrl,
      'name': name,
      'collection_name': collectionName,
    };
  }
}

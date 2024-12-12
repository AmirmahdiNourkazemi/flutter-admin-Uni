import 'package:admin_smartfunding/data/model/projects/contract.dart';
import 'package:admin_smartfunding/data/model/projects/properties.dart';
import 'package:admin_smartfunding/data/model/projects/timetable.dart';

import 'Images.dart';
import 'attachments.dart';
import 'video.dart';

class Project {
  int? id;
  String? title;
  String? description;
  int? type;
  int? status;
  num? minInvest;
  num? fundNeeded;
  int? fundAchieved;
  int? expectedProfit;
  int? profit;
  int? priority;
  String? uuid;
  String? finishAt;
  String? startAt;
  String? createdAt;
  String? updatedAt;
  dynamic? deletedAt;
  List<Image>? images;

  dynamic company;
  final List<Property>? properties;

  String? shortDescription;

  Project({
    this.id,
    this.title,
    this.description,
    this.type,
    this.status,
    this.minInvest,
    this.fundNeeded,
    this.fundAchieved,
    this.expectedProfit,
    this.profit,
    this.priority,
    this.uuid,
    this.finishAt,
    this.startAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.images,
    this.company,
    this.properties,
    this.shortDescription,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    List<Image> imagesList = [];
    if (json['images'] is List<dynamic>) {
      imagesList = List<Image>.from(
          json['images'].map((imageJson) => Image.fromJson(imageJson)));
    }

    List<Video> videosList = [];
    if (json['videos'] is List<dynamic>) {
      videosList = List<Video>.from(
          json['videos'].map((videoJson) => Video.fromJson(videoJson)));
    }
    List<Attachment> attachmentsList = [];
    if (json['attachments'] is List<dynamic>) {
      attachmentsList = List<Attachment>.from(json['attachments']
          .map((attachmentJson) => Attachment.fromJson(attachmentJson)));
    }

    return Project(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      type: json["type"],
      status: json["status"],
      minInvest: json["min_invest"],
      fundNeeded: json["fund_needed"],
      fundAchieved: json["fund_achieved"],
      expectedProfit: json["expected_profit"],
      profit: json["profit"],
      priority: json["priority"],
      uuid: json["uuid"],
      finishAt: json["finish_at"],
      startAt: json["start_at"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
      images: imagesList,
      properties: (json['properties'] as List<dynamic>?)
          ?.map((property) => Property.fromJson(property))
          .toList(),
      shortDescription: json["short_description"], // Updated factory method
    );
  }
}

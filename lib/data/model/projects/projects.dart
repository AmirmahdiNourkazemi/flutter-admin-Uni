import 'package:admin_smartfunding/data/model/projects/contract.dart';
import 'package:admin_smartfunding/data/model/projects/properties.dart';
import 'package:admin_smartfunding/data/model/projects/timetable.dart';

import 'Images.dart';
import 'attachments.dart';
import 'video.dart';

class Project {
  int id;
  String title;
  String description;
  int type;
  int status;
  num minInvest;
  num fundNeeded;
  int? fundAchieved; // Marked as nullable
  String expectedProfit;
  num commission;
  String profit;
  int priority;
  String ifbUuid;
  String uuid;
  String finishAt;
  String startAt;
  String createdAt;
  String updatedAt;
  dynamic? deletedAt;
  List<Image> images;
  List<Attachment> attachments;
  num progressBar;
  List<Video> videos;
  dynamic company;
  final List<Property>? properties;
  List<TimeTable>? timeTables;
  String? shortDescription;
  Contract? contract;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.minInvest,
    required this.fundNeeded,
    this.fundAchieved,
    
    required this.expectedProfit,
    required this.commission,
    required this.profit,
    required this.priority,
    required this.uuid,
    required this.ifbUuid,
    required this.finishAt,
    required this.startAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.images,
    required this.attachments,
    required this.progressBar,
    required this.videos,
    this.company,
    this.properties,
    this.timeTables,
    this.shortDescription,
    this.contract
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
        commission: json["commission"],
        profit: json["profit"],
        priority: json["priority"],
        uuid: json["uuid"],
        ifbUuid: json["ifb_uuid"],
        finishAt: json["finish_at"],
        startAt: json["start_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        images: imagesList,
        attachments: attachmentsList,
        progressBar: json["progress_bar"],
        videos: videosList,
        company: json["company"],
        properties: (json['properties'] as List<dynamic>?)
            ?.map((property) => Property.fromJson(property))
            .toList(),
        timeTables: (json['time_table'] as List<dynamic>?)
            ?.map((timeTable) => TimeTable.fromJson(timeTable))
            .toList(),
        shortDescription: json["short_description"],
         contract: json['contract'] != null ? Contract.fromJson(json['contract']) : null, // Updated factory method
   );
        
  }
}

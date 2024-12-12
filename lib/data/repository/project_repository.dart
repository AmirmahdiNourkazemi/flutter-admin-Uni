import 'dart:html';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import '../../di/di.dart';
import '../../utils/apiExeption.dart';
import '../datasource/project_datasource.dart';
import '../model/project_response_create/project_response.dart';
import '../model/projects/Root.dart';

abstract class IProjectsRepository {
  Future<Either<String, Root>> getProjects();
  Future<Either<String, ProjectResponse>> createProject(
    String title,
    String description,
    int type,
    int priority,
    String minInvest,
    String fundNeeded,
    String expectedProfit,
    String finishAt,
    String startAt,
    List<Map<String, String>> keyValues,
    List<Map<String, String>> timeTable,
    String shortDescription,
   String profit,
  );

  ///
  ///
  ///
  Future<Either<String, String>> UpdateProject(
    String uuid,
    String title,
    String description,
    int type,
    int priority,
    int status,
    String minInvest,
    String fundNeeded,
    String expectedProfit,
    String finishAt,
    String startAt,
    List<Map<String, String>> keyValues,
      List<Map<String, String>> timeTable,
    String shortDescription,
    String profit,
   
  );
  ////////
  Future<Either<String, String>> UploadMedia(
      String uuid, String name, String collection, XFile file);
  /////
  Future<Either<String, String>> DeleteMedia(String uuid, String mediaUuid);
  /////
  Future<Either<String, String>> DeleteProject(String uuid);
  ///
    Future<Either<String, String>> DeleteProjectForce(String uuid);
    ///
      Future<Either<String, String>> restoreProject(String uuid);
  /////////
  Future<Either<String, String>> UploadVideo(
      String uuid, String name, PlatformFile file);
  Future<Either<String, String>> uploadFile(
      String uuid, String name, PlatformFile file,String collection);
}

class ProjectsRepository extends IProjectsRepository {
  @override
  final IProjectsDatasource _projectsDatasource = locator.get();
  Future<Either<String, Root>> getProjects() async {
    try {
      var response = await _projectsDatasource.getProjects();
      return right(response);
    } on ApiExeption catch (e) {
      return left(e.message ?? 'خطا محتوای متنی ندارد');
    }
  }

  @override
  Future<Either<String, ProjectResponse>> createProject(
      String title,
      String description,
      int type,
      int priority,
      String minInvest,
      String fundNeeded,
      String expectedProfit,
      String finishAt,
      String startAt,
      List<Map<String, String>> keyValues,
        List<Map<String, String>> timeTable,
      String shortDescription,
      String profit,
     ) async {
    try {
      var response = await _projectsDatasource.createProject(
          title,
          description,
          type,
          priority,
          minInvest,
          fundNeeded,
          expectedProfit,
          finishAt,
          startAt,
          keyValues,
          timeTable,
          shortDescription,
          profit,
         );
      return right(response);
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }

  @override
  Future<Either<String, String>> UpdateProject(
      String uuid,
      String title,
      String description,
      int type,
      int status,
      int priority,
      String minInvest,
      String fundNeeded,
      String expectedProfit,
      String finishAt,
      String startAt,
      List<Map<String, String>> keyValues,
      List<Map<String, String>> timeTable,
      String shortDescription,
      String profit,
     ) async {
    try {
      await _projectsDatasource.UpdateProject(
        uuid,
        title,
        description,
        type,
        status,
        priority,
        minInvest,
        fundNeeded,
        expectedProfit,
        finishAt,
        startAt,
        keyValues,
        timeTable,
        shortDescription,
        profit,
      );
      return right('پروژه با موفقیت ادیت شد');
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }

  @override
  Future<Either<String, String>> UploadMedia(
      String uuid, String name, String collection, XFile file) async {
    try {
      await _projectsDatasource.UploadMedia(uuid, name, collection, file);
      return right('عکس با موفقیت اضافه شد');
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }

  Future<Either<String, String>> DeleteMedia(
      String uuid, String mediaUuid) async {
    try {
      await _projectsDatasource.deleteMedia(uuid, mediaUuid);
      return right('عکس با موفقیت حذف شد');
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }

  @override
  Future<Either<String, String>> DeleteProject(String uuid) async {
    try {
      await _projectsDatasource.deleteProject(uuid);
      return right("پروژه مخفی شد");
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }


  Future<Either<String, String>> DeleteProjectForce(String uuid) async {
    try {
      await _projectsDatasource.deleteProjectForce(uuid);
      return right("پروژه با موفقیت حذف شد.");
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }


  Future<Either<String, String>> restoreProject(String uuid) async {
    try {
      await _projectsDatasource.restoreProject(uuid);
      return right("پروژه نمایش داده شد.");
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }
  @override
  Future<Either<String, String>> UploadVideo(
      String uuid, String name, PlatformFile file) async {
    try {
      await _projectsDatasource.UploadVideo(uuid, name, file);
      return right('ویدیو با موفقیت اضافه شد');
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }

  @override
  Future<Either<String, String>> uploadFile(
      String uuid, String name, PlatformFile file,String collection) async {
    try {
      await _projectsDatasource.uploadFile(uuid, name, file,collection);
      return right('فایل با موفقیت اضافه شد');
    } on ApiExeption catch (ex) {
      return left(ex.getFarsiMessage());
    }
  }
}

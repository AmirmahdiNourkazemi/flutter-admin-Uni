import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

abstract class UploadMediaEvent {}

class UploadMediaStartEvent extends UploadMediaEvent {}

class UploadMediaRequestEvent extends UploadMediaEvent {
  String uuid;
  String name;
  String collection;
  XFile file;
  

  UploadMediaRequestEvent(this.uuid, this.name, this.collection, this.file);
}

class UploadVideoRequestEvent extends UploadMediaEvent {
  String uuid;
  String name;
  PlatformFile file;
  UploadVideoRequestEvent(this.uuid, this.name, this.file);
}

class UploadFileRequestEvent extends UploadMediaEvent {
  String uuid;
  String name;
  PlatformFile file;
  String collection;
  UploadFileRequestEvent(this.uuid, this.name, this.file,this.collection);
}
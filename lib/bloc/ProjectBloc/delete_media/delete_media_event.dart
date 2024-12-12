abstract class DeleteMediaEvent {}

class DeleteMediaStartEvent extends DeleteMediaEvent {}

class DeleteMediaRequestEvent extends DeleteMediaEvent {
  String uuid;
  String mediaUuid;

  DeleteMediaRequestEvent(this.uuid, this.mediaUuid);
}
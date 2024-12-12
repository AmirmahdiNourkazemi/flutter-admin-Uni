abstract class CommentEvent {}


class CommentGetEvent extends CommentEvent {
  String uuid;
  CommentGetEvent(this.uuid);
}

class CommentChangeVerifyEvent extends CommentEvent {
  String prrojectUuid;
  String commentUUid;
  CommentChangeVerifyEvent(this.prrojectUuid, this.commentUUid);
}


abstract class PivotEvent {}

class PivotStartEvent extends PivotEvent {
  //PivotStartEvent();
}

class UserPivottEvent extends PivotEvent {
  String uuid;
  UserPivottEvent(this.uuid);
}

class UserProfileEvent extends PivotEvent {
  String uuid;
  UserProfileEvent(this.uuid);
}

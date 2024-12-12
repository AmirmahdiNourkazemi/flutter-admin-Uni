abstract class ProjectEvent {}

class ProjectStartEvent extends ProjectEvent {}

class ProjectDeleteEvent extends ProjectEvent {
  String uuid;
  ProjectDeleteEvent(this.uuid);
}


class ProjectDeleteForceEvent extends ProjectEvent {
  String uuid;
  ProjectDeleteForceEvent(this.uuid);
}

class ProjectRestoreEvent extends ProjectEvent {
  String uuid;
  ProjectRestoreEvent(this.uuid);
}
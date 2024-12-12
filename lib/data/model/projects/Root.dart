import 'projects.dart';

class Root {
  List<Project> projects;

  Root({required this.projects});

  factory Root.fromJson(List<dynamic> json) {
    List<Project> projects = json.map((project) => Project.fromJson(project)).toList();
    return Root(projects: projects);
  }
}
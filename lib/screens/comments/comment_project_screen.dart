import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_bloc.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_event.dart';
import 'package:admin_smartfunding/comment/comment_bloc.dart';
import 'package:admin_smartfunding/utils/phosphor_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/ProjectBloc/projects/project_state.dart';
import '../../bloc/metabase/metabase_bloc.dart';
import '../home/home_screen.dart';
import 'comment_screen.dart';

class CommentProject extends StatefulWidget {
  const CommentProject({super.key});

  @override
  State<CommentProject> createState() => _CommentProjectState();
}

class _CommentProjectState extends State<CommentProject> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    BlocProvider.of<ProjectBloc>(context).add(ProjectStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'مشاهده نظرات',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => MetabaseBloc(),
                      child: const HomeScreen(),
                    );
                  },
                ),
              );
            },
            icon: buildPhosphorIcon(
                PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
                size: 28),
          ),
        ),
        body: BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
          if (state is ProjectLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (state is ProjectResponseState) {
              return state.getProjects.fold(
                  (l) => Text(l),
                  (root) => ListView(
                        children: [
                          DataTable(
                            dataTextStyle:
                                Theme.of(context).textTheme.titleMedium,
                            headingTextStyle:
                                Theme.of(context).textTheme.titleSmall,
                            columns: const [
                              DataColumn(
                                label: Text('نام طرح'),
                              ),
                              DataColumn(
                                label: Text('مشاهده نظرات'),
                              ),
                            ],
                            rows: state.getProjects.fold((l) => [], (projects) {
                              return projects.projects.map((project) {
                                return DataRow(cells: [
                                  DataCell(Text(project.title)),
                                  DataCell(
                                    TextButton(
                                      child: const Text('مشاهده'),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return BlocProvider(
                                                create: (context) =>
                                                    CommentBloc(),
                                                child: CommentScreen(project),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]);
                              }).toList();
                            }),
                          ),
                        ],
                      ));
            }
            return Container();
          }
        }),
      ),
    );
  }
}

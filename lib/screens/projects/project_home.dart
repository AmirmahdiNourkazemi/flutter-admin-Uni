import 'package:admin_smartfunding/bloc/ProjectBloc/create_project/create_project_bloc.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/create_project/create_project_event.dart';
import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/constant/scheme.dart';
import 'package:admin_smartfunding/screens/home/home_screen.dart';
import 'package:admin_smartfunding/screens/projects/create_project.dart';
import 'package:admin_smartfunding/screens/projects/update_project.dart';
import 'package:admin_smartfunding/screens/projects/upload_media.dart';
import 'package:admin_smartfunding/utils/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/ProjectBloc/delete_media/delete_media_bloc.dart';
import '../../bloc/ProjectBloc/delete_media/delete_media_event.dart';
import '../../bloc/ProjectBloc/edit_project/edit_project_bloc.dart';
import '../../bloc/ProjectBloc/edit_project/edit_project_event.dart';
import '../../bloc/ProjectBloc/projects/project_bloc.dart';
import '../../bloc/ProjectBloc/projects/project_event.dart';
import '../../bloc/ProjectBloc/projects/project_state.dart';
import '../../bloc/ProjectBloc/upload_media/upload_media_bloc.dart';
import '../../bloc/ProjectBloc/upload_media/upload_media_event.dart';
import '../../responsive/responsive.dart';
import '../../utils/phosphor_icon.dart';
import 'delete_media_screen.dart';

class ProjectHome extends StatefulWidget {
  const ProjectHome({super.key});

  @override
  State<ProjectHome> createState() => _ProjectHomeState();
}

class _ProjectHomeState extends State<ProjectHome> {
  @override
  void initState() {
    BlocProvider.of<ProjectBloc>(context).add(ProjectStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
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
          title: Text(
            'مدیریت طرح ها',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: 'اضافه کردن طرح',
            isExtended: true,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) {
                        CreateProjectBloc bloc = CreateProjectBloc();
                        bloc.add(CreateProjectStartEvent());
                        return bloc;
                      },
                    ),
                  ],
                  child: const CreateProject(),
                );
              }));
            },
            child: const Icon(Icons.add)),
        body: BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, state) {
            if (state is ProjectLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (state is ProjectResponseState) {
                return state.getProjects.fold(
                  (l) => Text(l),
                  (projects) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isDesktop(context) ? 30 : 10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isDesktop(context) ? 3 : 1,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          childAspectRatio:
                              Responsive.isDesktop(context) ? 1.1 : 0.9),
                      itemCount: projects.projects.length,
                      itemBuilder: (context, index) {
                        final project = projects.projects[index];

                        return Card(
                          // Customize the Card as needed
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Container(
                                  child: project.images.isNotEmpty
                                      ? CachedImage(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          height: 200,
                                          imageUrl:
                                              project.images[0].originalUrl,
                                          bottomRightradious: 10,
                                          bottomLeftradious: 10,
                                          topLeftradious: 10,
                                          topRightradious: 10,
                                          // height: 50,
                                          // width:
                                          //     MediaQuery.of(context).size.width *
                                          //         (Responsive.isDesktop(context)
                                          //             ? 0.8
                                          //             : 0.6),
                                        )
                                      : const Text('عکسی موجود نیست'),
                                ),
                              ),
                              Text(
                                'نام طرح: ${project.title}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                ' مبلغ مورد نیاز: ${project.fundNeeded.toString().seRagham().toPersianDigit()}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'وضعیت طرح: ',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  project.status == 1
                                      ? Text(
                                          'باز',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        )
                                      : Text(
                                          'بسته',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider(
                                              create: (context) {
                                                final UploadMediaBloc bloc =
                                                    UploadMediaBloc();
                                                bloc.add(
                                                    UploadMediaStartEvent());
                                                return bloc;
                                              },
                                              child: UploadMediaScreen(
                                                  project.uuid),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    icon: buildPhosphorIcon(
                                        PhosphorIconsBold.upload),
                                    label: Text(
                                      'آپلود مدیا',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return BlocProvider(
                                            create: (context) {
                                              final DeleteMediaBloc bloc =
                                                  DeleteMediaBloc();
                                              bloc.add(DeleteMediaStartEvent());
                                              return bloc;
                                            },
                                            child: DeleteMediaScreen(project),
                                          );
                                        }),
                                      );
                                    },
                                    icon: buildPhosphorIcon(
                                        PhosphorIconsBold.trash),
                                    label: Text(
                                      'حذف مدیا',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      _dialogForShowOrHidden(context,context,project.uuid,project.title , project.deletedAt);
                                      // if (project.deletedAt == null) {
                                      //   BlocProvider.of<ProjectBloc>(context)
                                      //       .add(ProjectDeleteEvent(
                                      //           project.uuid));
                                      // } else {
                                      //   BlocProvider.of<ProjectBloc>(context)
                                      //       .add(ProjectRestoreEvent(
                                      //           project.uuid));
                                      // }
                                    },
                                    icon: project.deletedAt == null
                                        ? buildPhosphorIcon(
                                            PhosphorIconsBold.eyeSlash)
                                        : buildPhosphorIcon(
                                            PhosphorIconsBold.eye),
                                    label: Text(
                                      project.deletedAt == null
                                          ? 'مخفی شدن طرح'
                                          : 'بازگردانی طرح',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return MultiBlocProvider(
                                              providers: [
                                                BlocProvider(
                                                  create: (context) {
                                                    final EditProjectBloc bloc =
                                                        EditProjectBloc();
                                                    bloc.add(
                                                        EditProjectStartEvent());
                                                    return bloc;
                                                  },
                                                ),
                                              ],
                                              child: UpdateProject(project),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    icon: buildPhosphorIcon(
                                        PhosphorIconsBold.pencilSimple),
                                    label: Text(
                                      'ادیت طرح',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context,
                                          context, project.uuid, project.title);
                                    },
                                    icon: buildPhosphorIcon(
                                        PhosphorIconsBold.eraser),
                                    label: Text(
                                      'حذف طرح',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return Container();
            }
          },
        ),
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext dialogContext,
    BuildContext blocContext, String projectId, String name) {
  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          icon: PhosphorIcon(
            PhosphorIcons.warning(),
            color: AppColorScheme.primaryColor,
          ),
          title: Text(name),
          content: Text('آیا میخواهید حذف کنید؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                BlocProvider.of<ProjectBloc>(blocContext)
                    .add(ProjectDeleteForceEvent(projectId));
              },
              child: Text('بله'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('خیر'),
            ),
          ],
        ),
      );
    },
  );
}

void _dialogForShowOrHidden(BuildContext dialogContext,BuildContext blocContext, String projectId,
    String name, String? deletedAt) {
  showDialog(
    context: dialogContext,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          icon: PhosphorIcon(
            PhosphorIcons.warning(),
            color: AppColorScheme.primaryColor,
          ),
          title: Text(name),
          content: deletedAt == null
              ? Text('آیا میخواهید طرح مخفی شود؟')
              : Text('آیا میخواهید طرح نمایش داده شود؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (deletedAt == null) {
                  BlocProvider.of<ProjectBloc>(blocContext)
                      .add(ProjectDeleteEvent(projectId));
                } else {
                  BlocProvider.of<ProjectBloc>(blocContext)
                      .add(ProjectRestoreEvent(projectId));
                }
              },
              child: Text('بله'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('خیر'),
            ),
          ],
        ),
      );
    },
  );
}

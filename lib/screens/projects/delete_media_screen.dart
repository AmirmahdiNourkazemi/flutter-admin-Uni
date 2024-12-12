import 'package:admin_smartfunding/constant/scheme.dart';
import 'package:admin_smartfunding/screens/projects/project_home.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../bloc/ProjectBloc/delete_media/delete_media_state.dart';
import '../../../../utils/cache_image.dart';
import '../../bloc/ProjectBloc/delete_media/delete_media_bloc.dart';
import '../../bloc/ProjectBloc/delete_media/delete_media_event.dart';
import '../../bloc/ProjectBloc/projects/project_bloc.dart';
import '../../data/model/projects/projects.dart';
import '../../responsive/responsive.dart';

class DeleteMediaScreen extends StatefulWidget {
  Project _project;
  DeleteMediaScreen(this._project, {super.key});

  @override
  State<DeleteMediaScreen> createState() => _DeleteMediaScreenState();
}

class _DeleteMediaScreenState extends State<DeleteMediaScreen>
    with TickerProviderStateMixin {
  @override
  late CustomVideoPlayerController _customVideoPlayerController;

  late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);
  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteMediaBloc, DeleteMediaState>(
      listener: (context, state) {
        if (state is DeleteMediaResponseState) {
          state.response.fold(
            (error) {
              print(error);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (success) {
              //print(success);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider(
                    create: (context) => ProjectBloc(),
                    child: const ProjectHome(),
                  ),
                ),
              );
              // Navigator.pop(context);
            },
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            //backgroundColor: cardBackgroundColor,
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => ProjectBloc(),
                        child: const ProjectHome(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          body: CustomScrollView(
            slivers: [
              if (widget._project.images!.isNotEmpty) ...{
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final image = widget._project.images![index];
                      if (widget._project.images!.isNotEmpty) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      BlocProvider.of<DeleteMediaBloc>(context)
                                          .add(
                                        DeleteMediaRequestEvent(
                                          widget._project.uuid!,
                                          widget._project.images![index].uuid,
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Responsive.isDesktop(context)
                                        ? 324
                                        : 200,
                                    height: 200,
                                    child: CachedImage(
                                      imageUrl: image.originalUrl,
                                    ),
                                  ),
                                  if (!Responsive.isMobile(context))
                                    Text(
                                      widget._project.images![index].name,
                                      style: const TextStyle(fontFamily: 'IR'),
                                    ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      } else {
                        // Return an empty container for null elements
                        return Container(
                          child: const Center(
                            child:
                                Text("هیچ عکسی برای این پروژه اضافه نشده است."),
                          ),
                        );
                      }
                    },
                    childCount: widget._project.images!.length,
                  ),
                ),
              } else ...{
                SliverToBoxAdapter(
                  child: Container(
                    child: const Center(
                      child: Text("هیچ عکسی برای این پروژه اضافه نشده است."),
                    ),
                  ),
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}

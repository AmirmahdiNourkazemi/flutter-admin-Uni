// import 'package:admin_smartfunding/constant/scheme.dart';
// import 'package:admin_smartfunding/screens/projects/project_home.dart';
// import 'package:appinio_video_player/appinio_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../../bloc/ProjectBloc/delete_media/delete_media_state.dart';
// import '../../../../utils/cache_image.dart';
// import '../../bloc/ProjectBloc/delete_media/delete_media_bloc.dart';
// import '../../bloc/ProjectBloc/delete_media/delete_media_event.dart';
// import '../../bloc/ProjectBloc/projects/project_bloc.dart';
// import '../../data/model/projects/projects.dart';
// import '../../responsive/responsive.dart';

// class DeleteMediaScreen extends StatefulWidget {
//   Project _project;
//   DeleteMediaScreen(this._project, {super.key});

//   @override
//   State<DeleteMediaScreen> createState() => _DeleteMediaScreenState();
// }

// class _DeleteMediaScreenState extends State<DeleteMediaScreen>
//     with TickerProviderStateMixin {
//   @override
 
//   late CustomVideoPlayerController _customVideoPlayerController;

//   late CustomVideoPlayerWebController _customVideoPlayerWebController;

//   final CustomVideoPlayerSettings _customVideoPlayerSettings =
//       const CustomVideoPlayerSettings(showSeekButtons: true);
//   late final TabController _tabController;


//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<DeleteMediaBloc, DeleteMediaState>(
//       listener: (context, state) {
//         if (state is DeleteMediaResponseState) {
//           state.response.fold(
//             (error) {
//               print(error);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(error),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             },
//             (success) {
//               //print(success);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(success),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => BlocProvider(
//                     create: (context) => ProjectBloc(),
//                     child: const ProjectHome(),
//                   ),
//                 ),
//               );
//               // Navigator.pop(context);
//             },
//           );
//         }
//       },
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: DefaultTabController(
//           length: 3,
//           initialIndex: 0,
//           child: Scaffold(
//             appBar: AppBar(
//               //backgroundColor: cardBackgroundColor,
//               automaticallyImplyLeading: false,
//               leading: IconButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (BuildContext context) => BlocProvider(
//                           create: (context) => ProjectBloc(),
//                           child: const ProjectHome(),
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.arrow_back)),
//             ),
//             body: Column(
//               children: [
//                 TabBar(
//                   controller: _tabController,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   dividerColor: Colors.grey[100],
//                   labelColor: Colors.white,
//                   indicator: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: AppColorScheme.primaryColor),
//                   //  labelColor: Colors.black,
//                   // indicatorPadding: EdgeInsets.symmetric(
//                   //     horizontal: Responsive.isDesktop(context) ? 30 : 10),
//                   indicatorColor: AppColorScheme.primaryColor,

//                   // labelStyle: const TextStyle(
//                   //     color: Colors.white,
//                   //     fontWeight: FontWeight.bold,
//                   //     fontFamily: 'IR',
//                   //     fontSize: 14),
//                   // unselectedLabelStyle: const TextStyle(
//                   //   fontFamily: 'IR',
//                   //   color: Colors.white,
//                   //   fontWeight: FontWeight.bold,
//                   // ),
//                   tabs: const [
                
//                     Tab(text: 'عکس ها'),
//                     Tab(text: 'فایل ها'),
//                     Tab(text: 'قرارداد'),
//                   ],
//                 ),
//                 Expanded(
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
                      
//                       images(
//                         widget: widget,
//                       ),
//                       file(
//                         widget: widget,
//                       ),
//                       contract(widget: widget),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// class file extends StatelessWidget {
//   const file({super.key, required this.widget});
//   final DeleteMediaScreen widget;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(Responsive.isDesktop(context) ? 40 : 10),
//       child: Container(
//         decoration: BoxDecoration(
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.grey.withOpacity(0.5),
//           //     spreadRadius: 2,
//           //     blurRadius: 5,
//           //     offset: Offset(0, 3),
//           //   ),
//           // ],
//           // color: containerColor,
//           border: Border.all(
//             width: 1,
//             color: Colors.white24,
//           ),
//           borderRadius: const BorderRadius.all(
//             Radius.circular(10),
//           ),
//         ),
//         child: CustomScrollView(
//           slivers: [
//             if (widget._project.attachments.length > 0) ...{
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     final attachment = widget._project.attachments[index];
//                     if (widget._project.attachments.length > 0) {
//                       return Column(
//                         children: [
//                           ListTile(
//                             contentPadding: EdgeInsets.all(20),
//                             leading: IconButton(
//                                 onPressed: () {
//                                   BlocProvider.of<DeleteMediaBloc>(context).add(
//                                     DeleteMediaRequestEvent(
//                                       widget._project.uuid,
//                                       attachment.uuid,
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 )),
//                             title: TextButton.icon(
//                               label: Text(
//                                 attachment.name,
//                                 textDirection: TextDirection.rtl,
//                                 textAlign: TextAlign.right,
//                               ),
//                               onPressed: () async {
//                                 if (!await launchUrl(
//                                     Uri.parse(attachment.originalUrl))) {
//                                   throw Exception('Could not launch');
//                                 }
//                               },
//                               icon: const Icon(Icons.picture_as_pdf_rounded),
//                             ),
//                           ),
//                           const Divider()
//                         ],
//                       );
//                     }
//                   },
//                   childCount: widget._project.attachments.length,
//                 ),
//               ),
//             } else ...{
//               SliverToBoxAdapter(
//                 child: Container(
//                   child: const Center(
//                     child: Text("هیچ فایلی برای این پروژه اضافه نشده است."),
//                   ),
//                 ),
//               )
//             }
//           ],
//         ),
//       ),
//     );
//   }
// }
// class contract extends StatelessWidget {
//   const contract({super.key, required this.widget});
//   final DeleteMediaScreen widget;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(Responsive.isDesktop(context) ? 40 : 10),
//       child: Container(
//         decoration: BoxDecoration(
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.grey.withOpacity(0.5),
//           //     spreadRadius: 2,
//           //     blurRadius: 5,
//           //     offset: Offset(0, 3),
//           //   ),
//           // ],
//           // color: containerColor,
//           border: Border.all(
//             width: 1,
//             color: Colors.white24,
//           ),
//           borderRadius: const BorderRadius.all(
//             Radius.circular(10),
//           ),
//         ),
//         child: CustomScrollView(
//           slivers: [
//             if (widget._project.contract != null) ...{
              
//               SliverToBoxAdapter(
//                 child: Column(
//                         children: [
//                           ListTile(
//                             contentPadding: EdgeInsets.all(20),
//                             leading: IconButton(
//                                 onPressed: () {
//                                   BlocProvider.of<DeleteMediaBloc>(context).add(
//                                     DeleteMediaRequestEvent(
//                                       widget._project.uuid,
//                                       widget._project.contract!.uuid,
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 )),
//                             title: TextButton.icon(
//                               label: Text(
//                                 widget._project.contract!.name,
//                                 textDirection: TextDirection.rtl,
//                                 textAlign: TextAlign.right,
//                               ),
//                               onPressed: () async {
//                                 if (!await launchUrl(
//                                     Uri.parse(widget._project.contract!.originalUrl))) {
//                                   throw Exception('Could not launch');
//                                 }
//                               },
//                               icon: const Icon(Icons.picture_as_pdf_rounded),
//                             ),
//                           ),
//                           const Divider()
//                         ],
//                       ),
//               )
//             } else ...{
//               SliverToBoxAdapter(
//                 child: Container(
//                   child: const Center(
//                     child: Text("هیچ قراردادی برای این پروژه اضافه نشده است."),
//                   ),
//                 ),
//               )
//             }
//           ],
//         ),
//       ),
//     );
//   }
// }
// class images extends StatefulWidget {
//   const images({
//     super.key,
//     required this.widget,
//   });

//   final DeleteMediaScreen widget;

//   @override
//   State<images> createState() => _imagesState();
// }

// class _imagesState extends State<images> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(Responsive.isDesktop(context) ? 40 : 10),
//       child: Container(
//         decoration: BoxDecoration(
//           // boxShadow: [
//           //   BoxShadow(
//           //     color: Colors.grey.withOpacity(0.5),
//           //     spreadRadius: 2,
//           //     blurRadius: 5,
//           //     offset: Offset(0, 3),
//           //   ),
//           // ],
//           // color: containerColor,
//           border: Border.all(
//             width: 1,
//             color: Colors.white24,
//           ),
//           borderRadius: const BorderRadius.all(
//             Radius.circular(10),
//           ),
//         ),
//         child: CustomScrollView(
//           slivers: [
//             if (widget.widget._project.images.length > 0) ...{
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     final image = widget.widget._project.images[index];
//                     if (widget.widget._project.images.length > 0) {
//                       return Column(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     BlocProvider.of<DeleteMediaBloc>(context)
//                                         .add(
//                                       DeleteMediaRequestEvent(
//                                         widget.widget._project.uuid,
//                                         widget
//                                             .widget._project.images[index].uuid,
//                                       ),
//                                     );
//                                   },
//                                   icon: const Icon(
//                                     Icons.delete,
//                                     size: 30,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width:
//                                       Responsive.isDesktop(context) ? 324 : 200,
//                                   height: 200,
//                                   child: CachedImage(
//                                     imageUrl: image.originalUrl,
//                                   ),
//                                 ),
//                                 if (!Responsive.isMobile(context))
//                                   Text(
//                                     widget.widget._project.images[index].name,
//                                     style: const TextStyle(fontFamily: 'IR'),
//                                   ),
//                               ],
//                             ),
//                           ),
//                           Divider(),
//                         ],
//                       );
//                     } else {
//                       // Return an empty container for null elements
//                       return Container(
//                         child: const Center(
//                           child:
//                               Text("هیچ عکسی برای این پروژه اضافه نشده است."),
//                         ),
//                       );
//                     }
//                   },
//                   childCount: widget.widget._project.images.length,
//                 ),
//               ),
//             } else ...{
//               SliverToBoxAdapter(
//                 child: Container(
//                   child: const Center(
//                     child: Text("هیچ عکسی برای این پروژه اضافه نشده است."),
//                   ),
//                 ),
//               )
//             }
//           ],
//         ),
//       ),
//     );
//   }
// }

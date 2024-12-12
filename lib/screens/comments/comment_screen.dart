import 'package:admin_smartfunding/comment/comment_bloc.dart';
import 'package:admin_smartfunding/comment/comment_event.dart';
import 'package:admin_smartfunding/data/model/projects/projects.dart';
import 'package:admin_smartfunding/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../comment/comment_state.dart';
import '../../constant/scheme.dart';

class CommentScreen extends StatefulWidget {
  final Project _project;
  const CommentScreen(this._project, {super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CommentBloc>(context)
        .add(CommentGetEvent(widget._project.uuid!));
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
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return BlocProvider(
          //             create: (context) => MetabaseBloc(),
          //             child: const HomeScreen(),
          //           );
          //         },
          //       ),
          //     );
          //   },
          //   icon: buildPhosphorIcon(
          //       PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
          //       size: 28),
          // ),
        ),
        body: ListView(
          children: [
            BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                if (state is CommentLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
                }
                if (state is CommentResponseState) {
                  return state.getComments.fold((l) => Text(l), (r) {
                    if (r.data!.isNotEmpty) {
                      return DataTable(
                        dataTextStyle: Theme.of(context).textTheme.titleMedium,
                        headingTextStyle:
                            Theme.of(context).textTheme.titleSmall,
                        checkboxHorizontalMargin: 2.0,
                        dataRowHeight: 90,
                        columnSpacing: 25,
                        showBottomBorder: true,
                        columns: const [
                          DataColumn(label: Text('شماره تیکت')),
                          DataColumn(label: Text('تاریخ ساخت')),
                          DataColumn(label: Text('نام')),
                          DataColumn(label: Text('نظر')),
                          DataColumn(label: Text('وضعیت')),
                          DataColumn(label: Text('تغییر وضعیت')),
                        ],
                        rows: r.data!.expand(
                          (comment) {
                            return [
                              if (comment.replies != []) ...[
                                DataRow(cells: [
                                  DataCell(
                                      Container()), // Empty cell for alignment
                                  DataCell(
                                      Container()), // Empty cell for alignment
                                  DataCell(
                                      Container()), // Empty cell for alignment
                                  DataCell(Text(
                                    'نظر:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(
                                      Container()), // Empty cell for alignment
                                  DataCell(
                                      Container()), // Empty cell for alignment
                                ]),
                                DataRow(cells: [
                                  DataCell(Text(
                                      comment.id.toString().toPersianDigit())),
                                  DataCell(
                                    Text(
                                      comment.createdAt.toPersianDate(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      comment.user.fullName!,
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      comment.body,
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      comment.verified
                                          ? 'تایید شده'
                                          : 'تایید نشده',
                                      softWrap: true,
                                      style: TextStyle(
                                          color: comment.verified
                                              ? Colors.blue
                                              : Colors.red,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 12.0
                                                  : 10.0,
                                          fontFamily: 'IR',
                                          fontWeight: FontWeight.w400
                                          // Other properties...
                                          ),
                                    ),
                                  ),
                                  DataCell(ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: comment.verified
                                            ? Colors.grey
                                            : null),
                                    child: Text(
                                      'تغییر وضعیت',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    onPressed: () {
                                      comment.verified == false
                                          ? BlocProvider.of<CommentBloc>(
                                                  context)
                                              .add(CommentChangeVerifyEvent(
                                                  widget._project.uuid!,
                                                  comment.uuid))
                                          : null;
                                    },
                                  ))
                                ]),
                                if (comment.replies!.isNotEmpty) ...[
                                  DataRow(cells: [
                                    DataCell(
                                        Container()), // Empty cell for alignment
                                    DataCell(
                                        Container()), // Empty cell for alignment
                                    DataCell(
                                        Container()), // Empty cell for alignment
                                    DataCell(Text(
                                      'پاسخ‌ها:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataCell(
                                        Container()), // Empty cell for alignment
                                    DataCell(
                                        Container()), // Empty cell for alignment
                                  ]),
                                  ...?comment.replies?.map((reply) {
                                    return DataRow(cells: [
                                      DataCell(Text(reply.id
                                          .toString()
                                          .toPersianDigit())), // Empty cell for alignment
                                      DataCell(
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text(
                                            reply.createdAt.toPersianDate(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text(
                                            reply.user.fullName ?? '',
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Text(
                                            reply.body,
                                            softWrap: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            maxLines: null,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          reply.verified
                                              ? 'تایید شده'
                                              : 'تایید نشده',
                                          softWrap: true,
                                          style: TextStyle(
                                            color: reply.verified
                                                ? Colors.blue
                                                : Colors.red,
                                            fontSize: 12.0,
                                            fontFamily: 'IR',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      DataCell(ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: reply.verified
                                                ? Colors.grey
                                                : null),
                                        child: Text(
                                          'تغییر وضعیت',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        onPressed: () {
                                          reply.verified == false
                                              ? BlocProvider.of<CommentBloc>(
                                                      context)
                                                  .add(CommentChangeVerifyEvent(
                                                      widget._project.uuid!,
                                                      reply.uuid))
                                              : null;
                                        },
                                      )),
                                    ]);
                                  }).toList(),
                                ]
                              ]
                            ];
                          },
                        ).toList(),
                      );
                    } else {
                      return Center(
                          child: Text(
                        ' هیچ نظری برای این طرح وجود ندارد',
                        style: Theme.of(context).textTheme.titleMedium,
                      ));
                    }
                  });
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

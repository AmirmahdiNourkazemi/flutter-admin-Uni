import 'dart:js_interop';

import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/constant/scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../bloc/ticket/get_Ticket/ticket_event.dart';
import '../../bloc/ticket/get_Ticket/ticket_bloc.dart';
import '../../bloc/ticket/get_Ticket/ticket_state.dart';
import '../../responsive/responsive.dart';
import '../../utils/phosphor_icon.dart';
import '../home/home_screen.dart';
import 'answer_ticket.dart';

class TicketDatalist extends StatefulWidget {
  //final Pagination _pagination;
  const TicketDatalist({super.key});

  @override
  State<TicketDatalist> createState() => _TicketDatalistState();
}

class _TicketDatalistState extends State<TicketDatalist> {
  int selectedValue = 5;
  int selectedChangeStatusValue = 1;
  int? categoryValue;
  int? statusValue;
  final _searchController = TextEditingController();
  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(
          value: 3,
          child: Text(
            "3".toPersianDigit(),
            style: Theme.of(context).textTheme.titleSmall,
          )),
      DropdownMenuItem(
          value: 5,
          child: Text(
            "5".toPersianDigit(),
            style: Theme.of(context).textTheme.titleSmall,
          )),
      DropdownMenuItem(
          value: 10,
          child: Text(
            "10".toPersianDigit(),
            style: Theme.of(context).textTheme.titleSmall,
          )),
      DropdownMenuItem(
          value: 20,
          child: Text(
            "20".toPersianDigit(),
            style: Theme.of(context).textTheme.titleSmall,
          )),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<int>> get categoryItems {
    List<DropdownMenuItem<int>> categoryItems = [
      DropdownMenuItem(
        value: null,
        child: Text(
          "همه",
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      DropdownMenuItem(
        value: 1,
        child:
            Text("پشتیبانی فنی", style: Theme.of(context).textTheme.titleSmall),
      ),
      DropdownMenuItem(
        value: 2,
        child: Text("پشتیبانی فروش",
            style: Theme.of(context).textTheme.titleSmall),
      ),
      DropdownMenuItem(
        value: 3,
        child: Text("ثبت تخلف", style: Theme.of(context).textTheme.titleSmall),
      ),
    ];
    return categoryItems;
  }

  List<DropdownMenuItem<int>> get stausItems {
    List<DropdownMenuItem<int>> stausItems = [
      DropdownMenuItem(
        value: null,
        child: Text("همه", style: Theme.of(context).textTheme.titleSmall),
      ),
      DropdownMenuItem(
        value: 1,
        child: Text("جدید", style: Theme.of(context).textTheme.titleSmall),
      ),
      DropdownMenuItem(
        value: 2,
        child: Text("پاسخ داده شده",
            style: Theme.of(context).textTheme.titleSmall),
      ),
      DropdownMenuItem(
        value: 3,
        child: Text("بسته شده", style: Theme.of(context).textTheme.titleSmall),
      ),
    ];
    return stausItems;
  }

  List<DropdownMenuItem<int>> get dropdownChangeStatusItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(
          value: 1,
          child: Text("جدید".toPersianDigit(),
              style: Theme.of(context).textTheme.titleSmall)),
      DropdownMenuItem(
          value: 2,
          child: Text("پاسخ داده شده".toPersianDigit(),
              style: Theme.of(context).textTheme.titleSmall)),
      DropdownMenuItem(
          value: 3,
          child: Text("بسته".toPersianDigit(),
              style: Theme.of(context).textTheme.titleSmall)),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketBloc, TicketState>(
      listener: (context, state) {
        if (state is GetTicketResponseState) {
          state.getTicket.fold(
            (l) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l),
                  backgroundColor: Colors.red,
                ),
              );
            },
            (r) {
              if (r.messages != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => TicketBloc(),
                        child: AnswerScreen(r),
                      );
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                    content: Text(
                      'پیامی دریافت نشده است',
                      style: TextStyle(fontFamily: 'IR'),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
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
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'تیکت ها',
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  // color: containerColor,
                  border: Border.all(
                    width: 1,
                    color: Colors.white24,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: BlocBuilder<TicketBloc, TicketState>(
                  builder: (context, state) {
                    return Column(
                      //  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is TicketLoadingState) ...{
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppColorScheme.primaryColor,
                            ),
                          )
                        } else ...{
                          if (state is TicketResponseState) ...{
                            state.getTicket.fold(
                              (l) => Center(
                                child: Row(
                                  children: [
                                    Text(l),
                                    ElevatedButton(
                                      onPressed: () {
                                        BlocProvider.of<TicketBloc>(context)
                                            .add(TicketStartEvent());
                                      },
                                      child: Text('تلاش مجدد'),
                                    ),
                                  ],
                                ),
                              ),
                              (ticketReponse) {
                                return Column(
                                  children: [
                                    LayoutBuilder(builder:
                                        (context, BoxConstraints constraints) {
                                      if (Responsive.isDesktop(context)) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: _searchController,
                                                  decoration: InputDecoration(
                                                    hintText: 'جستجو',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.blue),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 30.0,
                                                            vertical: 12.0),
                                                  ),
                                                  onSubmitted: (value) {
                                                    BlocProvider.of<TicketBloc>(
                                                            context)
                                                        .add(
                                                      TicketStartEvent(
                                                        category: categoryValue,
                                                        status: statusValue,
                                                        mobile: value
                                                            .toEnglishDigit(),
                                                      ),
                                                    );
                                                    if (value.isEmpty) {
                                                      BlocProvider.of<
                                                                  TicketBloc>(
                                                              context)
                                                          .add(
                                                              TicketStartEvent());
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                      //  color: scafoldCollor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: AppColorScheme
                                                              .primaryColor)),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      //dropdownColor: contrastColor,
                                                      items: categoryItems,

                                                      hint: Text(
                                                        'وضعیت پرداخت',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                      iconSize: 34,

                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17),
                                                      onChanged:
                                                          (int? newValue) {
                                                        categoryValue =
                                                            newValue;
                                                        setState(
                                                          () {
                                                            categoryValue =
                                                                newValue;
                                                          },
                                                        );
                                                        BlocProvider.of<
                                                                    TicketBloc>(
                                                                context)
                                                            .add(
                                                          TicketStartEvent(
                                                              perPage:
                                                                  ticketReponse
                                                                      .perPage,
                                                              category:
                                                                  categoryValue),
                                                        );
                                                      },
                                                      value: categoryValue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    // color: scafoldCollor,
                                                    border: Border.all(
                                                        color: AppColorScheme
                                                            .primaryColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      //dropdownColor: contrastColor,
                                                      items: stausItems,

                                                      hint: Text(
                                                        'وضعیت پروفایل',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                      iconSize: 34,
                                                      // focusColor: contrastColor,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17),
                                                      onChanged:
                                                          (int? newValue) {
                                                        statusValue = newValue;
                                                        setState(
                                                          () {
                                                            statusValue =
                                                                newValue;
                                                          },
                                                        );
                                                        BlocProvider.of<
                                                                    TicketBloc>(
                                                                context)
                                                            .add(
                                                          TicketStartEvent(
                                                              perPage:
                                                                  ticketReponse
                                                                      .perPage,
                                                              category:
                                                                  categoryValue,
                                                              status:
                                                                  statusValue),
                                                        );
                                                      },
                                                      value: statusValue,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: _searchController,
                                                decoration: InputDecoration(
                                                  hintText: 'جستجو',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.blue),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 30.0,
                                                          vertical: 12.0),
                                                ),
                                                onSubmitted: (value) {
                                                  BlocProvider.of<TicketBloc>(
                                                          context)
                                                      .add(
                                                    TicketStartEvent(
                                                      category: categoryValue,
                                                      status: statusValue,
                                                      mobile: value
                                                          .toEnglishDigit(),
                                                    ),
                                                  );
                                                  if (value.isEmpty) {
                                                    BlocProvider.of<TicketBloc>(
                                                            context)
                                                        .add(
                                                            TicketStartEvent());
                                                  }
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 55,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  // color: scafoldCollor,
                                                  border: Border.all(
                                                      color: AppColorScheme
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    padding: EdgeInsets.all(8),
                                                    iconEnabledColor:
                                                        Colors.black,
                                                    //dropdownColor: contrastColor,
                                                    items: categoryItems,

                                                    hint: Text(
                                                      'وضعیت پرداخت',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                    ),
                                                    iconSize: 34,
                                                    //focusColor: contrastColor,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17),
                                                    onChanged: (int? newValue) {
                                                      categoryValue = newValue;
                                                      setState(
                                                        () {
                                                          categoryValue =
                                                              newValue;
                                                        },
                                                      );
                                                      BlocProvider.of<
                                                                  TicketBloc>(
                                                              context)
                                                          .add(
                                                        TicketStartEvent(
                                                            perPage:
                                                                ticketReponse
                                                                    .perPage,
                                                            category:
                                                                categoryValue),
                                                      );
                                                    },
                                                    value: categoryValue,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 55,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  //  color: scafoldCollor,
                                                  border: Border.all(
                                                      color: AppColorScheme
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    padding: EdgeInsets.all(8),
                                                    iconEnabledColor:
                                                        Colors.black,
                                                    //dropdownColor: contrastColor,
                                                    items: stausItems,

                                                    hint: Text(
                                                      'وضعیت پروفایل',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall,
                                                    ),
                                                    iconSize: 34,
                                                    //focusColor: contrastColor,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17),
                                                    onChanged: (int? newValue) {
                                                      statusValue = newValue;
                                                      setState(
                                                        () {
                                                          statusValue =
                                                              newValue;
                                                        },
                                                      );
                                                      BlocProvider.of<
                                                                  TicketBloc>(
                                                              context)
                                                          .add(
                                                        TicketStartEvent(
                                                            perPage:
                                                                ticketReponse
                                                                    .perPage,
                                                            category:
                                                                categoryValue,
                                                            status:
                                                                statusValue),
                                                      );
                                                    },
                                                    value: statusValue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        dataTextStyle: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        headingTextStyle: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        checkboxHorizontalMargin: 2.0,
                                        dataRowHeight: 90,
                                        columnSpacing: 25,
                                        showBottomBorder: true,
                                        columns: const [
                                          DataColumn(label: Text('شماره تیکت')),
                                          DataColumn(label: Text('تاریخ ساخت')),
                                          DataColumn(label: Text('نام')),
                                          DataColumn(label: Text('عنوان')),
                                          DataColumn(label: Text('نوع')),
                                          DataColumn(label: Text('وضیت')),
                                          DataColumn(
                                              label: Text('تغییر وضعیت')),
                                        ],
                                        rows: ticketReponse.data.map(
                                          (ticket) {
                                            return DataRow(cells: [
                                              DataCell(Text(ticket.id
                                                  .toString()
                                                  .toPersianDigit())),
                                              DataCell(
                                                Text(
                                                  ticket.createdAt
                                                      .toPersianDate(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  ticket.user.fullName!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  ticket.title,
                                                  softWrap: true,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              if (ticket.category == 1) ...{
                                                DataCell(
                                                  Text(
                                                    'پشتیبانی فنی',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ),
                                              },
                                              if (ticket.category == 2) ...{
                                                DataCell(
                                                  Text(
                                                    'پشتیبانی فروش',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ),
                                              },
                                              if (ticket.category == 3) ...{
                                                DataCell(
                                                  Text(
                                                    'ثبت تخلف',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                ),
                                              },
                                              ticket.status == 1
                                                  ? DataCell(GestureDetector(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    TicketBloc>(
                                                                context)
                                                            .add(
                                                          GetTicketEvent(
                                                            ticket.uuid,
                                                          ),
                                                        );
                                                      },
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          BlocProvider.of<
                                                                      TicketBloc>(
                                                                  context)
                                                              .add(
                                                            GetTicketEvent(
                                                              ticket.uuid,
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          width: 110,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors
                                                                .green[600],
                                                          ),
                                                          child: const Center(
                                                            child: Text('جدید',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12)),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                  : ticket.status == 2
                                                      ? DataCell(
                                                          GestureDetector(
                                                            onTap: () {
                                                              BlocProvider.of<
                                                                          TicketBloc>(
                                                                      context)
                                                                  .add(
                                                                GetTicketEvent(
                                                                  ticket.uuid,
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              width: 120,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .blue[700],
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                    'پاسخ داده شده',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12)),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : DataCell(
                                                          GestureDetector(
                                                            onTap: () {
                                                              BlocProvider.of<
                                                                          TicketBloc>(
                                                                      context)
                                                                  .add(
                                                                GetTicketEvent(
                                                                  ticket.uuid,
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              width: 110,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Colors
                                                                    .red[700],
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'بسته شده',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                              DataCell(
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: AppColorScheme
                                                            .primaryColor),
                                                    //color: scafoldCollor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: DropdownButton(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),

                                                    iconEnabledColor:
                                                        Colors.black,
                                                    //dropdownColor: contrastColor,
                                                    items:
                                                        dropdownChangeStatusItems,

                                                    //focusColor: contrastColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14),
                                                    onChanged: (int? newValue) {
                                                      BlocProvider.of<
                                                                  TicketBloc>(
                                                              context)
                                                          .add(
                                                        ChangeTicketStatusEvent(
                                                          newValue!,
                                                          ticket.uuid,
                                                          page: ticketReponse
                                                              .currentPage!,
                                                          perPage: ticketReponse
                                                              .perPage,
                                                        ),
                                                      );
                                                    },
                                                    value: ticket.status,
                                                  ),
                                                ),
                                              )
                                            ]);
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          //disabledColor: Colors.grey,
                                          color:
                                              ticketReponse.nextPageUrl != null
                                                  ? Colors.black
                                                  : Colors.grey,
                                          onPressed: () {
                                            if (ticketReponse.nextPageUrl !=
                                                'null') {
                                              BlocProvider.of<TicketBloc>(
                                                      context)
                                                  .add(
                                                TicketStartEvent(
                                                    page: ticketReponse
                                                            .nextPageUrl!
                                                            .isNotEmpty
                                                        ? ticketReponse
                                                                .currentPage! +
                                                            1
                                                        : ticketReponse
                                                            .currentPage!,
                                                    perPage:
                                                        ticketReponse.perPage),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.navigate_before,
                                          ),
                                        ),
                                        Text(ticketReponse.currentPage
                                            .toString()
                                            .toPersianDigit()),
                                        IconButton(
                                          color:
                                              ticketReponse.prevPageUrl != null
                                                  ? Colors.black
                                                  : Colors.grey,
                                          onPressed: () {
                                            if (ticketReponse.prevPageUrl !=
                                                'null') {
                                              BlocProvider.of<TicketBloc>(
                                                      context)
                                                  .add(
                                                TicketStartEvent(
                                                  page: ticketReponse
                                                          .prevPageUrl!
                                                          .isNotEmpty
                                                      ? ticketReponse
                                                              .currentPage! -
                                                          1
                                                      : ticketReponse
                                                          .currentPage!,
                                                  perPage:
                                                      ticketReponse.perPage,
                                                ),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.navigate_next,
                                          ),
                                        ),
                                        if (ticketReponse.total != 1)
                                          DropdownButton(
                                            //iconEnabledColor: contrastColor,
                                            //dropdownColor: contrastColor,
                                            items: dropdownItems,
                                            //  focusColor: contrastColor,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            onChanged: (int? newValue) {
                                              //  selectedValue = newValue!;
                                              selectedValue = newValue!;
                                              setState(() {
                                                selectedValue = newValue;
                                              });
                                              BlocProvider.of<TicketBloc>(
                                                      context)
                                                  .add(
                                                TicketStartEvent(
                                                    perPage: newValue),
                                              );
                                            },
                                            value: ticketReponse.perPage != null
                                                ? ticketReponse.perPage
                                                : 1,
                                          ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            )
                          }
                        }
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

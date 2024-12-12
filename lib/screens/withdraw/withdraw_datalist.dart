import 'dart:js_interop';

import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/constant/scheme.dart';
import 'package:admin_smartfunding/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/withdraw/answer_withdraw/answer_withdraw_bloc.dart';
import '../../bloc/withdraw/get_withdraw/withdraw_bloc.dart';
import '../../responsive/responsive.dart';
import '../../utils/phosphor_icon.dart';
import 'answer_withdraw.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  int selectedValue = 5;
  int selectedChangeStatusValue = 1;
  int? categoryValue;
  int? statusValue;
  final _searchController = TextEditingController();
  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text("3".toPersianDigit()), value: 3),
      DropdownMenuItem(child: Text("5".toPersianDigit()), value: 5),
      DropdownMenuItem(child: Text("10".toPersianDigit()), value: 10),
      DropdownMenuItem(child: Text("20".toPersianDigit()), value: 20),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<int>> get stausItems {
    List<DropdownMenuItem<int>> stausItems = [
      DropdownMenuItem(
        value: null,
        child: Text("همه", style: Theme.of(context).textTheme.titleMedium),
      ),
      DropdownMenuItem(
        value: 1,
        child: Text("در حال بررسی",
            style: Theme.of(context).textTheme.titleMedium),
      ),
      DropdownMenuItem(
        value: 2,
        child:
            Text("پرداخت شده", style: Theme.of(context).textTheme.titleMedium),
      ),
      DropdownMenuItem(
        value: 3,
        child: Text("لغو شده", style: Theme.of(context).textTheme.titleMedium),
      ),
    ];
    return stausItems;
  }

  List<DropdownMenuItem<int>> get dropdownChangeStatusItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(
          value: 1,
          child: Text("در حال بررسی".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
      DropdownMenuItem(
          value: 2,
          child: Text("پرداخت شده".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
      DropdownMenuItem(
          value: 3,
          child: Text("لغو شده".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            title: Text('درخواست نقد شدن',
                style: Theme.of(context).textTheme.titleMedium),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider(
                          create: (context) => MetabaseBloc(),
                          child: BlocProvider(
                            create: (context) => MetabaseBloc(),
                            child: const HomeScreen(),
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: buildPhosphorIcon(PhosphorIconsBold.arrowLeft))),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.white24,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: BlocBuilder<WithdrawBloc, WithdrawState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if (state is WithdrawLoadingState) ...{
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColorScheme.primaryColor,
                        ),
                      )
                    } else ...{
                      if (state is WithdrawResponseState) ...{
                        state.getWithdraw.fold((l) => Text(l), (r) {
                          return Column(
                            children: [
                              LayoutBuilder(builder:
                                  (context, BoxConstraints constraints) {
                                if (Responsive.isDesktop(context)) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _searchController,
                                            decoration: InputDecoration(
                                              hintText: 'جستجو',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30.0,
                                                      vertical: 12.0),
                                            ),
                                            onSubmitted: (value) {
                                              BlocProvider.of<WithdrawBloc>(
                                                      context)
                                                  .add(
                                                WithdrawStartEvent(
                                                  status: statusValue,
                                                  mobile:
                                                      value.toEnglishDigit(),
                                                ),
                                              );
                                              if (value.isEmpty) {
                                                BlocProvider.of<WithdrawBloc>(
                                                        context)
                                                    .add(WithdrawStartEvent());
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
                                              border: Border.all(
                                                  color: AppColorScheme
                                                      .primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                iconEnabledColor: Colors.black,
                                                //dropdownColor: contrastColor,
                                                items: stausItems,

                                                hint: const Text(
                                                  'وضعیت',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 17),
                                                ),
                                                iconSize: 34,

                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17),
                                                onChanged: (int? newValue) {
                                                  statusValue = newValue;
                                                  setState(
                                                    () {
                                                      statusValue = newValue;
                                                    },
                                                  );
                                                  BlocProvider.of<WithdrawBloc>(
                                                          context)
                                                      .add(
                                                    WithdrawStartEvent(
                                                        per_page: r.perPage!,
                                                        status: statusValue),
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
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.blue),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 30.0,
                                                    vertical: 12.0),
                                          ),
                                          onSubmitted: (value) {
                                            BlocProvider.of<WithdrawBloc>(
                                                    context)
                                                .add(
                                              WithdrawStartEvent(
                                                status: statusValue,
                                                mobile: value.toEnglishDigit(),
                                              ),
                                            );
                                            if (value.isEmpty) {
                                              BlocProvider.of<WithdrawBloc>(
                                                      context)
                                                  .add(WithdrawStartEvent());
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 55,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColorScheme
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              padding: const EdgeInsets.all(8),
                                              iconEnabledColor: Colors.black,
                                              //dropdownColor: contrastColor,
                                              items: stausItems,

                                              hint: const Text(
                                                'وضعیت',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17),
                                              ),
                                              iconSize: 34,

                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17),
                                              onChanged: (int? newValue) {
                                                statusValue = newValue;
                                                setState(
                                                  () {
                                                    statusValue = newValue;
                                                  },
                                                );
                                                BlocProvider.of<WithdrawBloc>(
                                                        context)
                                                    .add(
                                                  WithdrawStartEvent(
                                                      mobile: _searchController
                                                          .text
                                                          .toString(),
                                                      per_page: r.perPage!,
                                                      status: statusValue),
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
                                  dataTextStyle:
                                      Theme.of(context).textTheme.titleSmall,
                                  headingTextStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                  checkboxHorizontalMargin: 2.0,
                                  dataRowHeight: 90,
                                  columnSpacing: 25,
                                  showBottomBorder: true,
                                  columns: const [
                                    DataColumn(label: Text('شماره')),
                                    DataColumn(label: Text('تاریخ درخواست')),
                                    DataColumn(label: Text('نام')),
                                    DataColumn(label: Text('نوع')),
                                    DataColumn(label: Text('کدملی')),
                                    DataColumn(label: Text('موبایل')),
                                    DataColumn(label: Text('کد پیگیری')),
                                    DataColumn(label: Text('تاریخ پرداخت')),
                                    DataColumn(label: Text('مقدار (تومان) ')),
                                    DataColumn(label: Text('شماره شبا')),
                                    DataColumn(label: Text('شماره حساب')),
                                    DataColumn(label: Text('وضیت')),
                                    DataColumn(label: Text('تغییر وضعیت')),
                                  ],
                                  rows: r.data!.map(
                                    (withdraw) {
                                      return DataRow(cells: [
                                        DataCell(Text(withdraw.id
                                            .toString()
                                            .toPersianDigit())),
                                        DataCell(
                                          Text(
                                            withdraw.createdAt.toPersianDate(),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            withdraw.user.fullName!,
                                          ),
                                        ),
                                        if (withdraw.user.type == 1) ...{
                                          const DataCell(
                                            Text('حقیقی'),
                                          ),
                                        },
                                        if (withdraw.user.type == 2) ...{
                                          const DataCell(
                                            Text('حقوقی'),
                                          ),
                                        },
                                        DataCell(
                                          Text(withdraw.user.nationalCode
                                              .toPersianDigit()),
                                        ),
                                        DataCell(
                                          Text(withdraw.user.mobile!),
                                        ),
                                        if (withdraw.refId == 'نامشخص') ...{
                                          const DataCell(Text('پرداخت نشده'))
                                        } else ...{
                                          DataCell(Text(withdraw.refId!))
                                        },
                                        if (withdraw.withdrawDate ==
                                            'نامشخص') ...{
                                          const DataCell(Text('پرداخت نشده'))
                                        } else ...{
                                          DataCell(Text(withdraw.withdrawDate!
                                              .toPersianDate()))
                                        },
                                        DataCell(Text(withdraw.amount
                                            .toString()
                                            .seRagham()
                                            .toPersianDigit())),
                                     if(withdraw.bankAccount != null)...{
                                         DataCell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: withdraw
                                                    .bankAccount!.iban!));
                                          },
                                          Text(
                                            withdraw.bankAccount!.iban ?? '',
                                            softWrap: true,
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                     } else ...{
                                           const  DataCell(
                                          Text( 
                                           'ندارد',
                                            softWrap: true,
                                            style:  TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                     },
                                          if(withdraw.bankAccount != null)...{
DataCell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: withdraw
                                                    .bankAccount!.number!));
                                          },
                                          Text(
                                           
                                            withdraw.bankAccount!.number!,
                                            softWrap: true,
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                          }else ...{
                                          const  DataCell(
                                          Text( 
                                           'ندارد',
                                            softWrap: true,
                                            style:  TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                          },
                                        
                                        withdraw.status == 1
                                            ? DataCell(GestureDetector(
                                                // onTap: () {
                                                //   BlocProvider.of<TicketBloc>(
                                                //           context)
                                                //       .add(
                                                //     GetTicketEvent(
                                                //       ticket.uuid,
                                                //     ),
                                                //   );
                                                // },
                                                child: GestureDetector(
                                                  // onTap: () {
                                                  //   BlocProvider.of<TicketBloc>(
                                                  //           context)
                                                  //       .add(
                                                  //     GetTicketEvent(
                                                  //       ticket.uuid,
                                                  //     ),
                                                  //   );
                                                  // },
                                                  child: Center(
                                                    child: Text('در حال بررسی',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .green[600],
                                                            fontSize: 12)),
                                                  ),
                                                ),
                                              ))
                                            : withdraw.status == 2
                                                ? DataCell(
                                                    GestureDetector(
                                                      // onTap: () {
                                                      //   BlocProvider.of<
                                                      //               TicketBloc>(
                                                      //           context)
                                                      //       .add(
                                                      //     GetTicketEvent(
                                                      //       ticket.uuid,
                                                      //     ),
                                                      //   );
                                                      // },
                                                      child: Center(
                                                        child: Text(
                                                            'پرداخت شده',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue[700],
                                                                fontSize: 12)),
                                                      ),
                                                    ),
                                                  )
                                                : DataCell(
                                                    GestureDetector(
                                                      // onTap: () {
                                                      //   BlocProvider.of<
                                                      //               TicketBloc>(
                                                      //           context)
                                                      //       .add(
                                                      //     GetTicketEvent(
                                                      //       ticket.uuid,
                                                      //     ),
                                                      //   );
                                                      // },
                                                      child: Center(
                                                        child: Text(
                                                          'لغو شده',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[700],
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                        DataCell(ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return BlocProvider(
                                                create: (context) =>
                                                    AnswerWithdrawBloc(),
                                                child: AnswerWithdraw(withdraw),
                                              );
                                            }));
                                          },
                                          child: Text('بررسی'),
                                        ))
                                      ]);
                                    },
                                  ).toList(),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    //disabledColor: Colors.grey,
                                    color: r.nextPageUrl != null
                                        ? Colors.black
                                        : Colors.grey,
                                    onPressed: () {
                                      if (!r.nextPageUrl!.isEmpty) {
                                        BlocProvider.of<WithdrawBloc>(context)
                                            .add(
                                          WithdrawStartEvent(
                                              per_page: r.perPage!,page: r.currentPage! + 1),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.navigate_before,
                                    ),
                                  ),
                                  Text(r.currentPage
                                      .toString()
                                      .toPersianDigit()),
                                  IconButton(
                                    color: r.prevPageUrl != null
                                        ? Colors.black
                                        : Colors.grey,
                                    onPressed: () {
                                      if (!r.prevPageUrl!.isEmpty) {
                                        BlocProvider.of<WithdrawBloc>(context)
                                            .add(
                                          WithdrawStartEvent(
                                            per_page: r.perPage!,
                                           page: r.currentPage! - 1
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.navigate_next,
                                    ),
                                  ),
                                  if (r.total != 1)
                                    DropdownButton(
                                      //iconEnabledColor: contrastColor,
                                      //dropdownColor: contrastColor,
                                      items: dropdownItems,
                                      //  focusColor: contrastColor,
                                      // style: TextStyle(
                                      //     color: contrastColor, fontSize: 17),
                                      onChanged: (int? newValue) {
                                        //  selectedValue = newValue!;
                                        selectedValue = newValue!;
                                        setState(() {
                                          selectedValue = newValue;
                                        });
                                        BlocProvider.of<WithdrawBloc>(context)
                                            .add(
                                          WithdrawStartEvent(
                                              per_page: newValue),
                                        );
                                      },
                                      value: r.perPage != null ? r.perPage : 1,
                                    ),
                                ],
                              )
                            ],
                          );
                        })
                      }
                    }
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

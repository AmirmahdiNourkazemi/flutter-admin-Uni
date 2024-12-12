import 'package:admin_smartfunding/bloc/deposit/deposit_bloc.dart';
import 'package:admin_smartfunding/bloc/deposit/deposit_event.dart';
import 'package:admin_smartfunding/bloc/deposit/deposit_state.dart';
import 'package:admin_smartfunding/screens/home/home_screen.dart';
import 'package:admin_smartfunding/utils/cache_image.dart';
import 'package:admin_smartfunding/utils/phosphor_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/metabase/metabase_bloc.dart';
import '../../constant/scheme.dart';
import '../../responsive/responsive.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  int selectedValue = 5;
  int selectedChangeStatusValue = 1;
  int? categoryValue;
  int? statusValue;
  final _searchController = TextEditingController();
  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(value: 3, child: Text("3".toPersianDigit())),
      DropdownMenuItem(value: 5, child: Text("5".toPersianDigit())),
      DropdownMenuItem(value: 10, child: Text("10".toPersianDigit())),
      DropdownMenuItem(value: 20, child: Text("20".toPersianDigit())),
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
            Text("تایید شده", style: Theme.of(context).textTheme.titleMedium),
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
          child: Text("تایید".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
      DropdownMenuItem(
          value: 3,
          child: Text("لغو".toPersianDigit(),
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
            title: Text('فیش های واریزی',
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
            child: BlocBuilder<DepositBloc, DepositState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if (state is DepositLoadingState) ...{
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColorScheme.primaryColor,
                        ),
                      )
                    } else ...{
                      if (state is DepositResponseState) ...{
                        state.getDeposit.fold((l) => Text(l), (r) {
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
                                              BlocProvider.of<DepositBloc>(
                                                      context)
                                                  .add(
                                                DepositStartEvent(
                                                    status: statusValue,
                                                    mobile:
                                                        value.toEnglishDigit(),
                                                    page: r.currentPage),
                                              );
                                              if (value.isEmpty) {
                                                BlocProvider.of<DepositBloc>(
                                                        context)
                                                    .add(DepositStartEvent());
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
                                                  BlocProvider.of<DepositBloc>(
                                                          context)
                                                      .add(
                                                    DepositStartEvent(
                                                      per_page: r.perPage,
                                                      status: statusValue,
                                                      page: r.currentPage,
                                                    ),
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
                                            BlocProvider.of<DepositBloc>(
                                                    context)
                                                .add(
                                              DepositStartEvent(
                                                  status: statusValue,
                                                  mobile:
                                                      value.toEnglishDigit(),
                                                  page: r.currentPage),
                                            );
                                            if (value.isEmpty) {
                                              BlocProvider.of<DepositBloc>(
                                                      context)
                                                  .add(DepositStartEvent());
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
                                                BlocProvider.of<DepositBloc>(
                                                        context)
                                                    .add(
                                                  DepositStartEvent(
                                                      mobile: _searchController
                                                          .text
                                                          .toString(),
                                                      per_page: r.perPage,
                                                      status: statusValue,
                                                      page: r.currentPage),
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
                                    DataColumn(label: Text('تصویر')),
                                    DataColumn(label: Text('شماره')),
                                    DataColumn(label: Text('تاریخ درخواست')),
                                    DataColumn(label: Text('نام')),
                                    DataColumn(label: Text('نوع')),
                                    DataColumn(label: Text('کدملی')),
                                    DataColumn(label: Text('نام طرح')),
                                    DataColumn(label: Text('موبایل')),
                                    DataColumn(label: Text('کد پیگیری')),
                                    DataColumn(label: Text('تاریخ پرداخت')),
                                    DataColumn(label: Text('مقدار (تومان) ')),
                                    DataColumn(label: Text('وضیت')),
                                    DataColumn(label: Text('تغییر وضعیت')),
                                  ],
                                  rows: r.data!.map(
                                    (withdraw) {
                                      return DataRow(cells: [
                                        DataCell(OutlinedButton(
                                          child: Text('تصویر'),
                                          onPressed: () {
                                            if (withdraw.image != null) {
                                              showDialog(
                                                  useSafeArea: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Container(
                                                        height: 200,
                                                        child: CachedImage(
                                                          imageUrl: withdraw
                                                              .image!
                                                              .originalUrl,
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                backgroundColor: Colors.red,
                                                content: const Text(
                                                    'عکسی از فیش موجود نیست'),
                                                action: SnackBarAction(
                                                  label: 'باشه',
                                                  onPressed: () {
                                                    // Code to execute.
                                                  },
                                                ),
                                              ));
                                            }
                                          },
                                        )),
                                        DataCell(Text(withdraw.id
                                            .toString()
                                            .toPersianDigit())),
                                        DataCell(
                                          Text(
                                            withdraw.createdAt.toPersianDate(),
                                          ),
                                        ),
                                        DataCell(
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: withdraw.user!.fullName
                                                      .toString()));
                                            },
                                            child: Text(
                                              withdraw.user!.fullName!,
                                            ),
                                          ),
                                        ),
                                        if (withdraw.user!.type == 1) ...{
                                          const DataCell(
                                            Text('حقیقی'),
                                          ),
                                        },
                                        if (withdraw.user!.type == 2) ...{
                                          const DataCell(
                                            Text('حقوقی'),
                                          ),
                                        },
                                        DataCell(
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: withdraw
                                                      .user!.nationalCode
                                                      .toString()));
                                            },
                                            child: Text(withdraw
                                                .user!.nationalCode!
                                                .toPersianDigit()),
                                          ),
                                        ),
                                        if (withdraw.project != null) ...[
                                          DataCell(
                                              Text(withdraw.project!.title))
                                        ] else ...[
                                          DataCell(Text('نامشخص'))
                                        ],
                                        DataCell(
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: withdraw.user!.mobile
                                                      .toString()));
                                            },
                                            child: Text(withdraw.user!.mobile!
                                                .toPersianDigit()),
                                          ),
                                        ),
                                        if (withdraw.refId == 'نامشخص') ...{
                                          const DataCell(Text('پرداخت نشده'))
                                        } else ...{
                                          DataCell(InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: withdraw.refId
                                                      .toString()));
                                            },
                                            child: Text(withdraw.refId!
                                                .toPersianDigit()),
                                          ))
                                        },
                                        if (withdraw.depositDate ==
                                            'نامشخص') ...{
                                          const DataCell(Text('پرداخت نشده'))
                                        } else ...{
                                          DataCell(Text(withdraw.depositDate!
                                              .toPersianDate()))
                                        },
                                        DataCell(Text(withdraw.amount
                                            .toString()
                                            .seRagham()
                                            .toPersianDigit())),
                                        withdraw.status == 1
                                            ? DataCell(Center(
                                                child: Text('در حال بررسی',
                                                    style: TextStyle(
                                                        color: Colors.blue[600],
                                                        fontSize: 12)),
                                              ))
                                            : withdraw.status == 2
                                                ? DataCell(
                                                    Center(
                                                      child: Text('تایید شده',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[700],
                                                              fontSize: 12)),
                                                    ),
                                                  )
                                                : DataCell(
                                                    Center(
                                                      child: Text(
                                                        'تایید نشده',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red[700],
                                                            fontSize: 12),
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
                                                  BorderRadius.circular(10),
                                            ),
                                            child: DropdownButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 5),

                                              iconEnabledColor: Colors.black,
                                              //dropdownColor: contrastColor,
                                              items: dropdownChangeStatusItems,

                                              //focusColor: contrastColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              onChanged: (int? newValue) {
                                                BlocProvider.of<DepositBloc>(
                                                        context)
                                                    .add(
                                                  ChangeDepositStatusEvent(
                                                      newValue!, withdraw.uuid,
                                                      page: r.currentPage,
                                                      perPage: r.perPage,
                                                      mobile: _searchController
                                                          .text),
                                                );
                                              },
                                              value: withdraw.status,
                                            ),
                                          ),
                                        )
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
                                        BlocProvider.of<DepositBloc>(context)
                                            .add(
                                          DepositStartEvent(
                                            per_page: r.perPage,
                                            page: r.currentPage + 1,
                                          ),
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
                                        BlocProvider.of<DepositBloc>(context)
                                            .add(
                                          DepositStartEvent(
                                            per_page: r.perPage!,
                                            page: r.currentPage - 1,
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
                                        BlocProvider.of<DepositBloc>(context)
                                            .add(
                                          DepositStartEvent(
                                              per_page: newValue,
                                              page: r.currentPage),
                                        );
                                      },
                                      value: r.perPage != null ? r.perPage : 1,
                                    ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(r.to.toString().toPersianDigit(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text('از'),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(r.total.toString().toPersianDigit(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium)
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

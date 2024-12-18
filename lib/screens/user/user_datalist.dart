import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_bloc.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_event.dart';
import 'package:admin_smartfunding/bloc/usersBloc/user/user_event.dart';
import 'package:admin_smartfunding/data/model/projects/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../bloc/usersBloc/pivot/pivot_bloc.dart';
import '../../bloc/usersBloc/pivot/pivot_event.dart';
import '../../bloc/usersBloc/pivot/pivot_state.dart';
import '../../bloc/usersBloc/user/user_bloc.dart';
import '../../bloc/usersBloc/user/user_state.dart';
import '../../constant/scheme.dart';
import '../../data/model/message_template/message_template.dart';
import 'asset_user.dart';

class UserDataList extends StatefulWidget {
  //UserResponse userResponse;
  UserDataList({super.key});

  @override
  State<UserDataList> createState() => _UserDataListState();
}

final _formKey = GlobalKey<FormState>();
final searchController = TextEditingController();
FToast? fToast;

class _UserDataListState extends State<UserDataList> {
  int selectedValue = 5;
  int? paidValue;
  int? profileValue;
  bool isPaidDroppDownPress = false;
  int? walletCheckbox;
  bool? walletBoolCheckbox = false;
  int? sellCheckbox;
  bool? selltBoolCheckbox = false;
  bool selectedComp = false;
  String? projectId;

  List<DropdownMenuItem<int>> get dropdownItems {
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(
          value: 3,
          child: Text("3".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
      DropdownMenuItem(
          value: 5,
          child: Text("5".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
      DropdownMenuItem(
          value: 10,
          child: Text("10".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
      DropdownMenuItem(
          value: 20,
          child: Text("20".toPersianDigit(),
              style: Theme.of(context).textTheme.titleMedium)),
    ];
    return menuItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    fToast = FToast();
    fToast!.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          final UsersBloc bloc = UsersBloc();
          bloc.add(UsersStartEvent());
          return bloc;
        },
        child: BlocConsumer<UsersBloc, UsersState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is UsersLoadingState) ...{
                          const CircularProgressIndicator(
                            color: AppColorScheme.primaryColor,
                          ),
                        } else ...{
                          if (state is UsersResponseState) ...[
                            state.getUsers.fold((l) {
                              return Text(l);
                            }, (userResponse) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DataTable(
                                      dataTextStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      headingTextStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      checkboxHorizontalMargin: 2.0,
                                      dataRowHeight: 90,
                                      columnSpacing: 25,
                                      columns: const [
                                        DataColumn(label: Text('نام')),
                                        DataColumn(label: Text('نوع')),
                                        DataColumn(label: Text('کد ملی')),
                                        DataColumn(label: Text('موبایل')),
                                        DataColumn(label: Text('تاریخ ساخت')),
                                        // DataColumn(label: Text('زمان ورود')),
                                      ],
                                      rows: userResponse.data.map(
                                        (users) {
                                          return DataRow(cells: [
                                            DataCell(
                                              TextButton(
                                                onPressed: () {
                                                  if (users.name == 'نامشخص') {
                                                    null;
                                                  } else {
                                                    BlocProvider.of<PivotBloc>(
                                                            context)
                                                        .add(UserProfileEvent(
                                                            users.uuid));
                                                  }
                                                },
                                                child: Text(users.name!),
                                              ),
                                            ),
                                            if (users.type == 0) ...{
                                              const DataCell(
                                                Text('حقیقی'),
                                              )
                                            },
                                            if (users.type == 1) ...{
                                              const DataCell(
                                                Text('حقوقی'),
                                              )
                                            },
                                            DataCell(
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: users
                                                              .nationalCode!));
                                                },
                                                child:
                                                    Text(users.nationalCode!),
                                              ),
                                            ),
                                            DataCell(
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: users.mobile ??
                                                              ''));
                                                },
                                                child: Text(users.mobile ?? ''),
                                              ),
                                            ),
                                            DataCell(
                                              Text(users.createdAt
                                                  .toPersianDate()),
                                            ),
                                          ]);
                                        },
                                      ).toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          //disabledColor: Colors.grey,
                                          color:
                                              userResponse.nextPageUrl != null
                                                  ? Colors.black
                                                  : Colors.grey,
                                          onPressed: () {
                                            if (userResponse.nextPageUrl !=
                                                'null') {
                                              BlocProvider.of<UsersBloc>(
                                                      context)
                                                  .add(
                                                UsersStartEvent(
                                                    page: userResponse
                                                            .nextPageUrl!
                                                            .isNotEmpty
                                                        ? userResponse
                                                                .currentPage! +
                                                            1
                                                        : userResponse
                                                            .currentPage!,
                                                    perPage:
                                                        userResponse.perPage,
                                                    paid: paidValue,
                                                    hasSellingTrade:
                                                        sellCheckbox,
                                                    completedProfile:
                                                        profileValue,
                                                    notEmptyWallet:
                                                        sellCheckbox,
                                                    projectUUid: projectId),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.navigate_before,
                                          ),
                                        ),
                                        Text(userResponse.currentPage
                                            .toString()
                                            .toPersianDigit()),
                                        IconButton(
                                          color:
                                              userResponse.prevPageUrl != null
                                                  ? Colors.black
                                                  : Colors.grey,
                                          onPressed: () {
                                            if (userResponse.prevPageUrl !=
                                                'null') {
                                              BlocProvider.of<UsersBloc>(
                                                      context)
                                                  .add(
                                                UsersStartEvent(
                                                    page: userResponse
                                                            .prevPageUrl!
                                                            .isNotEmpty
                                                        ? userResponse
                                                                .currentPage! -
                                                            1
                                                        : userResponse
                                                            .currentPage!,
                                                    perPage:
                                                        userResponse.perPage,
                                                    paid: paidValue,
                                                    hasSellingTrade:
                                                        sellCheckbox,
                                                    completedProfile:
                                                        profileValue,
                                                    projectUUid: projectId),
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.navigate_next,
                                          ),
                                        ),
                                        if (userResponse.total != 1)
                                          DropdownButton(
                                            // iconEnabledColor:
                                            //     contrastColor,
                                            //dropdownColor: contrastColor,
                                            items: dropdownItems,
                                            // focusColor:
                                            //     contrastColor,
                                            style: TextStyle(
                                                //color: contrastColor,
                                                ),
                                            onChanged: (int? newValue) {
                                              //  selectedValue = newValue!;
                                              selectedValue = newValue!;
                                              setState(() {
                                                selectedValue = newValue;
                                              });
                                              // print(paidValueNotifier.value);
                                              BlocProvider.of<UsersBloc>(
                                                      context)
                                                  .add(
                                                UsersStartEvent(
                                                    perPage: selectedValue,
                                                    paid: paidValue,
                                                    hasSellingTrade:
                                                        sellCheckbox,
                                                    completedProfile:
                                                        profileValue,
                                                    projectUUid: projectId),
                                              );
                                            },
                                            value: userResponse.perPage != null
                                                ? userResponse.perPage
                                                : 1,
                                          ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            userResponse.to
                                                .toString()
                                                .toPersianDigit(),
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
                                        Text(
                                            userResponse.total
                                                .toString()
                                                .toPersianDigit(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium)
                                      ],
                                    )
                                  ],
                                ),
                              );
                            })
                          ],
                        },
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

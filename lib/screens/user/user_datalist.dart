import 'dart:js_interop';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_bloc.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_event.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_state.dart';
import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/constant/scheme.dart';
import 'package:admin_smartfunding/data/model/projects/projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/usersBloc/getExcel/excel_bloc.dart';
import '../../bloc/usersBloc/getExcel/excel_event.dart';
import '../../bloc/usersBloc/getExcel/excel_state.dart';
import '../../bloc/usersBloc/message_template/bloc/message_template_bloc.dart';
import '../../bloc/usersBloc/pivot/pivot_bloc.dart';
import '../../bloc/usersBloc/pivot/pivot_event.dart';
import '../../bloc/usersBloc/pivot/pivot_state.dart';
import '../../bloc/usersBloc/sendSms/send_sms_bloc.dart';
import '../../bloc/usersBloc/sendSms/send_sms_event.dart';
import '../../bloc/usersBloc/sendSms/send_sms_state.dart';
import '../../bloc/usersBloc/send_bulk_sms/send_bulk_sms_bloc.dart';
import '../../bloc/usersBloc/user/User_bloc.dart';
import '../../bloc/usersBloc/user/user_event.dart';
import '../../bloc/usersBloc/user/user_state.dart';
import '../../data/model/message_template/message_template.dart';
import '../../responsive/responsive.dart';
import '../../utils/phosphor_icon.dart';
import '../home/home_screen.dart';
import 'asset_user.dart';
import 'widget/show_dialog_send_sms.dart';

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

  String? selectedTemplate; // Stores the identifier of the selected template
  MessageTemplate? selectedMessageTemplate;
  ValueNotifier<int> paidValueNotifier = ValueNotifier<int>(0);
  Project? value;
  Project? FilterValue;
  bool selectedProject = false;
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
    BlocProvider.of<ProjectBloc>(context).add(ProjectStartEvent());
    // selectedValue = widget.userResponse.perPage;
    //paidValueNotifier.value = 0;
  }

  List<DropdownMenuItem<int>> get paidItems {
    List<DropdownMenuItem<int>> paidItems = [
      DropdownMenuItem(
          value: null,
          child: Text("همه", style: Theme.of(context).textTheme.titleSmall)),
      DropdownMenuItem(
          value: 1,
          child: Text("خرید داشته",
              style: Theme.of(context).textTheme.titleSmall)),
      DropdownMenuItem(
          value: 0,
          child: Text("خرید نداشته",
              style: Theme.of(context).textTheme.titleSmall)),
    ];
    return paidItems;
  }

  List<DropdownMenuItem<int>> get profileItems {
    List<DropdownMenuItem<int>> profileItems = [
      DropdownMenuItem(
          value: null,
          child: Text("همه", style: Theme.of(context).textTheme.titleSmall)),
      DropdownMenuItem(
          value: 1,
          child: Text("پروفایل تکمیل شده",
              style: Theme.of(context).textTheme.titleSmall)),
      DropdownMenuItem(
          value: 0,
          child: Text("پروفایل ناقص",
              style: Theme.of(context).textTheme.titleSmall)),
    ];
    return profileItems;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PivotBloc, PivotState>(
      listener: (context, state) {
        if (state is PivotResponseState) {
          state.getPivot.fold(
            (l) => const Text('sth went wrong'),
            (root) {
              if (root.units!.isEmpty) {
                return ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('طرحی خریداری نکرده است'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                return Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MyAssets(root.units!);
                    },
                  ),
                );
              }
            },
          );
        }

        if (state is ProfileResponseState) {
          state.getPivot.fold(
            (l) => const Text('sth went wrong'),
            (root) {
              showDialog(
                  context: context,
                  builder: (BuildContext dilogContext) {
                    return Dialog(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 300,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(root.user.fullName!),
                                Text('نام کاربر'),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(root.user.type == 1 ? 'حقیقی' : 'حقوقی'),
                                Text('نوع کاربر'),
                              ],
                            ),
                            Divider(),
                            if (root.user.bankAccounts != null) ...{
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: root.user.bankAccounts![0].iban
                                          .toString()));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(root.user.bankAccounts![0].iban
                                        .toString()),
                                    Text('شماره شبا'),
                                  ],
                                ),
                              ),
                              Divider(),
                            },
                            if (root.user.tradingAccounts != null) ...{
                              InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(root.user.tradingAccounts![0].code
                                        .toString()),
                                    Text('کد سجامی'),
                                  ],
                                ),
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: root.user.tradingAccounts![0].code
                                          .toString()));
                                },
                              ),
                              Divider(),
                            },
                            if (root.user.legalPersonInfo != null) ...{
                              Text(
                                  "کد اقتصادی: ${root.user.legalPersonInfo!.economicCode}"),
                            },
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(dilogContext).pop();
                                  BlocProvider.of<PivotBloc>(context)
                                      .add(UserPivottEvent(root.user.uuid));
                                },
                                child: Text('طرح های خریداری شده'))
                          ],
                        ),
                      ),
                    );
                  });
            },
          );
        }
      },
      child: BlocBuilder<PivotBloc, PivotState>(
        builder: (context, state) {
          if (state is PivotLoadingState) {
            return const Scaffold(
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColorScheme.primaryColor,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('لطفا کمی صبر کنید'),
                  ],
                ),
              ),
            );
          }

          return BlocListener<SendSmsBloc, SendSmsState>(
            listener: (context, state) {
              if (state is SendRemindSmsState) {
                state.sendRemind.fold((l) {
                  Widget toast = Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xff2196F3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          l,
                          style: const TextStyle(
                            fontFamily: 'IR',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                  fToast!.showToast(
                    child: toast,
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                  );
                }, (r) {
                  Widget toast = Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xff2196F3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          r,
                          style: const TextStyle(
                            fontFamily: 'IR',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                  fToast!.showToast(
                    child: toast,
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                  );
                });
              }
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'مدیریت کاربران',
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
                        PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
                        size: 28),
                  ),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          BlocBuilder<UsersBloc, UsersState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  if (state is UsersLoadingState) ...{
                                    const CircularProgressIndicator(
                                      color: AppColorScheme.primaryColor,
                                    ),
                                  } else ...{
                                    if (state is UsersResponseState) ...{
                                      state.getUsers.fold((l) {
                                        return Text(l);
                                      }, (userResponse) {
                                        return Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColorScheme
                                                    .onPrimaryColor,
                                                border: Border.all(
                                                  width: 1,
                                                  color: Colors.white24,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      child: LayoutBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              BoxConstraints
                                                                  constraints) {
                                                        if (constraints
                                                                .maxWidth >
                                                            850) {
                                                          return Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      searchController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'جستجو',
                                                                    border:
                                                                        OutlineInputBorder(
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
                                                                    contentPadding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            30.0,
                                                                        vertical:
                                                                            12.0),
                                                                  ),
                                                                  onSubmitted:
                                                                      (value) {
                                                                    BlocProvider.of<UsersBloc>(
                                                                            context)
                                                                        .add(
                                                                            UsersStartEvent(
                                                                      search: value
                                                                          .toEnglishDigit(),
                                                                    ));
                                                                    if (value
                                                                        .isEmpty) {
                                                                      BlocProvider.of<UsersBloc>(
                                                                              context)
                                                                          .add(
                                                                              UsersStartEvent());
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColorScheme
                                                                            .primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              FilterValue = null;
                                                                            });
                                                                            BlocProvider.of<UsersBloc>(context).add(
                                                                              UsersStartEvent(
                                                                                perPage: userResponse.perPage,
                                                                                paid: paidValue,
                                                                                completedProfile: profileValue,
                                                                                hasSellingTrade: sellCheckbox,
                                                                                notEmptyWallet: walletCheckbox,
                                                                                projectUUid: null,
                                                                              ),
                                                                            );
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.clear)),
                                                                      BlocBuilder<
                                                                          ProjectBloc,
                                                                          ProjectState>(
                                                                        builder:
                                                                            (context,
                                                                                state) {
                                                                          final projects = state is ProjectResponseState
                                                                              ? state.getProjects.fold(
                                                                                  (error) => [],
                                                                                  (companyList) => companyList.projects.toSet().toList(), // Remove duplicates
                                                                                )
                                                                              : [];

                                                                          return DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<Project>(
                                                                              hint: const Text('انتخاب طرح'),
                                                                              style: Theme.of(context).textTheme.titleMedium,
                                                                              onTap: () {
                                                                                selectedComp = true;
                                                                              },
                                                                              items: projects.map((company) {
                                                                                return DropdownMenuItem<Project>(
                                                                                  value: company,
                                                                                  child: Text(company.title), // Adjust this to your data structure.
                                                                                );
                                                                              }).toList(),

                                                                              elevation: 4,
                                                                              onChanged: (Project? newValue) {
                                                                                setState(() {
                                                                                  FilterValue = newValue!;
                                                                                  projectId = FilterValue!.uuid;
                                                                                  BlocProvider.of<UsersBloc>(context).add(
                                                                                    UsersStartEvent(
                                                                                      perPage: userResponse.perPage,
                                                                                      paid: paidValue,
                                                                                      completedProfile: profileValue,
                                                                                      hasSellingTrade: sellCheckbox,
                                                                                      notEmptyWallet: walletCheckbox,
                                                                                      projectUUid: FilterValue!.uuid,
                                                                                    ),
                                                                                  );
                                                                                });
                                                                              },
                                                                              value: FilterValue, // Ensure the value is valid
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColorScheme
                                                                            .primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child:
                                                                        DropdownButton(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              8),
                                                                      iconEnabledColor:
                                                                          Colors
                                                                              .black,

                                                                      //dropdownColor: contrastColor,
                                                                      items:
                                                                          paidItems,

                                                                      hint:
                                                                          Text(
                                                                        'وضعیت پرداخت',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall,
                                                                      ),
                                                                      iconSize:
                                                                          34,

                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall,
                                                                      onChanged:
                                                                          (int?
                                                                              newValue) {
                                                                        paidValue =
                                                                            newValue;
                                                                        setState(
                                                                          () {
                                                                            paidValue =
                                                                                newValue;
                                                                          },
                                                                        );
                                                                        BlocProvider.of<UsersBloc>(context)
                                                                            .add(
                                                                          UsersStartEvent(
                                                                            perPage:
                                                                                userResponse.perPage,
                                                                            paid:
                                                                                paidValue,
                                                                            completedProfile:
                                                                                profileValue,
                                                                            notEmptyWallet:
                                                                                walletCheckbox,
                                                                            hasSellingTrade:
                                                                                sellCheckbox,
                                                                            projectUUid:
                                                                                projectId,
                                                                          ),
                                                                        );
                                                                      },
                                                                      value:
                                                                          paidValue,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColorScheme
                                                                            .primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      DropdownButtonHideUnderline(
                                                                    child:
                                                                        DropdownButton(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              8),
                                                                      iconEnabledColor:
                                                                          Colors
                                                                              .black,
                                                                      //dropdownColor: contrastColor,
                                                                      items:
                                                                          profileItems,

                                                                      hint:
                                                                          Text(
                                                                        'وضعیت پروفایل',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall,
                                                                      ),
                                                                      iconSize:
                                                                          34,

                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      onChanged:
                                                                          (int?
                                                                              newValue) {
                                                                        profileValue =
                                                                            newValue;
                                                                        setState(
                                                                          () {
                                                                            profileValue =
                                                                                newValue;
                                                                          },
                                                                        );
                                                                        BlocProvider.of<UsersBloc>(context)
                                                                            .add(
                                                                          UsersStartEvent(
                                                                            perPage:
                                                                                userResponse.perPage,
                                                                            paid:
                                                                                paidValue,
                                                                            completedProfile:
                                                                                profileValue,
                                                                            notEmptyWallet:
                                                                                walletCheckbox,
                                                                            hasSellingTrade:
                                                                                sellCheckbox,
                                                                            projectUUid:
                                                                                projectId,
                                                                          ),
                                                                        );
                                                                      },
                                                                      value:
                                                                          profileValue,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: AppColorScheme
                                                                            .primaryColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      CheckboxListTile(
                                                                    title: Text(
                                                                      'دعوت شده',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleSmall,
                                                                    ),
                                                                    value:
                                                                        selltBoolCheckbox,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        if (value!) {
                                                                          setState(
                                                                              () {
                                                                            sellCheckbox =
                                                                                1;
                                                                            selltBoolCheckbox =
                                                                                true;
                                                                          });
                                                                        } else {
                                                                          sellCheckbox =
                                                                              0;
                                                                          selltBoolCheckbox =
                                                                              false;
                                                                        }
                                                                      });
                                                                      BlocProvider.of<UsersBloc>(
                                                                              context)
                                                                          .add(
                                                                        UsersStartEvent(
                                                                          perPage:
                                                                              userResponse.perPage,
                                                                          paid:
                                                                              paidValue,
                                                                          completedProfile:
                                                                              profileValue,
                                                                          notEmptyWallet:
                                                                              walletCheckbox,
                                                                          hasSellingTrade:
                                                                              sellCheckbox,
                                                                          projectUUid:
                                                                              projectId,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              BlocListener<
                                                                  ExcelBloc,
                                                                  ExcelState>(
                                                                listener:
                                                                    (context,
                                                                        state) {
                                                                  if (state
                                                                      is GetExcelState) {
                                                                    state
                                                                        .getExcel
                                                                        .fold(
                                                                            (l) =>
                                                                                ScaffoldMessenger.of(context)
                                                                                    .showSnackBar(
                                                                                  SnackBar(
                                                                                    content: Text(l),
                                                                                    backgroundColor: Colors.red,
                                                                                  ),
                                                                                ),
                                                                            (r) {
                                                                      return launch(
                                                                          r);
                                                                    });
                                                                  }
                                                                },
                                                                child: Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      Container(
                                                                    height: 55,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              AppColorScheme.primaryColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        BlocProvider.of<ExcelBloc>(context)
                                                                            .add(
                                                                          GetExcelEvent(
                                                                            mobile:
                                                                                searchController.text.toEnglishDigit(),
                                                                            paid:
                                                                                paidValue,
                                                                            completedProfile:
                                                                                profileValue,
                                                                            hasSellingTrade:
                                                                                sellCheckbox,
                                                                            notEmptyWallet:
                                                                                walletCheckbox,
                                                                          ),
                                                                        );
                                                                      },
                                                                      icon: BlocBuilder<
                                                                          ExcelBloc,
                                                                          ExcelState>(
                                                                        builder:
                                                                            (context,
                                                                                state) {
                                                                          if (state
                                                                              is ExcelLoadingState) {
                                                                            return const Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                Text(
                                                                                  'درحال آماده سازی',
                                                                                  style: TextStyle(),
                                                                                ),
                                                                                CircularProgressIndicator(
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          } else {
                                                                            return Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                Text(
                                                                                  'فایل اکسل',
                                                                                  style: Theme.of(context).textTheme.titleSmall,
                                                                                ),
                                                                                const Icon(
                                                                                  Icons.file_download_rounded,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        } else {
                                                          return Form(
                                                            key: _formKey,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom),
                                                              child: Column(
                                                                children: [
                                                                  TextFormField(
                                                                    readOnly: Responsive.isMobile(
                                                                            context)
                                                                        ? true
                                                                        : false,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .phone,
                                                                    onFieldSubmitted:
                                                                        (value) {
                                                                      BlocProvider.of<UsersBloc>(
                                                                              context)
                                                                          .add(UsersStartEvent(
                                                                              search: value.toEnglishDigit()));
                                                                      if (value
                                                                          .isEmpty) {
                                                                        BlocProvider.of<UsersBloc>(context)
                                                                            .add(UsersStartEvent());
                                                                      }
                                                                    },
                                                                    controller:
                                                                        searchController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'جستجو',
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        borderSide:
                                                                            const BorderSide(color: Colors.grey),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        borderSide:
                                                                            const BorderSide(color: Colors.blue),
                                                                      ),
                                                                      contentPadding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              30.0,
                                                                          vertical:
                                                                              12.0),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    height: 55,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              AppColorScheme.primaryColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        DropdownButtonHideUnderline(
                                                                      child:
                                                                          DropdownButton(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                        iconEnabledColor:
                                                                            Colors.black,
                                                                        //dropdownColor: contrastColor,
                                                                        items:
                                                                            paidItems,

                                                                        hint:
                                                                            Text(
                                                                          'وضعیت پرداخت',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .titleSmall,
                                                                        ),
                                                                        iconSize:
                                                                            34,

                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall,
                                                                        onChanged:
                                                                            (int?
                                                                                newValue) {
                                                                          paidValue =
                                                                              newValue;
                                                                          setState(
                                                                            () {
                                                                              paidValue = newValue;
                                                                            },
                                                                          );
                                                                          BlocProvider.of<UsersBloc>(context)
                                                                              .add(
                                                                            UsersStartEvent(
                                                                                perPage: userResponse.perPage,
                                                                                paid: paidValue,
                                                                                completedProfile: profileValue,
                                                                                hasSellingTrade: sellCheckbox,
                                                                                notEmptyWallet: walletCheckbox,
                                                                                projectUUid: projectId),
                                                                          );
                                                                        },
                                                                        value:
                                                                            paidValue,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    height: 55,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              AppColorScheme.primaryColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                FilterValue = null;
                                                                              });
                                                                              BlocProvider.of<UsersBloc>(context).add(
                                                                                UsersStartEvent(
                                                                                  perPage: userResponse.perPage,
                                                                                  paid: paidValue,
                                                                                  completedProfile: profileValue,
                                                                                  hasSellingTrade: sellCheckbox,
                                                                                  notEmptyWallet: walletCheckbox,
                                                                                  projectUUid: null,
                                                                                ),
                                                                              );
                                                                            },
                                                                            icon:
                                                                                Icon(Icons.clear)),
                                                                        BlocBuilder<
                                                                            ProjectBloc,
                                                                            ProjectState>(
                                                                          builder:
                                                                              (context, state) {
                                                                            return DropdownButtonFormField<Project>(
                                                                              style: Theme.of(context).textTheme.titleMedium,
                                                                              onTap: () {
                                                                                selectedComp = true;
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                hintText: 'لطفا طرح را انتخاب کنید',
                                                                                hintStyle: TextStyle(fontFamily: 'IR'),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Colors.blue, width: 0.5),
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                                border: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Colors.blue, width: 0.5),
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                                filled: true,
                                                                                //fillColor: Colors.blueAccent,
                                                                              ),
                                                                              // dropdownColor: cardBackgroundColor,
                                                                              items: state is ProjectResponseState
                                                                                  ? state.getProjects.fold(
                                                                                      (error) {
                                                                                        // Handle the error state here if needed.
                                                                                        return [];
                                                                                      },
                                                                                      (companyList) {
                                                                                        return companyList.projects.map((company) {
                                                                                          return DropdownMenuItem<Project>(
                                                                                            value: company,
                                                                                            child: Text(company.title), // Adjust this to your data structure.
                                                                                          );
                                                                                        }).toList();
                                                                                      },
                                                                                    )
                                                                                  : [],
                                                                              elevation: 4,
                                                                              onChanged: (Project? newValue) {
                                                                                setState(() {
                                                                                  FilterValue = newValue!;
                                                                                  projectId = FilterValue!.uuid;
                                                                                  BlocProvider.of<UsersBloc>(context).add(
                                                                                    UsersStartEvent(perPage: userResponse.perPage, paid: paidValue, completedProfile: profileValue, hasSellingTrade: sellCheckbox, notEmptyWallet: walletCheckbox, projectUUid: FilterValue!.uuid),
                                                                                  );
                                                                                });
                                                                              },
                                                                              value: FilterValue,
                                                                            );
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Container(
                                                                    height: 55,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              AppColorScheme.primaryColor),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        DropdownButtonHideUnderline(
                                                                      child:
                                                                          DropdownButton(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8),
                                                                        iconEnabledColor:
                                                                            Colors.black,
                                                                        //dropdownColor: contrastColor,
                                                                        items:
                                                                            profileItems,

                                                                        hint:
                                                                            Text(
                                                                          'وضعیت پروفایل',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .titleSmall,
                                                                        ),
                                                                        iconSize:
                                                                            34,

                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall,
                                                                        onChanged:
                                                                            (int?
                                                                                newValue) {
                                                                          profileValue =
                                                                              newValue;
                                                                          setState(
                                                                            () {
                                                                              profileValue = newValue;
                                                                            },
                                                                          );
                                                                          BlocProvider.of<UsersBloc>(context)
                                                                              .add(
                                                                            UsersStartEvent(
                                                                                perPage: userResponse.perPage,
                                                                                paid: paidValue,
                                                                                completedProfile: profileValue,
                                                                                hasSellingTrade: sellCheckbox,
                                                                                notEmptyWallet: walletCheckbox,
                                                                                projectUUid: projectId),
                                                                          );
                                                                        },
                                                                        value:
                                                                            profileValue,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      })),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Column(
                                                      children: [
                                                        DataTable(
                                                          dataTextStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall,
                                                          headingTextStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                          checkboxHorizontalMargin:
                                                              2.0,
                                                          dataRowHeight: 90,
                                                          columnSpacing: 25,
                                                          columns: const [
                                                            DataColumn(
                                                                label: Text(
                                                                    'پیامک یادآوری')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'فاکتور')),
                                                            // DataColumn(
                                                            //     label: Text(
                                                            //         'ویرایش کاربر')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'نام')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'نوع')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'کد ملی')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'موبایل')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'از طرف')),

                                                            DataColumn(
                                                                label: Text(
                                                                    'تاریخ ساخت')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'زمان ورود')),
                                                          ],
                                                          rows: userResponse
                                                              .data
                                                              .map(
                                                            (users) {
                                                              return DataRow(
                                                                  cells: [
                                                                    DataCell(
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          BlocProvider.of<SendSmsBloc>(context)
                                                                              .add(SendRemindSmsEvent(users.uuid));
                                                                        },
                                                                        child: const Text(
                                                                            'ارسال'),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'مشاهده'),
                                                                        onPressed:
                                                                            () {
                                                                          BlocProvider.of<PivotBloc>(context)
                                                                              .add(
                                                                            UserPivottEvent(users.uuid),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (users.fullName ==
                                                                              'نامشخص') {
                                                                            null;
                                                                          } else {
                                                                            BlocProvider.of<PivotBloc>(context).add(UserProfileEvent(users.uuid));
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                            users.fullName!),
                                                                      ),
                                                                    ),
                                                                    if (users
                                                                            .type ==
                                                                        1) ...{
                                                                      const DataCell(
                                                                        Text(
                                                                            'حقیقی'),
                                                                      )
                                                                    },
                                                                    if (users
                                                                            .type ==
                                                                        2) ...{
                                                                      const DataCell(
                                                                        Text(
                                                                            'حقوقی'),
                                                                      )
                                                                    },
                                                                    DataCell(
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Clipboard.setData(
                                                                              ClipboardData(text: users.nationalCode!));
                                                                        },
                                                                        child: Text(
                                                                            users.nationalCode!),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Clipboard.setData(
                                                                              ClipboardData(text: users.mobile ?? ''));
                                                                        },
                                                                        child: Text(users.mobile ??
                                                                            ''),
                                                                      ),
                                                                    ),
                                                                    if (users
                                                                            .inviter !=
                                                                        null) ...{
                                                                      DataCell(
                                                                        Text(users.inviter!.nationalCode ??
                                                                            '---'),
                                                                      ),
                                                                    } else ...{
                                                                      const DataCell(
                                                                        Text(
                                                                            '---'),
                                                                      ),
                                                                    },
                                                                    DataCell(
                                                                      Text(users
                                                                          .createdAt
                                                                          .toPersianDate()),
                                                                    ),
                                                                    DataCell(
                                                                      Text(users
                                                                          .createdAt
                                                                          .split(
                                                                              ' ')[1]
                                                                          .toString()
                                                                          .toPersianDigit()),
                                                                    ),
                                                                  ]);
                                                            },
                                                          ).toList(),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            IconButton(
                                                              //disabledColor: Colors.grey,
                                                              color: userResponse
                                                                          .nextPageUrl !=
                                                                      null
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                              onPressed: () {
                                                                if (userResponse
                                                                        .nextPageUrl !=
                                                                    'null') {
                                                                  BlocProvider.of<
                                                                              UsersBloc>(
                                                                          context)
                                                                      .add(
                                                                    UsersStartEvent(
                                                                        page: userResponse.nextPageUrl!.isNotEmpty
                                                                            ? userResponse.currentPage! +
                                                                                1
                                                                            : userResponse
                                                                                .currentPage!,
                                                                        perPage:
                                                                            userResponse
                                                                                .perPage,
                                                                        paid:
                                                                            paidValue,
                                                                        hasSellingTrade:
                                                                            sellCheckbox,
                                                                        completedProfile:
                                                                            profileValue,
                                                                        notEmptyWallet:
                                                                            sellCheckbox,
                                                                        projectUUid:
                                                                            projectId),
                                                                  );
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .navigate_before,
                                                              ),
                                                            ),
                                                            Text(userResponse
                                                                .currentPage
                                                                .toString()
                                                                .toPersianDigit()),
                                                            IconButton(
                                                              color: userResponse
                                                                          .prevPageUrl !=
                                                                      null
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                              onPressed: () {
                                                                if (userResponse
                                                                        .prevPageUrl !=
                                                                    'null') {
                                                                  BlocProvider.of<
                                                                              UsersBloc>(
                                                                          context)
                                                                      .add(
                                                                    UsersStartEvent(
                                                                        page: userResponse.prevPageUrl!.isNotEmpty
                                                                            ? userResponse.currentPage! -
                                                                                1
                                                                            : userResponse
                                                                                .currentPage!,
                                                                        perPage:
                                                                            userResponse
                                                                                .perPage,
                                                                        paid:
                                                                            paidValue,
                                                                        hasSellingTrade:
                                                                            sellCheckbox,
                                                                        completedProfile:
                                                                            profileValue,
                                                                        notEmptyWallet:
                                                                            sellCheckbox,
                                                                        projectUUid:
                                                                            projectId),
                                                                  );
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .navigate_next,
                                                              ),
                                                            ),
                                                            if (userResponse
                                                                    .total !=
                                                                1)
                                                              DropdownButton(
                                                                // iconEnabledColor:
                                                                //     contrastColor,
                                                                //dropdownColor: contrastColor,
                                                                items:
                                                                    dropdownItems,
                                                                // focusColor:
                                                                //     contrastColor,
                                                                style: TextStyle(
                                                                    //color: contrastColor,
                                                                    ),
                                                                onChanged: (int?
                                                                    newValue) {
                                                                  //  selectedValue = newValue!;
                                                                  selectedValue =
                                                                      newValue!;
                                                                  setState(() {
                                                                    selectedValue =
                                                                        newValue;
                                                                  });
                                                                  // print(paidValueNotifier.value);
                                                                  BlocProvider.of<
                                                                              UsersBloc>(
                                                                          context)
                                                                      .add(
                                                                    UsersStartEvent(
                                                                        perPage:
                                                                            selectedValue,
                                                                        paid:
                                                                            paidValue,
                                                                        hasSellingTrade:
                                                                            sellCheckbox,
                                                                        completedProfile:
                                                                            profileValue,
                                                                        notEmptyWallet:
                                                                            walletCheckbox,
                                                                        projectUUid:
                                                                            projectId),
                                                                  );
                                                                },
                                                                value: userResponse
                                                                            .perPage !=
                                                                        null
                                                                    ? userResponse
                                                                        .perPage
                                                                    : 1,
                                                              ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                                userResponse.to
                                                                    .toString()
                                                                    .toPersianDigit(),
                                                                style: Theme.of(
                                                                        context)
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
                                                                userResponse
                                                                    .total
                                                                    .toString()
                                                                    .toPersianDigit(),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleMedium)
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Visibility(
                                              visible: searchController
                                                      .text.isNotEmpty ||
                                                  paidValue != null ||
                                                  profileValue != null ||
                                                  walletBoolCheckbox == true ||
                                                  selltBoolCheckbox == true,
                                              child: BlocBuilder<
                                                  MessageTemplateBloc,
                                                  MessageTemplateState>(
                                                builder: (context, state) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      //   color: containerColor,
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.white24,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        if (state
                                                            is MessageTemplateLoadingState)
                                                          const CircularProgressIndicator()
                                                        else if (state
                                                            is MessageTemplateResponseState)
                                                          state
                                                              .getMessageTemplate
                                                              .fold(
                                                            (l) => Text(l),
                                                            (messageList) {
                                                              return Responsive
                                                                      .isDesktop(
                                                                          context)
                                                                  ? Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(),
                                                                            onPressed:
                                                                                () {
                                                                              if (!selectedTemplate!.isEmpty && selectedProject == true) {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return BlocProvider(
                                                                                      create: (context) => SendBulkSmsBloc(),
                                                                                      child: SendBulkSms(
                                                                                        searchController.text,
                                                                                        paidValue,
                                                                                        profileValue,
                                                                                        walletCheckbox,
                                                                                        sellCheckbox,
                                                                                        selectedMessageTemplate!.template,
                                                                                        value!.uuid,
                                                                                        total: userResponse.total.toString(),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  const SnackBar(
                                                                                    content: Text('لطفا یکی از گزینه ها را انتخاب کنید'),
                                                                                    backgroundColor: Colors.red,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'ارسال',
                                                                              style: TextStyle(fontFamily: 'IR'),
                                                                            ),
                                                                          ),
                                                                        )),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              ListView.builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                messageList.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              final template = messageList[index];
                                                                              return RadioListTile(
                                                                                title: Text(
                                                                                  template.title,
                                                                                  style: const TextStyle(fontFamily: 'IR'),
                                                                                ),
                                                                                value: template.template,
                                                                                groupValue: selectedTemplate,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    selectedTemplate = value.toString();
                                                                                    selectedMessageTemplate = messageList.firstWhere((t) => t.template == value);
                                                                                  });
                                                                                },
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        BlocProvider(
                                                                          create:
                                                                              (context) {
                                                                            ProjectBloc
                                                                                bloc =
                                                                                ProjectBloc();
                                                                            bloc.add(ProjectStartEvent());
                                                                            return bloc;
                                                                          },
                                                                          child:
                                                                              Expanded(
                                                                            flex:
                                                                                3,
                                                                            child:
                                                                                BlocBuilder<ProjectBloc, ProjectState>(
                                                                              builder: (context, state) {
                                                                                return DropdownButtonFormField<Project>(
                                                                                  style: Theme.of(context).textTheme.titleMedium,

                                                                                  decoration: InputDecoration(
                                                                                    hintText: 'لطفا طرح را مشخص کنید',
                                                                                    hintStyle: const TextStyle(fontFamily: 'IR'),
                                                                                    enabledBorder: OutlineInputBorder(
                                                                                      borderSide: const BorderSide(color: AppColorScheme.accentColor, width: 0.5),
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                    ),
                                                                                    border: OutlineInputBorder(
                                                                                      borderSide: const BorderSide(color: AppColorScheme.accentColor, width: 0.5),
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                    ),
                                                                                    filled: true,
                                                                                    //fillColor: Colors.blueAccent,
                                                                                  ),
                                                                                  // dropdownColor: cardBackgroundColor,

                                                                                  items: state is ProjectResponseState
                                                                                      ? state.getProjects.fold(
                                                                                          (error) {
                                                                                            // Handle the error state here if needed.
                                                                                            return [];
                                                                                          },
                                                                                          (projectList) {
                                                                                            return projectList.projects.map((project) {
                                                                                              return DropdownMenuItem<Project>(
                                                                                                value: project,
                                                                                                child: Text(project.title), // Adjust this to your data structure.
                                                                                              );
                                                                                            }).toList();
                                                                                          },
                                                                                        )
                                                                                      : [],
                                                                                  elevation: 4,
                                                                                  onChanged: (Project? newValue) {
                                                                                    setState(() {
                                                                                      selectedProject = true;
                                                                                      value = newValue;
                                                                                    });
                                                                                  },
                                                                                  value: value,
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 10),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                                color: Colors.grey[300], // Background color for the message box
                                                                                border: Border.all(color: Colors.grey.shade400),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: selectedMessageTemplate != null
                                                                                    ? Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            selectedMessageTemplate!.title,
                                                                                            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'IR'),
                                                                                          ),
                                                                                          const SizedBox(height: 10),
                                                                                          Text(
                                                                                            selectedMessageTemplate!.text,
                                                                                            style: TextStyle(fontFamily: 'IR'),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : Container(
                                                                                        padding: const EdgeInsets.all(16.0),
                                                                                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(12.0),
                                                                                          color: Colors.grey[300], // Background color for the message box
                                                                                        ),
                                                                                        child: const Text(
                                                                                          'لطفا یکی از فرمت های پیام را انتخاب کنید',
                                                                                          style: TextStyle(color: Colors.black87, fontFamily: 'IR'),
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        ListView
                                                                            .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount:
                                                                              messageList.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            final template =
                                                                                messageList[index];
                                                                            return RadioListTile(
                                                                              title: Text(
                                                                                template.title,
                                                                                // style: TextStyle(fontFamily: 'IR'),
                                                                              ),
                                                                              value: template.template,
                                                                              groupValue: selectedTemplate,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  selectedTemplate = value.toString();
                                                                                  selectedMessageTemplate = messageList.firstWhere((t) => t.template == value);
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10),
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(12.0),
                                                                              color: Colors.grey[300], // Background color for the message box
                                                                              border: Border.all(color: Colors.grey.shade400),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: selectedMessageTemplate != null
                                                                                  ? Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          selectedMessageTemplate!.title,
                                                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'IR'),
                                                                                        ),
                                                                                        SizedBox(height: 10),
                                                                                        Text(
                                                                                          selectedMessageTemplate!.text,
                                                                                          style: const TextStyle(fontFamily: 'IR'),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Container(
                                                                                      padding: const EdgeInsets.all(16.0),
                                                                                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(12.0),
                                                                                        color: Colors.grey[300], // Background color for the message box
                                                                                      ),
                                                                                      child: const Text(
                                                                                        'لطفا یکی از فرمت های پیام را انتخاب کنید',
                                                                                        style: TextStyle(color: Colors.black87, fontFamily: 'IR'),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        BlocProvider(
                                                                          create:
                                                                              (context) {
                                                                            ProjectBloc
                                                                                bloc =
                                                                                ProjectBloc();
                                                                            bloc.add(ProjectStartEvent());
                                                                            return bloc;
                                                                          },
                                                                          child: BlocBuilder<
                                                                              ProjectBloc,
                                                                              ProjectState>(
                                                                            builder:
                                                                                (context, state) {
                                                                              return DropdownButtonFormField<Project>(
                                                                                style: Theme.of(context).textTheme.titleMedium,
                                                                                onTap: () {
                                                                                  selectedProject = true;
                                                                                  // print();
                                                                                },
                                                                                decoration: InputDecoration(
                                                                                  hintText: 'لطفا طرح را مشخص کنید',
                                                                                  hintStyle: TextStyle(fontFamily: 'IR'),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide: const BorderSide(color: AppColorScheme.accentColor, width: 0.5),
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                  border: OutlineInputBorder(
                                                                                    borderSide: const BorderSide(color: AppColorScheme.accentColor, width: 0.5),
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                  filled: true,
                                                                                  //fillColor: Colors.blueAccent,
                                                                                ),
                                                                                // dropdownColor: cardBackgroundColor,
                                                                                items: state is ProjectResponseState
                                                                                    ? state.getProjects.fold(
                                                                                        (error) {
                                                                                          // Handle the error state here if needed.
                                                                                          return [];
                                                                                        },
                                                                                        (projectList) {
                                                                                          return projectList.projects.map((project) {
                                                                                            return DropdownMenuItem<Project>(
                                                                                              value: project,
                                                                                              child: Text(project.title), // Adjust this to your data structure.
                                                                                            );
                                                                                          }).toList();
                                                                                        },
                                                                                      )
                                                                                    : [],
                                                                                elevation: 4,
                                                                                onChanged: (Project? newValue) {
                                                                                  setState(() {
                                                                                    selectedProject = true;
                                                                                    value = newValue;
                                                                                  });
                                                                                },
                                                                                value: value,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 10,
                                                                              vertical: 10),
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (!selectedTemplate!.isEmpty && selectedProject == true) {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return BlocProvider(
                                                                                      create: (context) => SendBulkSmsBloc(),
                                                                                      child: SendBulkSms(
                                                                                        searchController.text,
                                                                                        paidValue,
                                                                                        profileValue,
                                                                                        walletCheckbox,
                                                                                        sellCheckbox,
                                                                                        selectedMessageTemplate!.template,
                                                                                        value!.uuid,
                                                                                        total: userResponse.total.toString(),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  const SnackBar(
                                                                                    content: Text('لطفا یکی از گزینه ها را انتخاب کنید'),
                                                                                    backgroundColor: Colors.red,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                const Text('ارسال'),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                            },
                                                          ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      })
                                    }
                                  },
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

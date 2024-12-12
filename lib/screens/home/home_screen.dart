import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_bloc.dart';
import 'package:admin_smartfunding/bloc/ProjectBloc/projects/project_event.dart';
import 'package:admin_smartfunding/bloc/auth/login/login_bloc.dart';
import 'package:admin_smartfunding/bloc/auth/login/login_event.dart';
import 'package:admin_smartfunding/bloc/auth/login/login_state.dart';
import 'package:admin_smartfunding/bloc/company/company_bloc.dart';
import 'package:admin_smartfunding/bloc/company/company_event.dart';
import 'package:admin_smartfunding/bloc/deposit/deposit_event.dart';
import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/constant/color.dart';
import 'package:admin_smartfunding/screens/company/company_screen.dart';
import 'package:admin_smartfunding/screens/deposit/deposit_dataList.dart';
import 'package:admin_smartfunding/screens/home/widget/drawer.dart';
import 'package:admin_smartfunding/screens/home/widget/menu_home.dart';
import 'package:admin_smartfunding/screens/login_screen/login_screen.dart';
import 'package:admin_smartfunding/screens/metabase/metabase.dart';
import 'package:admin_smartfunding/utils/auth_manager.dart';
import 'package:admin_smartfunding/utils/phosphor_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../bloc/deposit/deposit_bloc.dart';
import '../../bloc/metabase/metabase_event.dart';
import '../../bloc/metabase/metabase_state.dart';
import '../../bloc/ticket/get_Ticket/ticket_bloc.dart';
import '../../bloc/ticket/get_Ticket/ticket_event.dart';
import '../../bloc/usersBloc/getExcel/excel_bloc.dart';
import '../../bloc/usersBloc/getExcel/excel_event.dart';
import '../../bloc/usersBloc/message_template/bloc/message_template_bloc.dart';
import '../../bloc/usersBloc/pivot/pivot_bloc.dart';
import '../../bloc/usersBloc/pivot/pivot_event.dart';
import '../../bloc/usersBloc/sendSms/send_sms_bloc.dart';
import '../../bloc/usersBloc/sendSms/send_sms_event.dart';
import '../../bloc/usersBloc/user/User_bloc.dart';
import '../../bloc/usersBloc/user/user_event.dart';
import '../../bloc/usersBloc/user/user_state.dart';
import '../../bloc/withdraw/get_withdraw/withdraw_bloc.dart';
import '../../responsive/responsive.dart';
import '../projects/project_home.dart';
import '../ticket/ticket_datalist.dart';
import '../user/user_datalist.dart';
import '../comments/comment_project_screen.dart';
import '../withdraw/withdraw_datalist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    BlocProvider.of<MetabaseBloc>(context).add(MetabaseStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        UsersBloc bloc = UsersBloc();
        bloc.add(UsersStartEvent());
        return bloc;
      },
      child: BlocListener<UsersBloc, UsersState>(
        listener: (context, state) {
          if (state is UsersResponseState) {
            state.getUsers.fold((l) {
              if (l == 'Unauthenticated.') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    showCloseIcon: true,
                    closeIconColor: Colors.white,
                    content: Text(
                      'لطفا دوباره وارد شوید!',
                      style: TextStyle(
                          fontSize: Responsive.isDesktop(context) ? 12.0 : 10.0,
                          fontFamily: 'IR',
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => CheckLoginBloc(),
                        child: LoginDesktopScreen(),
                      );
                    },
                  ),
                );
              }
            }, (r) {});
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocListener<MetabaseBloc, MetabaseState>(
            listener: (context, state) {
              if (state is MetabaseResponseState) {
                state.getMetabase.fold((l) => Text(l), (r) {
                  return Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MetabaseScreen(r);
                      },
                    ),
                  );
                });
              }
            },
            child: Scaffold(
              drawer: BlocProvider(
                create: (context) => CheckLoginBloc(),
                child: drawer(),
              ),
              appBar: AppBar(
                title: Text(
                  'پنل ادمین',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              backgroundColor: Colors.grey[100],
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isDesktop(context) ? 3 : 1,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 5,
                    childAspectRatio: Responsive.isDesktop(context)
                        ? 2.9
                        : Responsive.isTablet(context)
                            ? 3.5
                            : 3.5,
                  ),
                  children: [
                    menueButton(
                      context: context,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                create: (context) => ProjectBloc(),
                                child: const ProjectHome(),
                              );
                            },
                          ),
                        );
                      },
                      text: 'مدیریت طرح ها',
                      icon:
                          PhosphorIcons.houseSimple(PhosphorIconsStyle.regular),
                    ),
                    menueButton(
                        context: context,
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) {
                                    final UsersBloc bloc = UsersBloc();
                                    bloc.add(UsersStartEvent());
                                    return bloc;
                                  },
                                ),
                                BlocProvider(
                                  create: (context) {
                                    final PivotBloc bloc = PivotBloc();
                                    bloc.add(PivotStartEvent());
                                    return bloc;
                                  },
                                ),
                                BlocProvider(
                                  create: (context) {
                                    final SendSmsBloc bloc = SendSmsBloc();
                                    bloc.add(SendSmsStartEvent());
                                    return bloc;
                                  },
                                ),
                                BlocProvider(
                                  create: (context) {
                                    final MessageTemplateBloc bloc =
                                        MessageTemplateBloc();
                                    bloc.add(MessageTemplateStartEvent());
                                    return bloc;
                                  },
                                ),
                                BlocProvider(
                                  create: (context) {
                                    final ExcelBloc bloc = ExcelBloc();
                                    bloc.add(ExcelInitEvent());
                                    return bloc;
                                  },
                                ),
                                BlocProvider(
                                  create: (context) {
                                    final ProjectBloc bloc = ProjectBloc();
                                    bloc.add(ProjectStartEvent());
                                    return bloc;
                                  },
                                )
                              ],
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: UserDataList(),
                              ),
                            );
                          }));
                        },
                        text: 'مدیریت کاربران',
                        icon: PhosphorIcons.userCircle(
                            PhosphorIconsStyle.regular)),
                    menueButton(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) {
                                        final TicketBloc bloc = TicketBloc();
                                        bloc.add(TicketStartEvent());
                                        return bloc;
                                      },
                                    ),
                                    //  BlocProvider(
                                    //     create: (context) {
                                    //       final SendTicketBloc bloc = SendTicketBloc();
                                    //       bloc.add(TicketStartEvent());
                                    //       return bloc;
                                    //     },
                                    //   ),
                                  ],
                                  child: const TicketDatalist(),
                                );
                              },
                            ),
                          );
                        },
                        text: 'تیکت ها',
                        icon: PhosphorIcons.ticket(PhosphorIconsStyle.regular)),
                    menueButton(
                      context: context,
                      onPressed: () {
                        BlocProvider.of<MetabaseBloc>(context)
                            .add(MetabaseClickEvent());
                      },
                      text: 'گزارش ها',
                      icon: PhosphorIcons.receipt(PhosphorIconsStyle.regular),
                    ),
                    // menueButton(
                    //     context: context,
                    //     onPressed: () {
                    //       Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //           builder: (context) {
                    //             return MultiBlocProvider(
                    //               providers: [
                    //                 BlocProvider(
                    //                   create: (context) {
                    //                     final WithdrawBloc bloc =
                    //                         WithdrawBloc();
                    //                     bloc.add(WithdrawStartEvent());
                    //                     return bloc;
                    //                   },
                    //                 ),
                    //                 //  BlocProvider(
                    //                 //     create: (context) {
                    //                 //       final SendTicketBloc bloc = SendTicketBloc();
                    //                 //       bloc.add(TicketStartEvent());
                    //                 //       return bloc;
                    //                 //     },
                    //                 //   ),
                    //               ],
                    //               child: const WithdrawScreen(),
                    //             );
                    //           },
                    //         ),
                    //       );
                    //     },
                    //     text: 'درخواست نقد شدن',
                    //     icon: PhosphorIcons.money(PhosphorIconsStyle.regular)),
                    menueButton(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider(
                                  create: (context) => ProjectBloc(),
                                  child: const CommentProject(),
                                );
                              },
                            ),
                          );
                        },
                        text: 'نظرات',
                        icon: PhosphorIcons.chatCenteredText(
                            PhosphorIconsStyle.regular)),
                    menueButton(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) {
                                        final DepositBloc bloc = DepositBloc();
                                        bloc.add(DepositStartEvent());
                                        return bloc;
                                      },
                                    ),
                                  ],
                                  child: const DepositScreen(),
                                );
                              },
                            ),
                          );
                        },
                        text: 'فیش واریزی',
                        icon:
                            PhosphorIcons.receipt(PhosphorIconsStyle.regular)),
                    menueButton(
                        context: context,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) {
                                        final CompanyBloc bloc = CompanyBloc();
                                        bloc.add(CompanyStartEvent());
                                        return bloc;
                                      },
                                    ),
                                  ],
                                  child: const CompanyScreen(),
                                );
                              },
                            ),
                          );
                        },
                        text: 'متقاضی سرمایه',
                        icon: PhosphorIcons.creditCard(
                            PhosphorIconsStyle.regular))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class drawer extends StatelessWidget {
  const drawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckLoginBloc, CheckLoginState>(
      listener: (context, state) {
        if (state is CheckLogoutResponse) {
          state.logout.fold(
            (l) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l),
                backgroundColor: Colors.red,
              ),
            ),
            (r) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(r),
                  backgroundColor: Colors.green,
                ),
              );
              AuthMnager.logout();
              return Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => CheckLoginBloc(),
                      child: LoginDesktopScreen(),
                    );
                  },
                ),
              );
            },
          );
        }
      },
      child: Drawer(
        width: 200,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "پنل ادمین",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              accountEmail: Text(
                "smartfunding@email.com",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              currentAccountPicture: CircleAvatar(
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            ListTile(
              leading: buildPhosphorIcon(PhosphorIconsBold.houseSimple),
              title: Text(
                'خانه',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: buildPhosphorIcon(PhosphorIconsBold.gearSix),
              title: Text(
                'تنظیمات',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () {
                // Handle the Settings navigation
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: buildPhosphorIcon(PhosphorIconsBold.signOut),
              title: Text(
                'خروج',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () {
                BlocProvider.of<CheckLoginBloc>(context)
                    .add(CheckLogoutButtonClick());
              },
            ),
            const AboutListTile(
              applicationName: 'admin',
              applicationVersion: 'V0-6',
            )
          ],
        ),
      ),
    );
  }
}

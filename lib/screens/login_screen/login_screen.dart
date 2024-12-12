import 'dart:ui';

import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../bloc/auth/check_otp_verify/otp_verify_bloc.dart';
import '../../../../bloc/auth/login/login_bloc.dart';
import '../../../../bloc/auth/login/login_event.dart';
import '../../../../bloc/auth/login/login_state.dart';
import '../../constant/scheme.dart';
import '../../responsive/responsive.dart';
import '../../utils/validation.dart';
import '../home/home_screen.dart';
import '../otp/otp_verify_desktop_screen.dart';

class LoginDesktopScreen extends StatefulWidget {
  LoginDesktopScreen({super.key});

  @override
  State<LoginDesktopScreen> createState() => _LoginDesktopScreenState();
}

class _LoginDesktopScreenState extends State<LoginDesktopScreen> {
  final _formKey = GlobalKey<FormState>();
  FToast? fToast;
  void initState() {
    fToast = FToast();
    fToast!.init(context);
  }

  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController nationalCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CheckLoginBloc, CheckLoginState>(
        listener: (context, state) {
          if (state is CheckLoginResponse) {
            state.getCheck.fold((l) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l),
                  backgroundColor: Colors.red,
                ),
              );
            }, (r) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => MetabaseBloc(),
                      child: HomeScreen(),
                    );
                  },
                ),
              );
              // Navigator.of(context, rootNavigator: true).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return BlocProvider(
              //         create: (context) => OtpVerifyBloc(),
              //         child:
              //             OtpVerifyDesktopScreen(mobileNumberController.text.toEnglishDigit(), nationalCodeController.text.toEnglishDigit()),
              //       );
              //     },
              //   ),
              // );
            });
          }
        },
        child: SizedBox(
          //height: 300,
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      width: Responsive.isMobile(context)
                          ? MediaQuery.of(context).size.width * 0.8
                          : 600,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[50]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/logo.png',
                              width: 100,
                            ),
                            SizedBox(
                              width: Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.width * 0.47
                                  : MediaQuery.of(context).size.width * 0.8,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: mobileNumberController,
                                  decoration: InputDecoration(
                                    counterStyle: const TextStyle(
                                      fontFamily: 'IR',
                                      fontSize: 10,
                                      color: AppColorScheme.primaryColor,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                    labelText: 'شماره موبایل',
                                    labelStyle: TextStyle(
                                      fontSize: Responsive.isDesktop(context)
                                          ? 14
                                          : 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: Responsive.isDesktop(context)
                                    ? MediaQuery.of(context).size.width * 0.47
                                    : MediaQuery.of(context).size.width * 0.8,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: nationalCodeController,
                                    decoration: InputDecoration(
                                      counterStyle: const TextStyle(
                                        fontFamily: 'IR',
                                        fontSize: 10,
                                        color: AppColorScheme.primaryColor,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                      border: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(7),
                                        ),
                                      ),
                                      labelText: 'کد ملی',
                                      labelStyle: TextStyle(
                                        fontSize: Responsive.isDesktop(context)
                                            ? 14
                                            : 12,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            BlocBuilder<CheckLoginBloc, CheckLoginState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        Responsive.isDesktop(context)
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.47
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                        50),
                                    backgroundColor: state is CheckLoadingState
                                        ? Colors.grey
                                        : AppColorScheme.primaryColor,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (state is CheckLoadingState) {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<CheckLoginBloc>(context)
                                            .add(
                                          CheckLoginButtonClick(
                                              mobileNumberController.text
                                                  .toEnglishDigit(),
                                              nationalCodeController.text
                                                  .toEnglishDigit()),
                                        );
                                      }
                                    } else {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<CheckLoginBloc>(context)
                                            .add(
                                          CheckLoginButtonClick(
                                              mobileNumberController.text
                                                  .toEnglishDigit(),
                                              nationalCodeController.text
                                                  .toEnglishDigit()),
                                        );
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (state is CheckLoadingState) ...{
                                        CircularProgressIndicator(),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          'ورود',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      } else ...{
                                        Text(
                                          'ورود',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        )
                                      }
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

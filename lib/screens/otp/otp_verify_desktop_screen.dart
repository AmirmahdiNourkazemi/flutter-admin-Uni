import 'dart:ui';
import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../bloc/auth/check_otp_verify/otp_verify_bloc.dart';
import '../../../../bloc/auth/check_otp_verify/otp_verify_event.dart';
import '../../../../bloc/auth/check_otp_verify/otp_verify_state.dart';
import '../../constant/scheme.dart';
import '../../responsive/responsive.dart';

class OtpVerifyDesktopScreen extends StatefulWidget {
  String mobileNumber;
  String nationalCode;
  OtpVerifyDesktopScreen(this.mobileNumber, this.nationalCode, {super.key});

  @override
  State<OtpVerifyDesktopScreen> createState() => _OtpVerifyDesktopScreenState();
}

class _OtpVerifyDesktopScreenState extends State<OtpVerifyDesktopScreen> {
  FToast? fToast;
  void initState() {
    BlocProvider.of<OtpVerifyBloc>(context).add(OtpVerifyInitEvent());
    fToast = FToast();
    fToast!.init(context);
  }

  OtpFieldController otpController = OtpFieldController();
  TextEditingController _otpControllerText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OtpVerifyBloc, OtpVerifyState>(
        listener: (context, state) {
          if (state is OtpVerifyResponse) {
            state.getcheckOtp.fold((l) {
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
                          fontFamily: 'IR', color: Colors.white),
                    ),
                  ],
                ),
              );

              fToast!.showToast(
                child: toast,
                gravity: ToastGravity.TOP,
                toastDuration: Duration(seconds: 2),
              );
            }, (r) {
              // if (r.user!.isAdmin!) {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) {
              //         return BlocProvider(
              //           create: (context) => MetabaseBloc(),
              //           child: HomeScreen(),
              //         );
              //       },
              //     ),
              //   );
              // } else {
              //   Widget toast = Container(
              //     padding: const EdgeInsets.symmetric(
              //         horizontal: 24.0, vertical: 12.0),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20.0),
              //       color: const Color(0xff2196F3),
              //     ),
              //     child: const Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(
              //           Icons.warning,
              //           color: Colors.white,
              //         ),
              //         SizedBox(
              //           width: 12.0,
              //         ),
              //         Text(
              //           'شما ادمین نیستید',
              //           style: TextStyle(fontFamily: 'IR', color: Colors.white),
              //         ),
              //       ],
              //     ),
              //   );
              //   fToast!.showToast(
              //     child: toast,
              //     gravity: ToastGravity.TOP,
              //     toastDuration: Duration(seconds: 2),
              //   );
              // }
            });
          }
        },
        child: Center(
          child: SizedBox(
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.47
                : MediaQuery.of(context).size.width * 0.8,
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Container(
                    width: Responsive.isMobile(context)
                        ? MediaQuery.of(context).size.width * 0.8
                        : 600,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[50]),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: OTPTextField(
                            length: 5,
                            controller: otpController,
                            width: 400,
                            fieldWidth: 45,
                            style: const TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (value) {
                              if (value.isNotEmpty) {
                                _otpControllerText.text = value;
                                BlocProvider.of<OtpVerifyBloc>(context).add(
                                  OtpVerifyButtonClick(
                                    widget.mobileNumber,
                                    widget.nationalCode,
                                    _otpControllerText.text.toEnglishDigit(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                            //height: 20,
                            ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorScheme.primaryColor,
                            minimumSize: const Size(200, 50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_otpControllerText.text.isNotEmpty) {
                              BlocProvider.of<OtpVerifyBloc>(context).add(
                                  OtpVerifyButtonClick(
                                      widget.mobileNumber,
                                      widget.nationalCode,
                                      _otpControllerText.text));
                            }
                          },
                          child: Text(
                            "تایید",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OtpTimerButton(
                                //controller: controller,
                                height: 60,
                                text: const Text(
                                  'ارسال مجدد کد',
                                ),
                                duration: 30,
                                radius: 30,
                                backgroundColor: AppColorScheme.primaryColor,
                                textColor: Colors.white,
                                buttonType: ButtonType
                                    .text_button, // or ButtonType.outlined_button
                                loadingIndicator:
                                    const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                                loadingIndicatorColor: Colors.red,
                                onPressed: () {
                                  // BlocProvider.of(context)
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

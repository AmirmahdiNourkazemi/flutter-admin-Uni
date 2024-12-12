import 'package:admin_smartfunding/bloc/metabase/metabase_bloc.dart';
import 'package:admin_smartfunding/constant/color.dart';
import 'package:admin_smartfunding/screens/home/home_screen.dart';
import 'package:admin_smartfunding/screens/login_screen/login_screen.dart';
import 'package:admin_smartfunding/utils/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/auth/login/login_bloc.dart';
import 'constant/scheme.dart';
import 'constant/textTheme.dart';
import 'di/di.dart';

void main() async {
  await getItInit();
  Fluttertoast.showToast;
  final SharedPreferences _sharedPreferences = locator.get();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String token = AuthMnager.readAuth();
    return MaterialApp(
      title: 'smart funding admin pannel',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        textTheme: CustomTextTheme().getTextTheme(context),
        colorScheme: AppColorScheme.appColorScheme,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: token.isEmpty
          ? BlocProvider(
              create: (context) => CheckLoginBloc(),
              child: LoginDesktopScreen(),
            )
          : BlocProvider(
              create: (context) => MetabaseBloc(),
              child: const HomeScreen(),
            ),
    );
  }
}

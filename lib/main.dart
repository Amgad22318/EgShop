import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/data/data_provider/local/cache_helper.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/presentation/router/app_router.dart';
import 'package:egshop/presentation/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  token = CacheHelper.getDataFromSharedPreference(key: 'token');
  bool? isDark = CacheHelper.getDataFromSharedPreference(key: 'darkMode');

  runApp(MyApp(
    appRouter: AppRouter(token),
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final bool? isDark;

  const MyApp({Key? key, required this.appRouter, required this.isDark})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GlobalCubit>(
      create: (context) => GlobalCubit()
        ..changeThemeMode(isDarkFromShared: isDark)
       ,
      child: Builder(builder: (context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EgShop',
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: context.select((GlobalCubit cubit) => cubit.isDark)
                ? ThemeMode.dark
                : ThemeMode.light);
      }),
    );
  }
}

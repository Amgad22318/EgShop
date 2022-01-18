import 'package:egshop/business_logic/cart_cubit/cart_cubit.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/business_logic/register_cubit/register_cubit.dart';
import 'package:egshop/data/data_provider/local/cache_helper.dart';
import 'package:egshop/data/repository/home_repository.dart';
import 'package:egshop/presentation/screens/cart/cart_screen.dart';
import 'package:egshop/presentation/screens/full_product/full_product_screen.dart';
import 'package:egshop/presentation/screens/home/shop_layout.dart';
import 'package:egshop/presentation/screens/login/shop_login_screen.dart';
import 'package:egshop/presentation/screens/on_boarding/on_borading_screen.dart';
import 'package:egshop/presentation/screens/register/shop_register_screen.dart';
import 'package:egshop/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  String? token;
  late Widget startWidget;
  bool? onBoarding = CacheHelper.getDataFromSharedPreference(key: 'onBoarding');

  AppRouter(this.token) {
    if (onBoarding != null) {
      if (token != null) {
        startWidget = BlocProvider<ShopCubit>(
          create: (context) => ShopCubit()
            ..getHomeData(HomeRepository(), context)
            ..getCategoriesData()
            ..getProfileData(),
          child: ShopLayout(),
        );
      } else {
        startWidget = ShopLoginScreen();
      }
    } else {
      startWidget = OnBoardingScreen();
    }
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => startWidget);
      case '/login':
        return MaterialPageRoute(
            builder: (_) => ShopLoginScreen());
      case '/register':
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(
                create: (context) => ShopRegisterCubit(),
                child: ShopRegisterScreen(),
              ),
        );
      case '/home':
        return  MaterialPageRoute(
          builder: (_) =>  BlocProvider<ShopCubit>(
            create: (context) => ShopCubit()
              ..getHomeData(HomeRepository(), context)
              ..getCategoriesData()
              ..getProfileData(),
            child: ShopLayout(),
          ),
        );
      case '/fullProduct':
        return MaterialPageRoute(
          builder: (_) => FullProductScreen(),
        );
      case '/Search':
        return MaterialPageRoute(
          builder: (_) => SearchScreen(),
        );
      case '/cart':
        return MaterialPageRoute(
          builder: (_) =>
              CartScreen(),

        );
      default:
        return null;
    }
  }
}

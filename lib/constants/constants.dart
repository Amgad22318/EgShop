import 'package:egshop/business_logic/Full_product/full_product_cubit.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/data/data_provider/local/cache_helper.dart';
import 'package:egshop/presentation/screens/full_product/full_product_screen.dart';
import 'package:egshop/presentation/screens/login/shop_login_screen.dart';
import 'package:flutter/material.dart';


String? token = '';

void navigateTo(BuildContext context, Widget widget) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

void navigateToAndFinish(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
        (Route<dynamic> route) {
      return false;
    },
  );
}

void signOut(BuildContext context) {
  CacheHelper.RemoveData(key: 'token').then((value) {
    if (value) {
      ShopCubit cubit = ShopCubit.get(context);
    cubit.index = 0;
      GlobalCubit.get(context).favorites.clear();
    cubit.profileModel=null;
      GlobalCubit.get(context).favoritesModel=null;

    navigateToAndFinish(context, ShopLoginScreen()
    );
  }
  });
}

void showFullProductDetails(BuildContext context, int id) {
  GlobalCubit.get(context).fullProductGlobalId=id;
  Navigator.pushNamed(context,'/fullProduct');
}


void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}


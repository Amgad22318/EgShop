import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/business_logic/home_cubit/states.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLayout extends StatelessWidget {
  ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopCubit, ShopStates>(
      buildWhen: (previous, current) {
        if (current is ShopChangeBottomNavState) {
          if (previous is ShopChangeBottomNavState &&
              current.index == previous.index) {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      },
  builder: (context, state) {
    return Scaffold(
      body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  title: const Text('EgShop'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/cart');
                        },
                        icon: const Icon(Icons.shopping_cart_rounded)),
                    IconButton(
                        onPressed: () {
                          navigateTo(context, SearchScreen());
                        },
                        icon: const Icon(Icons.search_outlined)),
                  ],
                )
              ],
          body: BlocProvider.of<ShopCubit>(context)
              .screens[BlocProvider.of<ShopCubit>(context).index]),
      bottomNavigationBar:  BottomNavigationBar(
        currentIndex: BlocProvider.of<ShopCubit>(context).index,
        onTap: (index) {
          BlocProvider.of<ShopCubit>(context)
              .changeBottomNav(currentIndex: index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.apps_rounded), label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      )
    );
  },
);
  }
}

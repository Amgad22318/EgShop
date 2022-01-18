import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:egshop/presentation/views/build_fav_and_search_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key? key}) : super(key: key);
  late ShopCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit = ShopCubit.get(context);
    return BlocBuilder<GlobalCubit, GlobalStates>(
      buildWhen: (previous, current) {
        if (current is ShopSuccessGetFavoritesState
            ) {
          return true;

        }else if (
            current is ShopChangeFavoritesState
            ) {
          return true;
        }else if (
            current is ShopErrorChangeFavoritesState) {
          return true;
        }
        else {
          return false;
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: GlobalCubit.get(context).favoritesModel != null &&
              GlobalCubit.get(context).favorites.isNotEmpty,
          builder: (context) {
            if (GlobalCubit.get(context)
                .favoritesModel!
                .data!
                .favoritesData!
                .isNotEmpty) {
              return MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.separated(
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return BuildFavAndSearchProduct(
                        model: GlobalCubit.get(context)
                            .favoritesModel!
                            .data!
                            .favoritesData![index]
                            .product,
                        withOutDiscount: false,
                        cubit: cubit,
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            width: double.infinity,
                            color: greyBlue3,
                            height: 0.3,
                          ),
                        ),
                    itemCount: GlobalCubit.get(context)
                        .favoritesModel!
                        .data!
                        .favoritesData!
                        .length),
              );
            } else {
              return const Center(
                child: Text(
                  'No Favorites',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black),
                ),
              );
            }
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

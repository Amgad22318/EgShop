import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/cart_cubit/cart_cubit.dart';
import 'package:egshop/business_logic/cart_cubit/cart_states.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/presentation/views/build_fav_and_search_product.dart';
import 'package:egshop/presentation/views/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
   CartScreen({Key? key}) : super(key: key);
  late CartCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>CartCubit()..getCartData() ,
      child: BlocConsumer<CartCubit, CartStates>(
        listener: (context, state) {},
        builder: (context, state) {
          cubit = CartCubit.get(context);
          return Scaffold(
            body: ConditionalBuilder(
              condition: cubit.cartModel != null && cubit.inCart.isNotEmpty,
              builder: (context) {
                if (cubit.cartModel!.data!.cartItems!.isNotEmpty) {
                  return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BuildFavAndSearchProduct(cubit: cubit,
                          model: cubit.cartModel!.data!.cartItems![index]
                              .product,withOutDiscount: false,
                        );
                      },
                      separatorBuilder: (context, index) => listViewSeparator(),
                      itemCount:
                      cubit.cartModel!.data!.cartItems!.length);
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
            ),
          );
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/business_logic/home_cubit/states.dart';
import 'package:egshop/data/models/categories_model.dart';
import 'package:egshop/presentation/views/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.5, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late ShopCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit = ShopCubit.get(context);
    return  ConditionalBuilder(
        condition: cubit.categoriesModel != null,
        builder: (context) {
          _controller.forward();
          return MediaQuery.removePadding(
            context: context,removeTop: true,
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildCategoriesScreenItem(
                        cubit.categoriesModel!.data!.data![index]),
                separatorBuilder: (context, index) => listViewSeparator(),
                itemCount: cubit.categoriesModel!.data!.data!.length),
          );
        },
        fallback: (context) =>
        const Center(child: CircularProgressIndicator()));
  }

  Widget buildCategoriesScreenItem(DataModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Card(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 8, top: 6, bottom: 6),
                child: Image(
                  image: CachedNetworkImageProvider(
                    model.image.toString(),
                  ),
                  height: 140,
                  width: 140,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  model.name.toString(),
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.clip),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}

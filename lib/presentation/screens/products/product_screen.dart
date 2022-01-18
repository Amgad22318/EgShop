import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/business_logic/home_cubit/cubit.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/data/models/categories_model.dart';
import 'package:egshop/data/models/home_model.dart';
import 'package:egshop/data/models/product_model.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({Key? key}) : super(key: key);
  late ShopCubit cubit;

  @override
  Widget build(BuildContext context) {
    cubit = BlocProvider.of<ShopCubit>(context);
    return ConditionalBuilder(
        condition: cubit.homeModel != null &&
            cubit.categoriesModel != null &&
            GlobalCubit.get(context).favorites.isNotEmpty,
        builder: (context) =>
            builderWidget(cubit.homeModel, cubit.categoriesModel, context),
        fallback: (context) =>
            const Center(child: CircularProgressIndicator()));
  }

  Widget builderWidget(
          HomeModel? homeModel, CategoriesModel? categoriesModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: homeModel!.data.banners!
                    .map((singleBanner) => Image(
                          image:
                              CachedNetworkImageProvider(singleBanner.image!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ))
                    .toList(),
                options: CarouselOptions(
                    height: 250,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    viewportFraction: 0.9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal)),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categories',
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategoryItem(
                            categoriesModel!.data!.data![index]),
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 5,
                            ),
                        itemCount: categoriesModel!.data!.data!.length),
                  ),
                  Text(
                    'New Products',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 2,
              childAspectRatio: 1 / 1.77,
              children: List.generate(
                  homeModel.data.products!.length,
                  (index) => buildGridProduct(
                      homeModel.data.products![index], context)),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: CachedNetworkImageProvider(model.image.toString()),
            height: 100.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
          Container(
              color: Colors.black.withOpacity(0.6),
              width: 100,
              child: Text(
                model.name.toString(),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      );

  Widget buildGridProduct(ProductData model, context) {
    return Card(
      child: InkWell(
        onTap: () {
          showFullProductDetails(context, model.id!);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Image(
                    image: CachedNetworkImageProvider(model.image!),
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                if (model.discount != 0)
                  Text(
                    '  Discount ${model.discount.round()}%  ',
                    style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        backgroundColor: greyBlue2),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}\n',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${model.price.round()} L.E',
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(color: greyBlue3, fontSize: 14),
                          ),
                          if (model.discount != 0)
                            Text(
                              '${model.oldPrice.round()} L.E',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: defaultGrey,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough),
                            ),
                        ],
                      ),
                      const Spacer(),
                      BlocBuilder<GlobalCubit, GlobalStates>(
                        buildWhen: (previous, current) {
                          if (current is ShopChangeFavoritesState &&
                              current.productId == model.id) {
                            printWarning(model.id.toString());
                            return true;
                          }
                          if (current is ShopErrorChangeFavoritesState &&
                              current.productId == model.id) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          return IconButton(
                              onPressed: () {
                                GlobalCubit.get(context)
                                    .changeFavorites(model.id);
                              },
                              icon:
                                  GlobalCubit.get(context).favorites[model.id]!
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.favorite_border,
                                          color: defaultGrey,
                                        ));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

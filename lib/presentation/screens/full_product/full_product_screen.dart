import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:egshop/business_logic/Full_product/full_product_cubit.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/data/models/product_model.dart';
import 'package:egshop/presentation/screens/cart/cart_screen.dart';
import 'package:egshop/presentation/screens/search/search_screen.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:egshop/presentation/widgets/default_material_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FullProductScreen extends StatefulWidget {
  FullProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FullProductScreen> createState() => _FullProductScreenState();
}

class _FullProductScreenState extends State<FullProductScreen> {
  late FullProductCubit cubit;
  late int productQuantity;
  late int fullProductCarouselSliderImagesActiveIndex;
  late bool loopActive;
  late Timer _timer;

  @override
  void initState() {
    loopActive = false;
    productQuantity = 1;
    fullProductCarouselSliderImagesActiveIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FullProductCubit()
        ..getProductsModelByID(
            id: GlobalCubit.get(context).fullProductGlobalId),
      child: BlocConsumer<FullProductCubit, FullProductStates>(
        listener: (context, state) {},
        builder: (context, state) {
          cubit = BlocProvider.of<FullProductCubit>(context);

          return WillPopScope(
            onWillPop: () async {
              cubit.fullProductModel = null;
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('EgShop'),
                actions: [
                  IconButton(
                      onPressed: () {
                        navigateTo(context, CartScreen());
                      },
                      icon: const Icon(Icons.shopping_cart_rounded)),
                  IconButton(
                      onPressed: () {
                        navigateTo(context, SearchScreen());
                      },
                      icon: const Icon(Icons.search_outlined)),
                ],
              ),
              body: ConditionalBuilder(
                condition: cubit.fullProductModel != null,
                fallback: (context) {
                  return const Center(child: CircularProgressIndicator());
                },
                builder: (context) {
                  ProductData? model = cubit.fullProductModel!.productData;
                  return Column(
                    children: [
                      Expanded(
                        flex: 85,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 16,
                              end: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Material(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30.0)),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.all(4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CarouselSlider(
                                            items: model!.images!
                                                .map((image) => Image(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        image,
                                                      ),
                                                      width: double.infinity,
                                                      fit: BoxFit.contain,
                                                    ))
                                                .toList(),
                                            options: CarouselOptions(
                                                enlargeCenterPage: true,
                                                onPageChanged: (index, reason) {
                                                  setState(() {
                                                    fullProductCarouselSliderImagesActiveIndex =
                                                        index;
                                                  });
                                                },
                                                autoPlay: true,
                                                height: 250,
                                                initialPage: 0,
                                                autoPlayInterval:
                                                    const Duration(seconds: 3),
                                                autoPlayAnimationDuration:
                                                    const Duration(
                                                        milliseconds: 1500),
                                                viewportFraction: 1,
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                scrollDirection:
                                                    Axis.horizontal)),
                                        AnimatedSmoothIndicator(
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          curve: Curves.fastLinearToSlowEaseIn,
                                          count: model.images!.length,
                                          activeIndex:
                                              fullProductCarouselSliderImagesActiveIndex,
                                          effect: const ScrollingDotsEffect(
                                            maxVisibleDots: 7,
                                            dotColor: greyBlue2,
                                            activeDotColor: greyBlue3,
                                            dotHeight: 7,
                                            dotWidth: 7,
                                            spacing: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${model.price!.round()} L.E',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: greyBlue3,
                                                  fontSize: 14),
                                            ),
                                            if (model.discount != 0)
                                              Row(
                                                children: [
                                                  Text(
                                                    '${model.oldPrice!.round()} L.E',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: defaultGrey,
                                                        fontSize: 12,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .only(start: 8.0),
                                                    child: Container(
                                                        height: 24,
                                                        width: 38,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          // You can use like this way or like the below line
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: greyBlue2,
                                                        ),
                                                        child: Text(
                                                          '${model.discount!.round()}%',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              ),
                                          ],
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ],
                                ),
                                Text('Description',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Text(model.description!),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Container(
                          padding: const EdgeInsetsDirectional.all(8),
                          margin: const EdgeInsetsDirectional.only(
                              start: 8, end: 8),
                          decoration: const BoxDecoration(
                              color: greyBlue1,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0))),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 50,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        decrementProductQuantity();
                                      },
                                      onTapDown: (details) {
                                        _timer = Timer.periodic(
                                            const Duration(milliseconds: 200),
                                            (t) {
                                          decrementProductQuantity();
                                        });
                                      },
                                      onTapCancel: () {
                                        _timer.cancel();
                                      },
                                      onTapUp: (TapUpDetails details) {
                                        _timer.cancel();
                                      },
                                      child: const ClipOval(
                                        child: Material(
                                          color: greyBlue2,
                                          child: SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Icon(
                                                Icons.remove,
                                                size: 16,
                                              )),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child:
                                            Text(productQuantity.toString())),
                                    ClipOval(
                                      child: Material(
                                        color: greyBlue3, // Button color
                                        child: GestureDetector(
                                          onTap: () {
                                            incrementProductQuantity();
                                          },
                                          onTapDown: (details) {
                                            _timer = Timer.periodic(
                                                const Duration(
                                                    milliseconds: 200), (t) {
                                              incrementProductQuantity();
                                            });
                                          },
                                          onTapCancel: () {
                                            _timer.cancel();
                                          },
                                          onTapUp: (TapUpDetails details) {
                                            _timer.cancel();
                                          },
                                          child: const SizedBox(
                                              width: 35,
                                              height: 35,
                                              child: Icon(
                                                Icons.add,
                                                size: 16,
                                              )),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Total : ${NumberFormat.simpleCurrency(decimalDigits: 0, name: '').format(((model.price * productQuantity).round()))} L.E  ',
                                      maxLines: 1,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: greyBlue3,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(
                                flex: 20,
                              ),
                              Flexible(
                                flex: 50,
                                child: SizedBox(
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                          flex: 15,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: backGroundWhite,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0))),
                                            child: BlocBuilder<GlobalCubit,
                                                GlobalStates>(
                                              buildWhen: (previous, current) {
                                                if (current
                                                        is ShopChangeFavoritesState &&
                                                    current.productId ==
                                                        model.id) {
                                                  printWarning(
                                                      model.id.toString());
                                                  return true;
                                                }
                                                if (current
                                                        is ShopErrorChangeFavoritesState &&
                                                    current.productId ==
                                                        model.id) {
                                                  return true;
                                                } else {
                                                  return false;
                                                }
                                              },
                                              builder: (context, state) {
                                                return IconButton(
                                                  padding: EdgeInsetsDirectional
                                                      .zero,
                                                  onPressed: () {
                                                    GlobalCubit.get(context)
                                                        .changeFavorites(
                                                            model.id);
                                                  },
                                                  icon: GlobalCubit.get(context)
                                                          .favorites[model.id]!
                                                      ? const Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                        )
                                                      : const Icon(
                                                          Icons.favorite_border,
                                                          color: greyBlue2,
                                                        ),
                                                );
                                              },
                                            ),
                                          )),
                                      const Spacer(
                                        flex: 10,
                                      ),
                                      Expanded(
                                          flex: 80,
                                          child: DefaultMaterialButton(
                                            radius: 12,
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons
                                                      .add_shopping_cart_outlined,
                                                  color: Colors.white,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  'Add to Cart',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))
                                              ],
                                            ),
                                            onPressed: () {},
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void incrementProductQuantity() {
    setState(() {
      if (productQuantity < 99) {
        productQuantity++;
      } else {}
    });
  }

  void decrementProductQuantity() {
    setState(() {
      if (productQuantity > 1) {
        productQuantity--;
      } else {}
    });
  }
}

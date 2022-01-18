import 'package:cached_network_image/cached_network_image.dart';
import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildFavAndSearchProduct extends StatefulWidget {
  final dynamic model;
  final bool withOutDiscount;
  final cubit;

  const BuildFavAndSearchProduct({
    Key? key,
    required this.model,
    required this.withOutDiscount,
    required this.cubit,
  }) : super(key: key);

  @override
  State<BuildFavAndSearchProduct> createState() =>
      _BuildFavAndSearchProductState();
}

class _BuildFavAndSearchProductState extends State<BuildFavAndSearchProduct>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          printWarning(widget.model.id!.toString());
          showFullProductDetails(context, widget.model.id!);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: CachedNetworkImageProvider(
                      widget.model!.image.toString()),
                  width: double.infinity,
                  height: 200,
                ),
                if (widget.withOutDiscount)
                  if (widget.model!.discount != 0)
                    Text(
                      '  Discount ${widget.model!.discount!.round()}%  ',
                      style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          backgroundColor: Colors.red),
                    )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.model!.name}\n',
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
                            '${widget.model!.price!.round()} L.E',
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(color: greyBlue3, fontSize: 14),
                          ),
                          if (widget.withOutDiscount)
                            if (widget.model!.discount != 0)
                              Text(
                                '${widget.model!.old_price!.round()} L.E',
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
                              current.productId == widget.model.id) {
                            printWarning(widget.model.id.toString());
                            return true;
                          }
                          if (current is ShopErrorChangeFavoritesState &&
                              current.productId == widget.model.id) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          return IconButton(
                              onPressed: () {
                                GlobalCubit.get(context)
                                    .changeFavorites(widget.model.id);
                              },
                              icon: GlobalCubit.get(context)
                                      .favorites[widget.model.id]!
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

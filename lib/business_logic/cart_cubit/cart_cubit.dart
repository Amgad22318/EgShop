import 'package:egshop/business_logic/cart_cubit/cart_states.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/cart_model.dart';

import 'package:egshop/constants/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(ShopCartInitialState());

  static CartCubit get(context) => BlocProvider.of(context);


  CartModel? cartModel;

  Map<int?, bool> inCart = {};

  void getCartData() {
    emit(ShopLoadingGetCartDataState());
    DioHelper.getData(url: CART, token: token).then((value) {
      cartModel = CartModel.fromJson(value.data);
      cartModel!.data!.cartItems!.forEach((element) {
        inCart.addAll({element.id: element.product!.inCart!});
      });
      emit(ShopSuccessGetCartDataState());
    }).catchError((error) {
      printWarning('cubit getCartData error: ${error.toString()}');
      emit(ShopErrorGetCartDataState());
    });
  }
}

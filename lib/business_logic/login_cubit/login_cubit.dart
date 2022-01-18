

import 'package:egshop/business_logic/login_cubit/login_states.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/login_and_profile_model.dart';
import 'package:egshop/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);
 late ShopLoginAndProfileAndUpdateModel loginModel;
  void userLogin({required String email, required String password}) {
    emit(ShopLoginLoadingState());
    printWarning(email);
    printWarning(password);
    DioHelper.postData(url: LOGIN, data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginModel=ShopLoginAndProfileAndUpdateModel.fromJson(value.data);

      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
      printWarning(error.toString());
    });
  }

  IconData passwordSuffixIcon = Icons.visibility_outlined;
  bool passwordHidden = true;

  void changePasswordVisibility() {
    passwordHidden = !passwordHidden;
    passwordSuffixIcon = passwordHidden
        ?  Icons.visibility_outlined
        :Icons.visibility_off_outlined;

    emit(ShopLoginPasswordVisibilityState());
  }
}

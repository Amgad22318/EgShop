import 'package:bloc/bloc.dart';
import 'package:egshop/business_logic/register_cubit/register_states.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/login_and_profile_model.dart';
import 'package:egshop/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  late ShopLoginAndProfileAndUpdateModel loginModel;

  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone}) {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(url: REGISTER, data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((value) {
      loginModel = ShopLoginAndProfileAndUpdateModel.fromJson(value.data);

      emit(ShopRegisterSuccessState(loginModel));
    }).catchError((error) {
      emit(ShopRegisterErrorState(error));
      printWarning(error.toString());
    });
  }

  IconData passwordSuffixIcon = Icons.visibility_outlined;
  bool passwordHidden = true;

  void changePasswordVisibility() {
    passwordHidden = !passwordHidden;
    passwordSuffixIcon = passwordHidden
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    emit(ShopRegisterPasswordVisibilityState());
  }
}

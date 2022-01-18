import 'dart:convert';
import 'dart:io';

import 'package:egshop/business_logic/global_cubit/global_cubit.dart';
import 'package:egshop/business_logic/home_cubit/states.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/constants/enums.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/categories_model.dart';
import 'package:egshop/data/models/home_model.dart';
import 'package:egshop/data/models/login_and_profile_model.dart';
import 'package:egshop/data/models/search_model.dart';
import 'package:egshop/data/repository/home_repository.dart';
import 'package:egshop/presentation/screens/categories/categories_screen.dart';
import 'package:egshop/presentation/screens/favorites/favorites_screen.dart';
import 'package:egshop/presentation/screens/products/product_screen.dart';
import 'package:egshop/presentation/screens/profile/profile_screen.dart';
import 'package:egshop/presentation/views/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  // static ShopCubit get(context) => BlocProvider.of<ShopCubit>(context);
 static bool repeatedNavIndexChecker(ShopStates current, ShopStates previous) {
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
  }
  int index = 0;
  List<Widget> screens = [
    BlocBuilder<ShopCubit, ShopStates>(
      buildWhen: (previous, current) {
        return repeatedNavIndexChecker(current, previous);
      },
      builder: (context, state) {
        return ProductScreen();
      },
    ),
    BlocBuilder<ShopCubit, ShopStates>(
      buildWhen: (previous, current) {
        return repeatedNavIndexChecker(current, previous);
      },
      builder: (context, state) {
        return CategoriesScreen();
      },
    ),
    BlocBuilder<ShopCubit, ShopStates>(
      buildWhen: (previous, current) {
        return repeatedNavIndexChecker(current, previous);
      },
      builder: (context, state) {
        return FavoritesScreen();
      },
    ),
    BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopUpdateProfileSuccessState) {
          if (state.status == true) {
            showToastMsg(msg: state.message, toastState: ToastStates.SUCCESS);
          } else {
            showToastMsg(msg: state.message, toastState: ToastStates.ERROR);
          }
        }
      },
      buildWhen: (previous, current) {
        return repeatedNavIndexChecker(current, previous);
      },
      builder: (context, state) {
        return ProfileScreen();
      },
    )
  ];



  void changeBottomNav({required int currentIndex}) {
    index = currentIndex;
    emit(ShopChangeBottomNavState(index));
  }

  // void getHomeData() {
  //   try {
  //     emit(ShopLoadingGetHomeDataState());
  //     DioHelper.getData(url: 's', token: token).then((value) {
  //       homeModel = HomeModel.fromJson(value.data);
  //       homeModel!.data.products.forEach((element) {
  //         favorites.addAll({element.id: element.in_favorites});
  //       });
  //
  //       emit(ShopSuccessGetHomeDataState());
  //     });
  //   } on DioError catch (error) {
  //     emit(ShopErrorGetHomeDataState());
  //     if (error.type == DioErrorType.response) {
  //       print('catched');
  //       print(error.response!.data['message']);
  //       return;
  //     }
  //     if (error.type == DioErrorType.connectTimeout) {
  //       print('Check your connection!!!');
  //       return;
  //     }
  //     if (error.type == DioErrorType.receiveTimeout) {
  //       print('Unable to connect to the server!!!');
  //       return;
  //     }
  //     if (error.type == DioErrorType.other) {
  //       print('Something went wrong!!!');
  //       return;
  //     }
  //   }
  //
  //   // print('cubit getHomeData error: ${error.toString()}');
  // }
  HomeModel? homeModel;

  void getHomeData(HomeRepository homeRepository, BuildContext context) {
    emit(ShopLoadingGetHomeDataState());
    homeRepository.fetchHomeApi().then((value) {
      homeModel = value;
      homeModel!.data.products!.forEach((element) {
        GlobalCubit
            .get(context)
            .favorites
            .addAll({element.id: element.inFavorites!});
        emit(ShopSuccessGetHomeDataState());
      });
    }).catchError((error) {
      printWarning('cubit getHomeData error: ${error.toString()}');
      emit(ShopErrorGetHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      printWarning('cubit getCategories error: ${error.toString()}');
      emit(ShopErrorCategoriesState());
    });
  }

  ShopLoginAndProfileAndUpdateModel? profileModel;
  ShopLoginAndProfileAndUpdateModel? tempProfileModel;

  void getProfileData() {
    emit(ShopLoadingGetProfileState());

    DioHelper.getData(url: PROFILE, token: token).then((value) {
      profileModel = ShopLoginAndProfileAndUpdateModel.fromJson(value.data);

      emit(ShopSuccessGetProfileState());
    }).catchError((error) {
      printWarning('cubit getProfile error: ${error.toString()}');
      emit(ShopErrorGetProfileState());
    });
  }

  void updateUserProfile({required String email,
    required String phone,
    required String name,
   }) {
    emit(ShopUpdateProfileLoadingState());
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    }).then((value) {
      profileModel = ShopLoginAndProfileAndUpdateModel.fromJson(value.data);
      if (profileModel!.status == true) {
        emit(ShopUpdateProfileSuccessState(
            status: profileModel!.status!, message: profileModel!.message!));
      } else {
        bool status = profileModel!.status!;
        String message = profileModel!.message!;
        profileModel = tempProfileModel;
        emit(ShopUpdateProfileSuccessState(
            status: status, message: message));
      }
    }).catchError((error) {
      emit(ShopUpdateProfileErrorState(error.toString()));
      printWarning(error.toString());
    });
  }

  late File image;

  Future<void> updateProfileImage({required String email,
    required String phone,
    required String name,
    required XFile image,
   }) async {
    emit(ShopUpdateProfileLoadingState());

    List<int> imageBytes = await image.readAsBytes();
    String base64 = base64Encode(imageBytes);
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'image': base64
    }).then((value) {
      profileModel = ShopLoginAndProfileAndUpdateModel.fromJson(value.data);
      if (profileModel!.status == true) {
        emit(ShopUpdateProfileSuccessState(
            status: profileModel!.status!, message: profileModel!.message!));
      } else {
        bool status = profileModel!.status!;
        String message = profileModel!.message!;
        profileModel = tempProfileModel;
        emit(ShopUpdateProfileSuccessState(
            status: status, message: message,));
      }
    }).catchError((error) {
      emit(ShopUpdateProfileErrorState(error.toString()));
      printWarning(error.toString());
    });
  }

  SearchModel? searchModel;

  void getSearchData({required String searchText}) {
    emit(ShopLoadingSearchState());
    DioHelper.postData(url: SEARCH, token: token, data: {'text': searchText})
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      printWarning(searchModel!.data!.searchData!.length.toString());
      emit(ShopSuccessSearchState());
    }).catchError((error) {
      emit(ShopErrorSearchState());
      printWarning(error.toString());
    });
  }


}

import 'package:egshop/constants/constants.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/local/cache_helper.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/change_favorites_model.dart';
import 'package:egshop/data/models/favorite_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalStates> {
  GlobalCubit() : super(GlobalInitial());
  static GlobalCubit get(context) => BlocProvider.of(context);
late int fullProductGlobalId;

  bool isDark = true;

  void changeThemeMode({bool? isDarkFromShared}) {
    if (isDarkFromShared != null) {
      isDark = isDarkFromShared;
      emit(ThemeModeChangedState(isDark));
    } else {
      isDark = !isDark;
      CacheHelper.saveDataSharedPreference(key: 'darkMode', value: isDark)
          .then((value) {});
      emit(ThemeModeChangedState(isDark));
    }
  }

  late ChangeFavoritesModel changeFavoritesModel;
  Map<int?, bool> favorites = {};

  void changeFavorites(int? productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState(productId));
    DioHelper.postData(
        url: FAVORITES,
        token: token,
        data: {'product_id': productId}).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangeFavoritesState());
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      printWarning('cubit ChangeFavorites error: ${error.toString()}');
      emit(ShopErrorChangeFavoritesState(productId));
    });
  }
  FavoritesModel? favoritesModel;

  void getFavoritesData() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      printWarning('cubit getFavorites error: ${error.toString()}');
      emit(ShopErrorGetFavoritesState());
    });
  }


}

part of 'global_cubit.dart';

@immutable
abstract class GlobalStates {}

class GlobalInitial extends GlobalStates {}

class ThemeModeChangedState extends GlobalStates{
 bool isDark;
  ThemeModeChangedState(this.isDark);
}


class ShopChangeFavoritesState extends GlobalStates {
 final int? productId;

 ShopChangeFavoritesState(this.productId);
}

class ShopSuccessChangeFavoritesState extends GlobalStates {
}

class ShopErrorChangeFavoritesState extends GlobalStates {
 final int? productId;

 ShopErrorChangeFavoritesState(this.productId);
}

class ShopSuccessGetFavoritesState extends GlobalStates {}

class ShopLoadingGetFavoritesState extends GlobalStates {}

class ShopErrorGetFavoritesState extends GlobalStates {}
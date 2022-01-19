
abstract class ShopStates {}

class ShopInitialState extends ShopStates {

}


class ShopChangeBottomNavState extends ShopStates {
  int index ;

  ShopChangeBottomNavState(this.index);
}

class ShopLoadingGetHomeDataState extends ShopStates {}

class ShopSuccessGetHomeDataState extends ShopStates {}

class ShopErrorGetHomeDataState extends ShopStates {}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {}





class ShopSuccessGetProfileState extends ShopStates {


  ShopSuccessGetProfileState();


}

class ShopLoadingGetProfileState extends ShopStates {}

class ShopErrorGetProfileState extends ShopStates {}

class ShopUpdateProfileLoadingState extends ShopStates {}

class ShopUpdateProfileSuccessState extends ShopStates {
  final bool status;
  final String message;

  ShopUpdateProfileSuccessState({required this.status, required this.message});
}

class ShopUpdateProfileErrorState extends ShopStates {
  final String error;

  ShopUpdateProfileErrorState(this.error);
}







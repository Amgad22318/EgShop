part of 'full_product_cubit.dart';

@immutable
abstract class FullProductStates {}

class FullProductInitial extends FullProductStates {}


class ShopSuccessGetProductModelByIDState extends FullProductStates {}

class ShopLoadingGetProductModelByIDState extends FullProductStates {}

class ShopErrorGetProductModelByIDState extends FullProductStates {}

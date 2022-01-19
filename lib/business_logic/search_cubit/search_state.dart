part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}
class ShopLoadingSearchState extends SearchState {}

class ShopSuccessSearchState extends SearchState {}

class ShopErrorSearchState extends SearchState {}
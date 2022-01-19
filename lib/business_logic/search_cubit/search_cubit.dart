import 'package:bloc/bloc.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/search_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  static SearchCubit get(context) => BlocProvider.of(context);

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

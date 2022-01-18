import 'package:bloc/bloc.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'full_product_state.dart';

class FullProductCubit extends Cubit<FullProductStates> {
  FullProductCubit() : super(FullProductInitial());


  static FullProductCubit get(context) => BlocProvider.of(context);





  FullProductModel? fullProductModel;

  void getProductsModelByID({required int id}) {
    fullProductModel = null;
    emit(ShopLoadingGetProductModelByIDState());

    DioHelper.getData(url: '$PRODUCT$id', token: token).then((value) {
      fullProductModel = FullProductModel.fromJson(value.data);
      emit(ShopSuccessGetProductModelByIDState());
    }).catchError((error) {
      printWarning('cubit getProductsModelByID error: ${error.toString()}');
      emit(ShopErrorGetProductModelByIDState());
    });
  }

}

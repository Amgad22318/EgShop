import 'package:dio/dio.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';
import 'package:egshop/data/models/home_model.dart';

class HomeRepository {
    Future<HomeModel?> fetchHomeApi() async {
      try {
        Response response = await DioHelper.getData(url: HOME, token: token);
        return HomeModel.fromJson(response.data);
      } catch (error) {
        printWarning(error.toString());
        return null;
      }
    }

}

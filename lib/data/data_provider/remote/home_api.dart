import 'package:dio/dio.dart';
import 'package:egshop/constants/constants.dart';
import 'package:egshop/constants/end_points.dart';
import 'package:egshop/data/data_provider/remote/dio_helper.dart';

class HomeApi {
  Future<Map<String, dynamic>> fetchHomeApi() async {
    try {
      Response response = await DioHelper.getData(url: HOME, token: token);
      return response.data;
    } catch (error) {
      printWarning(error.toString());
      return {};
    }
  }
}

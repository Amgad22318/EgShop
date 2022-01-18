
import 'package:egshop/data/models/product_model.dart';

class HomeModel{
  late bool status;
  dynamic message;
  late HomeDataModel data;
  HomeModel.fromJson(Map<String,dynamic>json){
    status=json['status'];
    data=HomeDataModel.fromJson(json['data']);
    message = json['message'];

  }


}


class HomeDataModel{
  HomeDataModel.fromJson(dynamic json) {
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners?.add(BannersModel.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductData.fromJson(v));
      });
    }
    ad = json['ad'];
  }
  List<BannersModel>? banners;
  List<ProductData>? products;
  String? ad;


}

class BannersModel{
  BannersModel.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    category = json['category'];
    product = json['product'];
  }
  int? id;
  String? image;
  dynamic category;
  dynamic product;
}


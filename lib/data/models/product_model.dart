class FullProductModel {

  FullProductModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    productData = json['data'] != null ? ProductData.fromJson(json['data']) : null;
  }
  bool? status;
  dynamic message;
  ProductData? productData;


}

class ProductData{
  ProductData.fromJson(dynamic json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;
}
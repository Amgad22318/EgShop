
import 'package:egshop/data/models/product_model.dart';

class CartModel {

  CartModel.fromJson(Map<String,dynamic>json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  dynamic message;
  Data? data;


}

class Data {


  Data.fromJson(Map<String,dynamic>json) {
    if (json['cart_items'] != null) {
      cartItems = [];
      json['cart_items'].forEach((v) {
        cartItems?.add(CartItems.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    total = json['total'];
  }
  List<CartItems>? cartItems;
  dynamic subTotal;
  dynamic total;


}

class CartItems {


  CartItems.fromJson(Map<String,dynamic>json) {
    id = json['id'];
    quantity = json['quantity'];
    product = json['product'] != null ? ProductData.fromJson(json['product']) : null;
  }
  int? id;
  int? quantity;
  ProductData? product;


}


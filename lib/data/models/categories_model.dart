class CategoriesModel {
  bool? status;
  dynamic message;
  CategoriesDataModel? data;

  CategoriesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  int? current_page;
  List<DataModel>? data;
  String? first_page_url;
  int? from;
  int? last_page;
  String? last_page_url;
  dynamic next_page_url;
  String? path;
  int? per_page;
  dynamic prev_page_url;
  int? to;
  int? total;

  CategoriesDataModel.fromJson(dynamic json) {
    current_page = json['current_page'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach(( element) {
        data!.add(DataModel.fromJson(element));
      });
    }

    first_page_url = json['first_page_url'];
    from = json['from'];
    last_page = json['last_page'];
    last_page_url = json['last_page_url'];
    next_page_url = json['next_page_url'];
    path = json['path'];
    per_page = json['per_page'];
    prev_page_url = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class DataModel {
  DataModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  int? id;
  String? name;
  String? image;
}

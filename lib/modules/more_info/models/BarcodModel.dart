import 'dart:convert';
/// data : [{"id":11,"img_link":"https://restulocales.arrowscars.com/storage/imgs/y7b42yskv43l_restu_locales/cropped912345626654284046_1666370145.jpg","active":1,"created_at":"2022-10-21T16:35:46.000000Z","updated_at":"2022-10-21T16:35:46.000000Z"},{"id":12,"img_link":"https://restulocales.arrowscars.com/storage/imgs/y7b42yskv43l_restu_locales/cropped4871311505507681403_1666370336.jpg","active":1,"created_at":"2022-10-21T16:38:56.000000Z","updated_at":"2022-10-21T16:38:56.000000Z"}]
/// msg : "all barcodes"
/// status : true

BarcodModel barcodModelFromJson(String str) => BarcodModel.fromJson(json.decode(str));
String barcodModelToJson(BarcodModel data) => json.encode(data.toJson());
class BarcodModel {
  BarcodModel({
      List<Data>? data, 
      String? msg, 
      bool? status,}){
    _data = data;
    _msg = msg;
    _status = status;
}

  BarcodModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _msg = json['msg'];
    _status = json['status'];
  }
  List<Data>? _data;
  String? _msg;
  bool? _status;
BarcodModel copyWith({  List<Data>? data,
  String? msg,
  bool? status,
}) => BarcodModel(  data: data ?? _data,
  msg: msg ?? _msg,
  status: status ?? _status,
);
  List<Data>? get data => _data;
  String? get msg => _msg;
  bool? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['msg'] = _msg;
    map['status'] = _status;
    return map;
  }

}

/// id : 11
/// img_link : "https://restulocales.arrowscars.com/storage/imgs/y7b42yskv43l_restu_locales/cropped912345626654284046_1666370145.jpg"
/// active : 1
/// created_at : "2022-10-21T16:35:46.000000Z"
/// updated_at : "2022-10-21T16:35:46.000000Z"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      int? id, 
      String? imgLink, 
      int? active, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _imgLink = imgLink;
    _active = active;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _imgLink = json['img_link'];
    _active = json['active'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _imgLink;
  int? _active;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  int? id,
  String? imgLink,
  int? active,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  imgLink: imgLink ?? _imgLink,
  active: active ?? _active,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  int? get id => _id;
  String? get imgLink => _imgLink;
  int? get active => _active;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['img_link'] = _imgLink;
    map['active'] = _active;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}
import 'package:arrows/modules/product_details/models/drinks_model.dart';
import 'package:arrows/modules/sub_categories/models/SubCategories.dart';
import 'package:flutter/material.dart';






class NewCartModel2 {
  String? id;
  String? photo;
  String? name;
  String? price;
  String? message;
  String? quantity;
  String? total_price;
  List<Drink>?  other_additional;
  String? drinks;
  String? spices;
  List<Components>? components;
  List<Sauces>? sauces;
  List <Additional> ?additional;
  String? sizes;
  String? category;
  NewCartModel2(
      {this.id,
        this.photo,
        this.name,
        this.message,
        this.price,
        this.additional,
        this.components,
        this.sauces,
        this.quantity,
        this.sizes,
        this.drinks,
        this.spices,
        this.total_price,
        this.other_additional,
        this.category,
        List<Components>? comp

      });

  NewCartModel2.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    photo = json['image'];
    name = json['name'];
    price = json['price'];
    // additional = json['additional'];
    // components = json['components'];
    message = json['message'];
    // sauces = json['sauces'];
    quantity = json['quantity'];
    sizes = json['sizes'];
    drinks = json['drinks'];
    total_price = json['total_price'];
    spices = json['spices'];
    category = json['category_id'];
    // other_additional = json['other_additional'];
    if (json['components'] != null) {
      components = [];
      json['components'].forEach((v) {
        components?.add(Components.fromJson(v));
      });
    }
    if (json['additional'] != null) {//don't forget
      additional = [];
      json['additional'].forEach((v) {
        additional?.add(Additional.fromJson(v));
      });
    }
    if (json['sauces'] != null) {
      sauces = [];
      json['sauces'].forEach((v) {
        sauces?.add(Sauces.fromJson(v));
      });
    }  if (json['other_additional'] != null) {
      other_additional = [];
      json['other_additional'].forEach((v) {
        other_additional?.add(Drink.fromJson(v));
      });
    }




   }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.photo;
      data['quantity'] = this.quantity;
    data['sizes'] = this.sizes;
    data['message'] = this.message;
    data['drinks'] = this.drinks;
    data['total_price'] = this.total_price;
    data['category'] = this.category;
    data['spices'] = this.spices;

    if (this.components != null) {
      data['components'] = this.components!.map((v) => v.toJson()).toList();
    }

    if (additional != null) {
      data['additional'] = additional!.map((v) => v.toJson()).toList();
    }
    if (sauces != null) {
      data['sauces'] = sauces!.map((v) => v.toJson()).toList();
    }
    if (other_additional != null) {
      data['other_additional'] = other_additional?.map((v) => v.toJson()).toList();
    }







    return data;
  }

  NewCartModel2.fromMap2(Map <dynamic ,dynamic >map){
    name=map['name'];
    category=map['category_id'];
    components =map['components'];
    photo =map['image'];
    total_price =map['total_price'];
    spices =map['spices'];
    quantity =map['quantity'];
    additional =map['additional'];
    drinks =map['drinks'];
    message =map['message'];
    sauces =map['sauces'];
    price =map['price'];
    sizes =map['sizes'];
    id =map['id'];
    other_additional =map['other_additional'];
   }
}


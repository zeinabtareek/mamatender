
class SubCategories {
  SubCategories({
      List<Products>? data,
      String? msg, 
      num? nextPage, 
      bool? status,}){
    _data = data;
    _msg = msg;
    _nextPage = nextPage;
    _status = status;
}

  SubCategories.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Products.fromJson(v));
      });
    }
    _msg = json['msg'];
    _nextPage = json['nextPage'];
    _status = json['status'];
  }
  List<Products>? _data;
  String? _msg;
  num? _nextPage;
  bool? _status;
SubCategories copyWith({  List<Products>? data,
  String? msg,
  num? nextPage,
  bool? status,
}) => SubCategories(  data: data ?? _data,
  msg: msg ?? _msg,
  nextPage: nextPage ?? _nextPage,
  status: status ?? _status,
);
  List<Products>? get data => _data;
  String? get msg => _msg;
  num? get nextPage => _nextPage;
  bool? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['msg'] = _msg;
    map['nextPage'] = _nextPage;
    map['status'] = _status;
    return map;
  }

}


class Products {

  Products({
      num? id,
      String? name, 
      List<Components>? components, 
      List<Sizes>?  sizes,
      List<Additional>? additional, 
      List<Sauces>? sauces,
      String? totalPrice,
      String? quantity,
      List<Drinks>? drinks,
      List<Spices>? spices, 
      num? availability, 
      String? photo,
      String? sizes2,
      String? spices2 ,
      String?drinks2,

      String? fIdd,
this.componentss,
       num? categoryId,}){
    _id = id;
    _name = name;
    _components = components;
    _sizes = sizes;
    _sizes2 = sizes2;
    _additional = additional;
    _sauces = sauces;
    _drinks = drinks;
    _drinks2 = drinks2;
    _totalPrice = totalPrice;
    _spices = spices;
    _spices2 = spices2;
    _quantity = quantity;
    _availability = availability;
    _photo = photo;
    _categoryId = categoryId;

  }



  Products.fromJson2(dynamic json) {
    _id = json['id'];
    componentss = json['componentss'];
    _name = json['name'];
    _quantity = json['quantity'];
    _fId = json['fId'];
    _totalPrice = json['totalPrice'];
    if (json['components'] != null) {
      _components = [];
      json['components'].forEach((v) {
        _components?.add(Components.fromJson(v));
      });
    }
    // if (json['sizes'] != null) {
    //   _sizes = [];
    //   json['sizes'].forEach((v) {
    //     _sizes?.add(Sizes.fromJson(v));
    //   });
    // }


    _sizes2 = json['sizes'];
    _spices2 = json['spices'];
    _drinks2 = json['drinks'];

    if (json['additional'] != null) {
      _additional = [];
      json['additional'].forEach((v) {
        _additional?.add(Additional.fromJson(v));
      });
    }
    if (json['sauces'] != null) {
      _sauces = [];
      json['sauces'].forEach((v) {
        _sauces?.add(Sauces.fromJson(v));
      });
    }
    // if (json['drinks'] != null) {
    //   _drinks = [];
    //   json['drinks'].forEach((v) {
    //     _drinks?.add(Drinks.fromJson(v));
    //   });
    // }
    // if (json['spices'] != null) {
    //   _spices = [];
    //   json['spices'].forEach((v) {
    //     _spices?.add(Spices.fromJson(v));
    //   });
    // }
    _availability = json['availability'];
    _photo = json['photo'];
    _categoryId = json['category_id'];
  }

  Products.fromJson(dynamic json) {
    _id = json['id'];
    componentss = json['componentss'];
    _name = json['name'];
    _quantity = json['quantity'];
    _fId = json['fId'];
    _totalPrice = json['totalPrice'];
    if (json['components'] != null) {
      _components = [];
      json['components'].forEach((v) {
        _components?.add(Components.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      _sizes = [];
      json['sizes'].forEach((v) {
        _sizes?.add(Sizes.fromJson(v));
      });
    }
    if (json['additional'] != null) {
      _additional = [];
      json['additional'].forEach((v) {
        _additional?.add(Additional.fromJson(v));
      });
    }
    if (json['sauces'] != null) {
      _sauces = [];
      json['sauces'].forEach((v) {
        _sauces?.add(Sauces.fromJson(v));
      });
    }
    if (json['drinks'] != null) {
      _drinks = [];
      json['drinks'].forEach((v) {
        _drinks?.add(Drinks.fromJson(v));
      });
    }
    if (json['spices'] != null) {
      _spices = [];
      json['spices'].forEach((v) {
        _spices?.add(Spices.fromJson(v));
      });
    }
    _availability = json['availability'];
    _photo = json['photo'];
    _categoryId = json['category_id'];
  }


  num? _id;
  String? _name;
  List<Components>? _components;
  List<Sizes>? _sizes;
  List<Additional>? _additional;
  List<Sauces>? _sauces;
  String? _totalPrice;
  String? _sizes2;

  String? _spices2;
  String? _drinks2;

  List<Drinks>? _drinks;
  List<Spices>? _spices;
  num? _availability;
  List<Components>?   componentss;

  String? _photo;
  String? _fId;
  String? _quantity;
  num? _categoryId;
 Products copyWith({  num? id,
  String? name,
  List<Components>? components,
  List<Sizes>? sizes,
  List<Additional>? additional,
  List<Sauces>? sauces,
  List<Drinks>? drinks,
   String? drinks2,
   String? spices2,
   String? totalPrice,
   String? quantity,

   List<Spices>? spices,
  num? availability,
  String? photo,
  String?   sizes2,
  num? categoryId,
}) => Products(  id: id ?? _id,
  name: name ?? _name,
  components: components ?? _components,
  sizes: sizes ?? _sizes,
  additional: additional ?? _additional,
  sauces: sauces ?? _sauces,
  drinks: drinks ?? _drinks,
  drinks2: drinks2 ?? _drinks2,
  totalPrice : totalPrice ?? _totalPrice,
  spices: spices ?? _spices,
  spices2: spices2 ?? _spices2,
  availability: availability ?? _availability,
  photo: photo ?? _photo,
   sizes2: sizes2 ?? _sizes2,
   quantity: quantity ?? _quantity,
  categoryId: categoryId ?? _categoryId,
);
  num? get id => _id;
  String? get name => _name;
  String? get fId => _fId;
  String? get drinks2 => _drinks2;
  String? get spices2 => _spices2;
  List<Components>? get components => _components;
  List<Sizes>? get sizes => _sizes;
  List<Additional>? get additional => _additional;
  List<Sauces>? get sauces => _sauces;
  List<Drinks>? get drinks => _drinks;

  List<Spices>? get spices => _spices;
  num? get availability => _availability;
  String? get photo => _photo;
  String? get sizes2 => _sizes2;
  String? get totalPrice   => _totalPrice;
  String? get quantity   => _quantity;
  num? get categoryId => _categoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['totalPrice'] = _totalPrice;
    map['name'] = _name;
    map['quantity'] = _quantity;
    if (_components != null) {
      map['components'] = _components?.map((v) => v.toJson()).toList();
    }


    if (this.componentss != null) {
      map['componentss'] = this.componentss!.map((v) => v.toJson()).toList();
    }
    if (_sizes != null) {
      map['sizes'] = _sizes?.map((v) => v.toJson()).toList();
    }
    if (_additional != null) {
      map['additional'] = _additional?.map((v) => v.toJson()).toList();
    }
    if (_sauces != null) {
      map['sauces'] = _sauces?.map((v) => v.toJson()).toList();
    }
    if (_drinks != null) {
      map['drinks'] = _drinks?.map((v) => v.toJson()).toList();
    }
    if (_spices != null) {
      map['spices'] = _spices?.map((v) => v.toJson()).toList();
    }
    map['availability'] = _availability;
    map['photo'] = _photo;
    map['category_id'] = _categoryId;
    return map;
  }

}

/// id : 1
/// name : "Hot"

class Spices {
  Spices({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Spices.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
Spices copyWith({  num? id,
  String? name,
}) => Spices(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}

/// id : 1
/// name : "Cola"

class Drinks {
  Drinks({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Drinks.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
Drinks copyWith({  num? id,
  String? name,
}) => Drinks(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}

/// id : 1
/// name : "Ketchup"vmmvb

class Sauces {
  Sauces({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Sauces.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
Sauces copyWith({  num? id,
  String? name,
}) => Sauces(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}

/// addition : "Cheese"
/// id : 1
/// price : "15"

class Additional {
  Additional({
      String? addition, 
      num? id, 
      String? price,}){
    _addition = addition;
    _id = id;
    _price = price;
}

  Additional.fromJson(dynamic json) {
    _addition = json['addition'];
    _id = json['id'];
    _price = json['price'];
  }
  String? _addition;
  num? _id;
  String? _price;
Additional copyWith({  String? addition,
  num? id,
  String? price,
}) => Additional(  addition: addition ?? _addition,
  id: id ?? _id,
  price: price ?? _price,
);
  String? get addition => _addition;
  num? get id => _id;
  String? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addition'] = _addition;
    map['id'] = _id;
    map['price'] = _price;
    return map;
  }

}

/// id : 1
/// price : "25"
/// size : "Small"

class Sizes {
  Sizes({
      num? id, 
      String? price, 
      String? size,}){
    _id = id;
    _price = price;
    _size = size;
}

  Sizes.fromJson(dynamic json) {
    _id = json['id'];
    _price = json['price'];
    _size = json['size'];
  }
  num? _id;
  String? _price;
  String? _size;
Sizes copyWith({  num? id,
  String? price,
  String? size,
}) => Sizes(  id: id ?? _id,
  price: price ?? _price,
  size: size ?? _size,
);
  num? get id => _id;
  String? get price => _price;
  String? get size => _size;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['price'] = _price;
    map['size'] = _size;
    return map;
  }

}

/// id : 1
/// name : "Burger"/&&&&&&&

class Components {
  Components({
      num? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Components.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  num? _id;
  String? _name;
Components copyWith({  num? id,
  String? name,
}) => Components(  id: id ?? _id,
  name: name ?? _name,
);
  num? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}


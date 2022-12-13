// class ProductFireBase {
//   String? image;
//   String? category;
//   String? name;
//   String? quantity;
//   String? price;
//   int? id;
//   String? totalPrice;
//   // List<Sizes>? sizes;
//   String? sizes;
//   // List<Content>? components;
//   // List<AddsList>? addsList;
//   // List<ListOfDrinks>? listOfDrinks;
//
//   ProductFireBase(
//       {this.image,
//         this.category,
//         this.name,
//         this.quantity,
//         this.price,
//         this.id,
//         this.totalPrice,
//         this.sizes,
//         // this.components,
//         // this.addsList,
//         // this.listOfDrinks
//       });
//
//   ProductFireBase.fromJson(Map<dynamic, dynamic> json) {
//     image = json['image'];
//     category = json['category'];
//     name = json['name'];
//     quantity = json['quantity'];
//     price = json['price'];
//     id = json['id'];
//     totalPrice = json['total_price'];
//     sizes = json['sizes'];
//     // if (json['sizes'] != null) {
//     //   sizes = <Sizes>[];
//     //   json['sizes'].forEach((v) {
//     //     sizes!.add(new Sizes.fromJson(v));
//     //   });
//     // }
//     // if (json['components'] != null) {
//     //   components = <Content>[];
//     //   json['components'].forEach((v) {
//     //     components!.add(new Content.fromJson(v));
//     //   });
//     // }
//     // if (json['addsList'] != null) {
//     //   addsList = <AddsList>[];
//     //   json['addsList'].forEach((v) {
//     //     addsList!.add(new AddsList.fromJson(v));
//     //   });
//     // }
//     // if (json['list_of_drinks'] != null) {
//     //   listOfDrinks = <ListOfDrinks>[];
//     //   json['list_of_drinks'].forEach((v) {
//     //     listOfDrinks!.add(new ListOfDrinks.fromJson(v));
//     //   });
//     // }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['image'] = this.image;
//     data['category'] = this.category;
//     data['name'] = this.name;
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     data['id'] = this.id;
//     data['total_price'] = this.totalPrice;
//     // if (this.sizes != null) {
//     //   data['sizes'] = this.sizes!.map((v) => v.toJson()).toList();
//     // }
//     // if (this.components != null) {
//     //   data['components'] = this.components!.map((v) => v.toJson()).toList();
//     // }
//     // if (this.addsList != null) {
//     //   data['addsList'] = this.addsList!.map((v) => v.toJson()).toList();
//     // }
//     // if (this.listOfDrinks != null) {
//     //   data['list_of_drinks'] =
//     //       this.listOfDrinks!.map((v) => v.toJson()).toList();
//     // }
//     return data;
//   }
// }
//
// class Sizes {
//   String? size;
//   String? price;
//   bool? isNeed;
//
//   Sizes({this.size, this.price, this.isNeed});
//
//   Sizes.fromJson(Map<dynamic, dynamic> json) {
//     size = json['size'];
//     price = json['price'];
//     isNeed = json['is_need'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['size'] = this.size;
//     data['price'] = this.price;
//     data['is_need'] = this.isNeed;
//     return data;
//   }
// }
//
// class Content {
//   String? name;
//   bool? need;
//
//   Content({this.name, this.need});
//
//   Content.fromJson(Map<dynamic, dynamic> json) {
//     name = json['name'];
//     need = json['need'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['need'] = this.need;
//     return data;
//   }
// }
//
// class AddsList {
//   String? adds;
//   String? price;
//   bool? isNeed;
//   String? addsFromApi;
//
//   AddsList({this.adds, this.price, this.isNeed, this.addsFromApi});
//
//   AddsList.fromJson(Map<dynamic, dynamic> json) {
//     addsFromApi = json['addition'];
//     adds = json['adds'];
//     price = json['price'];
//     isNeed = json['is_need'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['adds'] = this.adds;
//     data['price'] = this.price;
//     data['is_need'] = this.isNeed;
//     return data;
//   }
// }
//
// class ListOfDrinks {
//   String? name;
//   String? price;
//   int? id;
//   bool? isNeed;
//
//   ListOfDrinks({this.name, this.price, this.id, this.isNeed});
//
//   ListOfDrinks.fromJson(Map<dynamic, dynamic> json) {
//     name = json['name'];
//     price = json['price'];
//     id = json['id'];
//     isNeed = json['is_need'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['price'] = this.price;
//     data['id'] = this.id;
//     data['is_need'] = this.isNeed;
//     return data;
//   }
// }

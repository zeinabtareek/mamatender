class BarCodeUsedBody{
  int? barcode_id;
  String? phone_number;

  BarCodeUsedBody({
    this.barcode_id,
    this.phone_number,
  });

  BarCodeUsedBody.fromJson(Map<String , dynamic> json){
    barcode_id = json['barcode_id'];
    phone_number = json['phone_number'];
  }

  Map<String , dynamic> toJson(){
    final Map<String , dynamic> data = {};
    data['barcode_id'] = barcode_id;
    data['phone_number'] = phone_number;

    return data;
  }
}
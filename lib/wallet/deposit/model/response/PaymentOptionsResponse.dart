class PaymentOptionsResponse {
  int? payTypeId;
  String? payTypeCode;
  String? payTypeDispCode;
  double? minValue;
  double? maxValue;
  List<SubTypeMap>? subTypeMap;

  PaymentOptionsResponse(
      {this.payTypeId,
        this.payTypeCode,
        this.payTypeDispCode,
        this.minValue,
        this.maxValue,
        this.subTypeMap});

  PaymentOptionsResponse.fromJson(Map<String, dynamic> json) {
    payTypeId = json['payTypeId'];
    payTypeCode = json['payTypeCode'];
    payTypeDispCode = json['payTypeDispCode'];
    minValue = json['minValue'];
    maxValue = json['maxValue'];
    if (json['subTypeMap'] != null) {
      subTypeMap = <SubTypeMap>[];
      json['subTypeMap'].forEach((v) {
        subTypeMap!.add(new SubTypeMap.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payTypeId'] = this.payTypeId;
    data['payTypeCode'] = this.payTypeCode;
    data['payTypeDispCode'] = this.payTypeDispCode;
    data['minValue'] = this.minValue;
    data['maxValue'] = this.maxValue;
    if (this.subTypeMap != null) {
      data['subTypeMap'] = this.subTypeMap!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubTypeMap {
  dynamic id;
  String? value;
  String? currency;

  SubTypeMap({this.id, this.value, this.currency});

  SubTypeMap.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['currency'] = this.currency;
    return data;
  }
}

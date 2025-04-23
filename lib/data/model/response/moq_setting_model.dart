// class MoqSettingModel {
//   int? _productId;
//   int? _minimumOrderQuantity;
//
//   MoqSettingModel({int? productId, int? minimumOrderQuantity}) {
//     this._productId = productId;
//     this._minimumOrderQuantity = minimumOrderQuantity;
//   }
//
//   int? get productId => _productId;
//   int? get minimumOrderQuantity => _minimumOrderQuantity;
//
//   MoqSettingModel.fromJson(Map<String?, dynamic> json) {
//     _productId = json['product_id'];
//     _minimumOrderQuantity = json['minimum_order_quantity'];
//   }
//
//   Map<String?, dynamic> toJson() {
//     final Map<String?, dynamic> data = new Map<String?, dynamic>();
//     data['product_id'] = this._productId;
//     data['minimum_order_quantity'] = this._minimumOrderQuantity;
//     return data;
//   }
// }

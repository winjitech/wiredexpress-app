class BaseUrls {
  String? _productImageUrl;
  String? _customerImageUrl;
  String? _bannerImageUrl;
  String? _categoryImageUrl;
  String? _reviewImageUrl;
  String? _notificationImageUrl;
  String? _storeImageUrl;
  String? _contestImageUrl;
  String? _deliveryManImageUrl;
  String? _chatImageUrl;
  String? _electricianImageUrl;
  String? _contractorRequestAttachmentsUrl;

  BaseUrls({
    String? productImageUrl,
    String? customerImageUrl,
    String? bannerImageUrl,
    String? categoryImageUrl,
    String? reviewImageUrl,
    String? notificationImageUrl,
    String? storeImageUrl,
    String? contestImageUrl,
    String? deliveryManImageUrl,
    String? chatImageUrl,
    String? electricianImageUrl,
    String? contractorRequestAttachmentsUrl,
  }) {
    _productImageUrl = productImageUrl;
    _customerImageUrl = customerImageUrl;
    _bannerImageUrl = bannerImageUrl;
    _categoryImageUrl = categoryImageUrl;
    _reviewImageUrl = reviewImageUrl;
    _notificationImageUrl = notificationImageUrl;
    _storeImageUrl = storeImageUrl;
    _contestImageUrl = contestImageUrl;
    _deliveryManImageUrl = deliveryManImageUrl;
    _chatImageUrl = chatImageUrl;
    _electricianImageUrl = electricianImageUrl;
    _contractorRequestAttachmentsUrl = contractorRequestAttachmentsUrl;
  }

  String? get productImageUrl => _productImageUrl;
  String? get customerImageUrl => _customerImageUrl;
  String? get bannerImageUrl => _bannerImageUrl;
  String? get categoryImageUrl => _categoryImageUrl;
  String? get reviewImageUrl => _reviewImageUrl;
  String? get notificationImageUrl => _notificationImageUrl;
  String? get storeImageUrl => _storeImageUrl;
  String? get contestImageUrl => _contestImageUrl;
  String? get deliveryManImageUrl => _deliveryManImageUrl;
  String? get chatImageUrl => _chatImageUrl;
  String? get electricianImageUrl => _electricianImageUrl;
  String? get contractorRequestAttachmentsUrl =>
      _contractorRequestAttachmentsUrl;

  BaseUrls.fromJson(Map<String?, dynamic> json) {
    _productImageUrl = json['product_image_url'];
    _customerImageUrl = json['customer_image_url'];
    _bannerImageUrl = json['banner_image_url'];
    _categoryImageUrl = json['category_image_url'];
    _reviewImageUrl = json['review_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _storeImageUrl = json['store_image_url'];
    _contestImageUrl = json['contest_image_url'];
    _deliveryManImageUrl = json['delivery_man_image_url'];
    _chatImageUrl = json['chat_image_url'];
    _electricianImageUrl = json['electrician_image_url'];
    _contractorRequestAttachmentsUrl =
    json['contractor_request_attachments_url'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['product_image_url'] = _productImageUrl;
    data['customer_image_url'] = _customerImageUrl;
    data['banner_image_url'] = _bannerImageUrl;
    data['category_image_url'] = _categoryImageUrl;
    data['review_image_url'] = _reviewImageUrl;
    data['notification_image_url'] = _notificationImageUrl;
    data['store_image_url'] = _storeImageUrl;
    data['contest_image_url'] = _contestImageUrl;
    data['delivery_man_image_url'] = _deliveryManImageUrl;
    data['chat_image_url'] = _chatImageUrl;
    data['electrician_image_url'] = _electricianImageUrl;
    data['contractor_request_attachments_url'] =
        _contractorRequestAttachmentsUrl;
    return data;
  }
}
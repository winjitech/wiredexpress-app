class ContractorRequestModel {
  int? _id;
  int? _userId;
  String? _type;
  String? _messageOrItems;
  String? _attachment;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  ContractorRequestModel({
    int? id,
    int? userId,
    String? type,
    String? messageOrItems,
    String? attachment,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _type = type;
    _messageOrItems = messageOrItems;
    _attachment = attachment;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get userId => _userId;
  String? get type => _type;
  String? get messageOrItems => _messageOrItems;
  String? get attachment => _attachment;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  ContractorRequestModel.fromJson(Map<String?, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _type = json['type'];
    _messageOrItems = json['message_or_items'];
    _attachment = json['attachment'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = Map<String?, dynamic>();
    data['id'] = _id;
    data['user_id'] = _userId;
    data['type'] = _type;
    data['message_or_items'] = _messageOrItems;
    data['attachment'] = _attachment;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

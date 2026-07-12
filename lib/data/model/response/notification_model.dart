class NotificationBody {
  int? _totalSize;
  String? _limit;
  String? _offset;
  int? _unreadCount;
  List<NotificationModel>? _notifications;

  NotificationBody({
    int? totalSize,
    String? limit,
    String? offset,
    int? unreadCount,
    List<NotificationModel>? notifications,
  }) {
    _totalSize = totalSize;
    _limit = limit;
    _offset = offset;
    _unreadCount = unreadCount;
    _notifications = notifications;
  }

  int? get totalSize => _totalSize;
  String? get limit => _limit;
  String? get offset => _offset;
  int? get unreadCount => _unreadCount;
  List<NotificationModel>? get notifications => _notifications;

  NotificationBody.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit']?.toString();
    _offset = json['offset'];
    _unreadCount = json['unread_count'];

    if (json['notifications'] != null) {
      _notifications = [];
      json['notifications'].forEach((v) {
        _notifications!.add(NotificationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total_size'] = _totalSize;
    data['limit'] = _limit;
    data['offset'] = _offset;
    data['unread_count'] = _unreadCount;

    if (_notifications != null) {
      data['notifications'] =
          _notifications!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class NotificationModel {
  int? id;
  int? userId;
  int? driverId;
  int? itemId;
  String? title;
  String? description;
  String? screenType;
  bool? read;
  String? createdAt;

  NotificationModel({
    this.id,
    this.userId,
    this.driverId,
    this.itemId,
    this.title,
    this.description,
    this.screenType,
    this.read,
    this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    driverId = json['driver_id'];
    itemId = json['item_id'];
    title = json['title'];
    description = json['description'];
    screenType = json['screen_type'];
    read = json['read'] == 1;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['user_id'] = userId;
    data['driver_id'] = driverId;
    data['item_id'] = itemId;
    data['title'] = title;
    data['description'] = description;
    data['screen_type'] = screenType;
    data['read'] = read;
    data['created_at'] = createdAt;
    return data;
  }
}
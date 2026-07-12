import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/data/repository/notification_repo.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo? repo;
  NotificationProvider({@required this.repo});
  int? _totalNotificationsSize;
  int? get totalNotificationsSize => _totalNotificationsSize;

  int? _totalUnreadNotificationsSize;
  int? get totalUnreadNotificationsSize => _totalUnreadNotificationsSize;

  String? _notificationsOffset;
  String? get notificationsOffset => _notificationsOffset;

  List<NotificationModel>? _notificationsList = [];
  List<NotificationModel>? get notificationsList => _notificationsList;

  List<String> _notificationsOffsetList = [];

  bool _notificationsIsLoading = false;
  bool get notificationsIsLoading => _notificationsIsLoading;

  bool _bottomNotificationsLoading = false;
  bool get bottomNotificationsLoading => _bottomNotificationsLoading;
  Future<void> getNotifications(
      BuildContext context,
      String offset, {
        bool? isLoading = true,
      }) async {
    if (offset == '1' && isLoading!) {
      _notificationsIsLoading = true;
    }
    if (!_notificationsOffsetList.contains(offset)) {
      _notificationsOffsetList.add(offset);
      ApiResponse apiResponse = await repo!.fetchNotifications(offset);

      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _bottomNotificationsLoading = false;

        if (offset == '1') {
          _notificationsList = [];
        }
        _totalNotificationsSize = NotificationBody.fromJson(
          apiResponse.response!.data,
        ).totalSize;
        _totalUnreadNotificationsSize = NotificationBody.fromJson(
          apiResponse.response!.data,
        ).unreadCount;
        _notificationsList!.addAll(
          NotificationBody.fromJson(apiResponse.response!.data).notifications!,
        );
        _notificationsOffset = NotificationBody.fromJson(
          apiResponse.response!.data,
        ).offset;
        _notificationsIsLoading = false;
      } else {
        _bottomNotificationsLoading = false;
        _notificationsIsLoading = false;
      }
    } else {
      if (_notificationsIsLoading) {
        _bottomNotificationsLoading = false;
        _notificationsIsLoading = false;
        //notifyListeners();
      }
    }
    notifyListeners();
  }

  void clearNotificationsOffset() {
    _notificationsOffsetList.clear();
    _notificationsList!.clear();
    notifyListeners();
  }

  void showBottomNotificationsLoader() {
    _bottomNotificationsLoading = true;
    notifyListeners();
  }

  bool? _markAsReadLoading = false;
  bool? get markAsReadLoading => _markAsReadLoading;

  Future<ResponseModel> markAsRead(
      BuildContext? context,
      int notificationId,
      ) async {
    _markAsReadLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await repo!.markAsRead(notificationId);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      int index = _notificationsList!.indexWhere(
            (element) => element.id == notificationId,
      );

      if (index != -1) {
        _notificationsList![index].read = true;

        if (_totalUnreadNotificationsSize != null &&
            _totalUnreadNotificationsSize! > 0) {
          _totalUnreadNotificationsSize = _totalUnreadNotificationsSize! - 1;
        }
      }

      _markAsReadLoading = false;
      notifyListeners();

      return ResponseModel(true, 'successful');
    } else {
      _markAsReadLoading = false;
      notifyListeners();

      return ResponseModel(false, 'failed');
    }
  }
}

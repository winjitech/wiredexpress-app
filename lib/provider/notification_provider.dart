import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/notification_model.dart';
import 'package:wired_express/data/repository/notification_repo.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo? notificationRepo;
  NotificationProvider({@required this.notificationRepo});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList;
      // != null
      // ? _notificationList!.reversed.toList()
      // : _notificationList;
  bool? _loading = false;
  bool? get loading => _loading;
  Future<void> initNotificationList(BuildContext? context) async {
    _loading = true;

    ApiResponse apiResponse = await notificationRepo!.getNotificationList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _loading = false;

      _notificationList = [];
      apiResponse.response!.data!.forEach((notificatioModel) =>
          _notificationList!.add(NotificationModel.fromJson(notificatioModel)));
      notifyListeners();
    } else {
      //  ApiChecker.checkApi(context, apiResponse);
    }
  }
}

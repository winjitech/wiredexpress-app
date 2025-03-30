import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/helper/connection_checker.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/base/api_response.dart';
import 'package:wired_express/data/model/response/chat_model.dart';
import 'package:wired_express/data/repository/chat_repo.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  ChatProvider({@required this.chatRepo});

  List<ChatModel>? _chatList;

  List<ChatModel> _savedChatList = [];

  List<bool>? _showDate;

  List<DateTime>? _dateList;

  File? _imageFile;

  bool _isSendButtonActive = false;

  bool _status = true;

  bool _imageLoading = false;
  bool get imageLoading => _imageLoading;

  List<ChatModel>? get chatList => _chatList != null ? _chatList!.reversed.toList() : _chatList;

  List<ChatModel> get savedChatList => _savedChatList != null ? _savedChatList.reversed.toList() : _savedChatList;
  List<bool>? get showDate => _showDate != null ? _showDate!.reversed.toList() : _showDate;

  File? get imageFile => _imageFile;
  bool? get isSendButtonActive => _isSendButtonActive;
  bool get status => _status;

  // Chat History
  bool _loadingHistory = false;
  bool get loadingHistory => _loadingHistory;

  bool _bottomLoadingHistory = false;
  bool get bottomLoadingHistory => _bottomLoadingHistory;

  int? _totalChatHistorySize;
  int? get totalChatHistorySize => _totalChatHistorySize;

  String? _offsetHistory;
  String? get offsetHistory => _offsetHistory;

  bool _wait = false;
  bool get wait => _wait;

  DateTime? _lastRefreshDate = DateTime.now();
  DateTime? get lastRefreshDate => _lastRefreshDate;

  List<String> _offsetHistoryList = [];

  void getChatList(BuildContext? context) async {
    _chatList = null;
    _imageFile = null;
    ApiResponse apiResponse = await chatRepo!.getChatList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _lastRefreshDate = DateTime.now();
      _status = true;
      _chatList = [];
      _showDate = [];
      _dateList = [];
      List<dynamic> _chats = apiResponse.response!.data[0].reversed.toList();
      _chats.forEach((chat) {
        ChatModel chatModel = ChatModel.fromJson(chat);
        DateTime _originalDateTime = DateConverter.isoStringToLocalDate(chatModel.createdAt!);
        DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
        bool _addDate = false;
        if(!_dateList!.contains(_convertedDate)) {
          _addDate = true;
          _dateList!.add(_convertedDate);
        }
        _chatList!.add(chatModel);
        if(_chatList!= null){
          _savedChatList = _chatList!;
        }
        _showDate!.add(_addDate);
      });
      notifyListeners();
    } else {
     // ApiChecker.checkApi(context, apiResponse);
      _status = false;
      notifyListeners();
     ConnectionChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> sendMessage(String message, String token, String userID, BuildContext? context) async {
    http.StreamedResponse response = await chatRepo!.sendMessage(message, token);
    if (response.statusCode == 200) {
      if(_imageFile != null) {
        getChatList(context);
      }else {
        ChatModel _chatModel = ChatModel(
          userId: int.parse(userID), image: null, message: message, reply: null,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        DateTime _originalDateTime = DateConverter.isoStringToLocalDate(_chatModel.createdAt!);
        DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
        bool _addDate = false;
        if(!_dateList!.contains(_convertedDate)) {
          _addDate = true;
          _dateList!.add(_convertedDate);
        }
        _chatList!.add(_chatModel);
        _showDate!.add(_addDate);
      }
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    _imageFile = null;
    _isSendButtonActive = false;
    notifyListeners();
  }

  Future<ResponseModel> sendImage(BuildContext context,File file, String token, String message) async {
      _imageLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response = await chatRepo!.sendImage(file, token, message,);
    // _isLoading = false;

    if (response.statusCode == 200) {
      _imageLoading = false;
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _responseModel = ResponseModel(true, message);
      getChatList(context);
      print(message);
    } else {
      _imageLoading = false;
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImage(File image) {
    _imageFile = image;
    notifyListeners();
  }

  Future<List<ChatModel>> refresh(BuildContext context, bool instantly) async{
    print('chat test -1');
    DateTime now = DateTime.now();
    DateTime _lastFiveSeconds = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second - 5);
    if(instantly == false) {
      if (_lastFiveSeconds.compareTo(lastRefreshDate!) > 0) {
        getChatList(context);
      }
    }else {
      getChatList(context);
    }
    Timer(Duration(seconds: 2), () {

    });
    return chatList!;
  }

  void showBottomLoaderHistory() {
    _bottomLoadingHistory = true;
    notifyListeners();
  }


  void clearOffset() {
    _offsetHistoryList.clear();
    notifyListeners();
  }

  void waitFunc(bool wait) {
    _wait = wait;
    notifyListeners();
  }
}
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/response_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/deliveryman_chat_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../base/border_button.dart';

class SendImageDm extends StatefulWidget {
  final String? orderId;
  SendImageDm({@required this.orderId});
  @override
  _SendImageDmState createState() => _SendImageDmState();
}

class _SendImageDmState extends State<SendImageDm> {
  TextEditingController? _messageController;

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        Provider.of<DeliveryManChatProvider>(context, listen: false)
            .setImage(file!);
      } else {
        print('No image selected.');
      }
    });
  }

  File? file;
  PickedFile? data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _choose();
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
        key: _scaffoldKey,
        appBar: CustomAppBar(title: getTranslated('send_image', context)),
        body: Consumer<DeliveryManChatProvider>(
          builder: (context, DeliveryManChatProvider, child) {
            return DeliveryManChatProvider.imageLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getTranslated('sending_image', context),
                          style:
                              TextStyle(color: Colors.black87, fontSize: 15)),
                      SizedBox(height: 10),
                      Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor)))
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: 100),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            _choose();
                          },
                          child: Container(
                            width: 250,
                            height: 250,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorResources.BORDER_COLOR,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorResources.COLOR_GREY_CHATEAU,
                                  width: 3),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: file != null
                                      ? Image.file(file!,
                                          width: 250,
                                          height: 250,
                                          fit: BoxFit.fill)
                                      : SizedBox(),
                                ),
                                Positioned(
                                  bottom: 15,
                                  right: -10,
                                  child: InkWell(
                                      onTap: _choose,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorResources.BORDER_COLOR,
                                          border: Border.all(
                                              width: 2,
                                              color: ColorResources
                                                  .COLOR_GREY_CHATEAU),
                                        ),
                                        child: Icon(Icons.edit, size: 13),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Container(
                            width: 260,
                            child: TextField(
                              controller: _messageController,
                              textCapitalization: TextCapitalization.sentences,
                              style: rubikMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText:
                                    getTranslated('type_message_here', context),
                                hintStyle: rubikRegular.copyWith(
                                    color: ColorResources.getGreyBunkerColor(
                                        context),
                                    fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (file == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          getTranslated('warning', context)),
                                      content: Text(getTranslated(
                                          'please_insert_image', context)),
                                      actions: <Widget>[
                                        Center(
                                          child: BorderButton(
                                            text:
                                                getTranslated('close', context),
                                            textColor: Colors.red,
                                            borderColor: Colors.red,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),

                                        // FlatButton(
                                        //   child: Text("Close"),
                                        //   onPressed: () {
                                        //     Navigator.of(context).pop();
                                        //   },
                                        // ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                String _finalMessage;
                                String _message =
                                    _messageController!.text.toString();
                                if (_message.isEmpty) {
                                  _finalMessage = '';
                                } else {
                                  _finalMessage =
                                      _messageController!.text.trim();
                                }
                                ResponseModel _responseModel =
                                    await DeliveryManChatProvider.sendImage(
                                        context,
                                        file!,
                                        Provider.of<CustomAuthProvider>(context,
                                                listen: false)
                                            .getUserToken()!,
                                        _finalMessage,
                                        widget.orderId!);
                                if (_responseModel.isSuccess) {
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'image_not_send_text', context)),
                                          backgroundColor: Colors.red));
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Image.asset(
                                Images.send,
                                width: 25,
                                height: 25,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
          },
        ));
  }
}

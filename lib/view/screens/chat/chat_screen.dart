import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/auth_provider.dart';
import 'package:wired_express/provider/chat_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/not_logged_in_screen.dart';
import 'package:wired_express/view/screens/chat/widget/message_bubble.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ImagePicker picker = ImagePicker();

  final TextEditingController _controller = TextEditingController();
  Timer? timer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) => newMessage());
  }

  Future<void> newMessage() {
    return Provider.of<ChatProvider>(context, listen: false)
        .refresh(context, false);
    // MessageBubble(chat: chat.chatList[index], addDate: chat.showDate[index]);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn =
        Provider.of<CustomAuthProvider>(context, listen: false).isLoggedIn()!;
    // if(_isLoggedIn) {
    // Provider.of<ChatProvider>(context, listen: false).getChatList(context);
    // }

    Future.delayed(
        const Duration(
          seconds: 5,
          milliseconds: 500,
        ), () {
      if (this.mounted) {
        setState(() {
          newMessage();
        });
      }
    });

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(title: getTranslated('message', context)),
      body: _isLoggedIn
          ? Consumer<ChatProvider>(
              builder: (context, chat, child) {
                print('status----${chat.status}');
                return Column(children: [
                  chat.status
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                                  getTranslated('status_offline', context),
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14))),
                        ),
                  Expanded(
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      displacement: 0,
                      color: ColorResources.getCardColor(context),
                      backgroundColor: ColorResources.getPrimaryColor(context),
                      onRefresh: () {
                        return chat.refresh(context, true);
                      },
                      child: chat.chatList != null
                          ? chat.chatList!.length > 0
                              ? Scrollbar(
                                  child: SingleChildScrollView(
                                    reverse: true,
                                    physics: BouncingScrollPhysics(),
                                    child: Center(
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          itemCount: chat.chatList!.length,
                                          reverse: true,
                                          itemBuilder: (context, index) {
                                            return MessageBubble(
                                                chat: chat.chatList![index],
                                                addDate: chat.showDate![index]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                          : SingleChildScrollView(
                              reverse: true,
                              physics: BouncingScrollPhysics(),
                              child: Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    itemCount: chat.savedChatList.length,
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      return MessageBubble(
                                          chat: chat.savedChatList[index],
                                          addDate: chat.showDate![index]);
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),

                  // Bottom TextField
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 100),
                              child: Ink(
                                color:
                                    ColorResources.getScaffoldBackgroundColor(
                                        context),
                                child: Row(children: [
                                  // GestureDetector(
                                  //   onTap: () async {
                                  //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                                  //         SendImage()));
                                  //   },
                                  //   child: Padding(
                                  //     padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                  //     child: Image.asset(Images.image, width: 25, height: 25, color: ColorResources.getGreyBunkerColor(context)),
                                  //   ),
                                  // ),
                                  SizedBox(width: 20),
                                  SizedBox(
                                    height: 25,
                                    child: VerticalDivider(
                                        width: 0,
                                        thickness: 1,
                                        color:
                                            ColorResources.getGreyBunkerColor(
                                                context)),
                                  ),
                                  SizedBox(
                                      width: Dimensions.PADDING_SIZE_DEFAULT),

                                  Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      style: rubikMedium.copyWith(
                                          color: ColorResources.getTextColor(
                                              context),
                                          fontSize: Dimensions.FONT_SIZE_LARGE),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: getTranslated(
                                            'type_message_here', context),
                                        hintStyle: rubikRegular.copyWith(
                                            color: ColorResources
                                                .getGreyBunkerColor(context),
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE),
                                      ),
                                      onChanged: (String newText) {
                                        if (newText.isNotEmpty &&
                                            !Provider.of<ChatProvider>(context,
                                                    listen: false)
                                                .isSendButtonActive!) {
                                          Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .toggleSendButtonActivity();
                                        } else if (newText.isEmpty &&
                                            Provider.of<ChatProvider>(context,
                                                    listen: false)
                                                .isSendButtonActive!) {
                                          Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .toggleSendButtonActivity();
                                        }
                                      },
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      if (Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .isSendButtonActive!) {
                                        Provider.of<ChatProvider>(context,
                                                listen: false)
                                            .sendMessage(
                                          _controller.text,
                                          Provider.of<CustomAuthProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserToken()!,
                                          Provider.of<ProfileProvider>(context,
                                                  listen: false)
                                              .userInfoModel!
                                              .id
                                              .toString(),
                                          context,
                                        );
                                        _controller.text = '';
                                      } else {
                                        showCustomSnackBar(getTranslated('write_something', context), context);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                      child: Image.asset(
                                        Images.send,
                                        width: 25,
                                        height: 25,
                                        color: Provider.of<ChatProvider>(
                                                    context)
                                                .isSendButtonActive!
                                            ? ColorResources.getPrimaryColor(
                                                context)
                                            : ColorResources.getGreyBunkerColor(
                                                context),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ]),
                    ),
                  ),

                  const SizedBox(height: 30)
                ]);
              },
            )
          : NotLoggedInScreen(),
    );
  }
}

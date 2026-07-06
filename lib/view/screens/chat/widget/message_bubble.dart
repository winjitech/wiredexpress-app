import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/chat_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final ChatModel? chat;
  final bool? addDate;
  MessageBubble({@required this.chat, @required this.addDate});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat!.reply == null;

    String dateTime = DateConverter.isoStringToLocalTimeOnly(context , chat!.createdAt!);
    String _date = DateConverter.isoStringToLocalDateOnly(context , chat!.createdAt!) ==
            DateConverter.estimatedDate(context ,DateTime.now())
        ? 'Today'
        : DateConverter.isoStringToLocalDateOnly(context , chat!.createdAt!) ==
                DateConverter.estimatedDate(context ,
                    DateTime.now().subtract(Duration(days: 1)))
            ? 'Yesterday'
            : DateConverter.isoStringToLocalDateOnly(context , chat!.createdAt!);

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        addDate!
            ? Padding(
                padding: EdgeInsets.all(10.r),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      _date,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h6(context).copyWith(
                        color: ColorResources.getTextColor(context),
                      ),
                    ),),
              )
            : SizedBox(),
        Padding(
          padding: isMe
              ? EdgeInsets.fromLTRB(50, 5, 10, 5)
              : EdgeInsets.fromLTRB(10, 5, 50, 5),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft:
                              isMe ? Radius.circular(10) : Radius.circular(0),
                          bottomRight:
                              isMe ? Radius.circular(0) : Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        color: isMe
                            ? ColorResources.getHintColor(context)
                            : ColorResources.getTextColor(context).withOpacity(0.4),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_LARGE,
                              vertical: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            child: Text(
                              isMe ? chat!.message! : chat!.reply!,
                              style: AppTextStyles.h7(context).copyWith(
                                color: isMe
                                    ? ColorResources.getScaffoldBackgroundColor(context)
                                    : ColorResources.getTextColor(context),
                              ),
                            ),
                          ),
                          chat!.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft:
                                          Radius.circular(isMe ? 10 : 0),
                                      bottomRight:
                                          Radius.circular(isMe ? 0 : 10)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder_image,
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.chatImageUrl}/${chat!.image}',
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitWidth,
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1),
              Text(
                dateTime,
                style: AppTextStyles.h9(context).copyWith(
                  color: ColorResources.getTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

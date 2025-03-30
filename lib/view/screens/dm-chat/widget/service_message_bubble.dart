// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:lacrostini_app/helper/date_converter.dart';
// import 'package:lacrostini_app/localization/language_constrants.dart';
//
// import 'package:lacrostini_app/provider/splash_provider.dart';
// import 'package:lacrostini_app/utill/color_resources.dart';
// import 'package:lacrostini_app/utill/dimensions.dart';
// import 'package:lacrostini_app/utill/images.dart';
// import 'package:lacrostini_app/utill/styles.dart';
// import 'package:provider/provider.dart';
// import 'package:lacrostini_app/view/base/product_widget.dart';
//
//
// class ServiceMessageBubble extends StatelessWidget {
//   BuildContext? contextBuilder;
//   final bool? addDate;
//   final bool? lastMessage;
//   ServiceMessageBubble({@required this.chat, @required this.addDate,@required this.lastMessage});
//
//   @override
//   Widget build(BuildContext context) {
//     bool isMe = chat.reply == null;
//     final String languageStr = getTranslated('set_language', context);
//     String dateTime = DateConverter.isoStringToLocalTimeOnly(chat.createdAt);
//     String _date = DateConverter.isoStringToLocalDateOnly(chat.createdAt) == DateConverter.estimatedDate(DateTime.now()) ? 'Today'
//         : DateConverter.isoStringToLocalDateOnly(chat.createdAt) == DateConverter.estimatedDate(DateTime.now().subtract(Duration(days: 1)))
//         ? 'Yesterday' : DateConverter.isoStringToLocalDateOnly(chat.createdAt);
//
//     return Column(
//       crossAxisAlignment: languageStr == '1'? isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start :  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//       children: [
//         // lastMessage?
//         // GestureDetector(
//         //   onTap: () async {
//         //     Provider.of<ChatProvider>(context, listen: false).clearOffset();
//         //     Provider.of<ChatProvider>(context, listen: false).getServicesChatHistoryList(context, '1',(
//         //         bool isSuccess) async {
//         //       if(isSuccess){
//         //         Navigator.pushReplacement(context,
//         //             MaterialPageRoute(builder: (BuildContext context) =>
//         //                 ServiceChatHistory()));
//         //       } else {
//         //         showDialog(
//         //             context: context,
//         //             builder: (_) => AlertDialog(
//         //               title: Text('Error occured, try again later'),
//         //             )
//         //         );
//         //       }
//         //     });
//         //   },
//         //     child: Center(child: Text('${getTranslated('chat_history', context)}...', style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 14))))  : SizedBox(),
//         addDate ? Padding(
//           padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//           child: Align(alignment: Alignment.center, child: Text(_date, style: rubikMedium, textAlign: TextAlign.center)),
//         ) : SizedBox(),
//         Padding(
//           padding: languageStr == '1'? isMe ?  EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 50, 5) : isMe ?  EdgeInsets.fromLTRB(20, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 20, 5),
//           child: Column(
//             crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(10),
//                           bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
//                           bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
//                           topRight: Radius.circular(10),
//                         ),
//                         color:chat.product != null?ColorResources.COLOR_PRIMARY.withOpacity(0) : isMe ? ColorResources.COLOR_PRIMARY : ColorResources.COLOR_LIGHT_PRIMARY,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                         children: [
//                           chat.product == null?
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
//                             child: Text(isMe ? chat.message : chat.reply, style: rubikRegular.copyWith(color: isMe ? Colors.white
//                                 : Theme.of(context).textTheme.bodyText1.color)),
//                           ) : SizedBox(),
//                           chat.product != null?
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
//                             child: ProductWidget(product: chat.product),
//                           ) : SizedBox(),
//
//                           chat.image != null ? ClipRRect(
//                             borderRadius: BorderRadius.only(bottomLeft: Radius.circular(isMe ? 10 : 0), bottomRight: Radius.circular(isMe ? 0 : 10)),
//                             child: FadeInImage.assetNetwork(
//                               placeholder: Images.placeholder_image,
//                               image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.chatImageUrl}/${chat.image}',
//                               width: MediaQuery.of(context).size.width,
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ) : SizedBox(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               SizedBox(height: 1),
//               Text(dateTime, style: rubikRegular.copyWith(fontSize: 8, color: ColorResources.COLOR_GREY_BUNKER)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
// }

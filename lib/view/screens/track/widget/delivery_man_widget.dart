import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/deliveryman_chat_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/dm-chat/dm_chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryManWidget extends StatelessWidget {
  final DeliveryMan? deliveryMan;
  final String? orderId;
  DeliveryManWidget({@required this.deliveryMan, @required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: ColorResources.getScaffoldBackgroundColor(context),
        borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Provider.of<ThemeProvider>(context).darkTheme?
              Colors.black.withOpacity(0.4):
              Colors.grey[300]!,
              blurRadius: 5,
              spreadRadius: 1,
            )
          ]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(getTranslated('delivery_man', context),
            style: rubikRegular.copyWith(
                color: ColorResources.getTextColor(context),
                fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              deliveryMan!.image != null
                  ? ClipOval(
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.loading,
                        image:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.deliveryManImageUrl}/${deliveryMan!.image}',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${deliveryMan!.fName} ${deliveryMan!.lName}',
                    style: rubikRegular.copyWith(
                        color: ColorResources.getTextColor(context),
                        fontSize: Dimensions.FONT_SIZE_LARGE),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RatingBar(
                      rating: deliveryMan!.rating!.length > 0
                          ? double.parse(deliveryMan!.rating![0].average!)
                          : 0,
                      size: 15),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: () => launch('tel:${deliveryMan!.phone}'),
                    child: Container(
                      padding:
                          EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorResources.getSearchBg(context)),
                      child: Icon(
                        Icons.call_outlined,
                        color: ColorResources.COLOR_BLACK,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () async {
                      print('order --id :$orderId');
                      Provider.of<DeliveryManChatProvider>(context,
                              listen: false)
                          .refresh(context, orderId.toString(), true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DeliveryManChatScreen(
                                      orderId: orderId,
                                      deliveryMan: deliveryMan)));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorResources.getSearchBg(context)),
                      child: Icon(
                        Icons.chat,
                        color: ColorResources.COLOR_BLACK,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}

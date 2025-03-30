import 'package:flutter/material.dart';
import 'package:wired_express/data/model/body/review_body_model.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/screens/track/widget/delivery_man_widget.dart';
import 'package:provider/provider.dart';

class DeliveryManReviewWidget extends StatelessWidget {
  final DeliveryMan? deliveryMan;
  final String? orderID;
  DeliveryManReviewWidget({@required this.deliveryMan, @required this.orderID});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      deliveryMan != null
                          ? DeliveryManWidget(deliveryMan: deliveryMan!)
                          : SizedBox(),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      Container(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Provider.of<ThemeProvider>(context)
                                        .darkTheme
                                    ? Colors.black.withOpacity(0.4)
                                    : Colors.grey[300]!,
                                blurRadius: 5,
                                spreadRadius: 1,
                              )
                            ]),
                        child: Column(children: [
                          Text(
                            getTranslated('rate_his_service', context),
                            style: rubikMedium.copyWith(
                                color:
                                    ColorResources.getGreyBunkerColor(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          SizedBox(
                            height: 30,
                            child: ListView.builder(
                              itemCount: 5,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  child: Icon(
                                    productProvider.deliveryManRating < (i + 1)
                                        ? Icons.star_border
                                        : Icons.star,
                                    size: 25,
                                    color: productProvider.deliveryManRating <
                                            (i + 1)
                                        ? ColorResources.getGreyColor(context)
                                        : Theme.of(context).primaryColor,
                                  ),
                                  onTap: () {
                                    Provider.of<ProductProvider>(context,
                                            listen: false)
                                        .setDeliveryManRating(i + 1);
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          Text(
                            getTranslated('share_your_opinion', context),
                            style: rubikMedium.copyWith(
                                color:
                                    ColorResources.getGreyBunkerColor(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          CustomTextField(
                            maxLines: 5,
                            capitalization: TextCapitalization.sentences,
                            controller: _controller,
                            hintText: getTranslated(
                                'write_your_review_here', context),
                            fillColor: ColorResources.getSearchBg(context),
                          ),
                          SizedBox(height: 40),

                          // Submit button
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE),
                            child: Column(
                              children: [
                                !productProvider.isLoading
                                    ? CustomButton(
                                        text:
                                            getTranslated('submit', context),
                                        onTap: () {
                                          if (productProvider
                                                  .deliveryManRating ==
                                              0) {
                                            showCustomSnackBar(
                                                'Give a rating', context);
                                          } else if (_controller.text.isEmpty) {
                                            showCustomSnackBar(
                                                'Write a review', context);
                                          } else {
                                            FocusScopeNode currentFocus =
                                                FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                            ReviewBody reviewBody = ReviewBody(
                                              deliveryManId:
                                                  deliveryMan!.id.toString(),
                                              rating: productProvider
                                                  .deliveryManRating
                                                  .toString(),
                                              comment: _controller.text,
                                              orderId: orderID,
                                            );
                                            productProvider
                                                .submitDeliveryManReview(
                                                    reviewBody)
                                                .then((value) {
                                              if (value.isSuccess) {
                                                showCustomSnackBar(
                                                    value.message, context,
                                                    isError: false);
                                                _controller.text = '';
                                              } else {
                                                showCustomSnackBar(
                                                    value.message, context);
                                              }
                                            });
                                          }
                                        },
                                      )
                                    : Center(
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .primaryColor))),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }
}

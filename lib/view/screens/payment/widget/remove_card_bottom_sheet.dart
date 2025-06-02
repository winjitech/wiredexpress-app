
import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/payment_provider.dart';
import 'package:wired_express/provider/profile_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/Custom_button.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';

class RemoveCardBottomSheet extends StatefulWidget {
  final String cardId;

  const RemoveCardBottomSheet({
    super.key,
    required this.cardId,
  });

  @override
  State<RemoveCardBottomSheet> createState() =>
      _RemoveCardBottomSheetState();
}

class _RemoveCardBottomSheetState extends State<RemoveCardBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        final int userId =  Provider.of<ProfileProvider>(context, listen: false).userInfoModel!.id!;

        void updateDetails() {
          paymentProvider.getPaymentCardList(context, userId);
          Navigator.pop(context);
          Navigator.pop(context);

          showCustomSnackBar(getTranslated('card_deleted_successfully', context),
              context, isError: false);
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(35),
              topLeft: Radius.circular(35),
            ),
            color: ColorResources.getScaffoldBackgroundColor(context),
          ),
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Are you sure you want to delete this card?',
                      style: TextStyle(
                        color: ColorResources.getTextColor(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: ColorResources.getTextColor(context),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      paymentProvider.deleteLoading == false
                          ? Row(
                        children: [
                          Expanded(
                              child: CustomButton(
                                text: getTranslated('yes', context),
                                onTap: () {
                                 paymentProvider.deleteCard(context, widget.cardId, userId).then((value){
                                   if(value.isSuccess){
                                     updateDetails();
                                   }

                                 });
                                },
                                textSize: 15,
                                height: 38,
                                radius: 14,
                                backgroundColor: Colors.transparent,
                                borderColor:
                                ColorResources.getPrimaryColor(context),
                                textColor:
                                ColorResources.getPrimaryColor(context),
                              )),

                          const SizedBox(width: 15),

                          Expanded(
                              child: CustomButton(
                                text: getTranslated('no', context),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                textSize: 15,
                                height: 38,
                                radius: 14,
                              )),
                        ],
                      )
                          : Padding(
                          padding: const EdgeInsets.all(25),
                          child: CustomCircularIndicator()),
                      const SizedBox(height: 25),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

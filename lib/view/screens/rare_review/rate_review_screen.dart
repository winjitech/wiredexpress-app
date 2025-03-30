import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/order_details_model.dart';
import 'package:wired_express/data/model/response/order_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/screens/rare_review/widget/deliver_man_review_widget.dart';
import 'package:wired_express/view/screens/rare_review/widget/product_review_widget.dart';
import 'package:provider/provider.dart';

class RateReviewScreen extends StatefulWidget {
  final List<OrderDetailsModel>? orderDetailsList;
  // final DeliveryMan? deliveryMan;
  RateReviewScreen({@required this.orderDetailsList});

  @override
  _RateReviewScreenState createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, initialIndex: 0, vsync: this);
    Provider.of<ProductProvider>(context, listen: false)
        .initRatingData(widget.orderDetailsList!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(title: getTranslated('rate_review', context)),
      body: Column(children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: ColorResources.getTextColor(context),
              indicatorColor: Theme.of(context).primaryColor,
              indicatorWeight: 3,
              unselectedLabelStyle: rubikRegular.copyWith(
                  color: ColorResources.COLOR_HINT,
                  fontSize: Dimensions.FONT_SIZE_SMALL),
              labelStyle:
                  rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
              tabs: [
                Tab(
                    text: getTranslated(
                        widget.orderDetailsList!.length > 1 ? 'items' : 'item',
                        context)),
              ],
            ),
          ),
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: [
            ProductReviewWidget(orderDetailsList: widget.orderDetailsList),
          ],
        )),
      ]),
    );
  }
}

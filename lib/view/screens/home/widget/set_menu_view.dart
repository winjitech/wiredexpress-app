import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/helper/date_converter.dart';
import 'package:wired_express/helper/price_converter.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/cart_provider.dart';
import 'package:wired_express/provider/set_menu_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/rating_bar.dart';
import 'package:wired_express/view/base/title_widget.dart';
import 'package:wired_express/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:wired_express/view/screens/setmenu/set_menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SetMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<SetMenuProvider, CartProvider>(
      builder: (context, setMenu, cart, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TitleWidget(
                  title: getTranslated('set_menu', context),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext? context) =>
                                SetMenuScreen()));
                    // Navigator.pushNamed(context, Routes.getSetMenuRoute());
                  }),
            ),
            SizedBox(
              height: 220,
              child: setMenu.setMenuList != null
                  ? setMenu.setMenuList!.length > 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount: setMenu.setMenuList!.length > 5
                              ? 5
                              : setMenu.setMenuList!.length,
                          itemBuilder: (context, index) {
                            double? _startingPrice;
                            double? _endingPrice;
                            if (setMenu.setMenuList![index].choiceOptions!
                                    .length !=
                                0) {
                              List<double> _priceList = [];
                              setMenu.setMenuList![index].variations!.forEach(
                                  (variation) =>
                                      _priceList.add(variation.price!));
                              _priceList.sort((a, b) => a.compareTo(b));
                              _startingPrice = _priceList[0];
                              if (_priceList[0] <
                                  _priceList[_priceList.length - 1]) {
                                _endingPrice =
                                    _priceList[_priceList.length - 1];
                              }
                            } else {
                              _startingPrice =
                                  setMenu.setMenuList![index].price!;
                            }

                            double _discount = setMenu
                                    .setMenuList![index].price! -
                                PriceConverter.convertWithDiscount(
                                    context,
                                    setMenu.setMenuList![index].price!,
                                    setMenu.setMenuList![index].discount!,
                                    setMenu.setMenuList![index].discountType!);

                            bool _isAvailable = DateConverter.isAvailable(
                                setMenu
                                    .setMenuList![index].availableTimeStarts!,
                                setMenu.setMenuList![index].availableTimeEnds!,
                                context);
                            _isAvailable = true;
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL,
                                  bottom: 5,
                                  top: 5),
                              child: InkWell(
                                onTap: () {
                                  ResponsiveHelper.isMobile(context)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext?
                                                      context) =>
                                                  ProductDetailsScreen(
                                                    product: setMenu
                                                        .setMenuList![index],
                                                    fromSetMenu: true,
                                                    callback:
                                                        (CartModel cartModel) {
                                                      ScaffoldMessenger.of(
                                                              context!)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  getTranslated(
                                                                      'added_to_cart',
                                                                      context)),
                                                              backgroundColor:
                                                                  Colors
                                                                      .green));
                                                    },
                                                  )))
                                      : showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                                child: CartBottomSheet(
                                                  product: setMenu
                                                      .setMenuList![index],
                                                  fromSetMenu: true,
                                                  callback:
                                                      (CartModel cartModel) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                getTranslated(
                                                                    'added_to_cart',
                                                                    context)),
                                                            backgroundColor:
                                                                Colors.green));
                                                  },
                                                ),
                                              ));
                                },
                                child: Container(
                                  height: 220,
                                  width: 170,
                                  decoration: BoxDecoration(
                                      color: ColorResources
                                          .getScaffoldBackgroundColor(context),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Provider.of<ThemeProvider>(
                                                      context)
                                                  .darkTheme
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.grey[300]!,
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        )
                                      ]),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: Images
                                                    .placeholder_rectangle,
                                                image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${setMenu.setMenuList![index].image}',
                                                height: 110,
                                                width: 170,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            _isAvailable
                                                ? SizedBox()
                                                : Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        10)),
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Text(
                                                          getTranslated(
                                                              'not_available_now',
                                                              context),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: rubikRegular
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_SMALL,
                                                          )),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${setMenu.setMenuList![index].name}',
                                                    style: rubikMedium.copyWith(
                                                        color: ColorResources
                                                            .getTextColor(
                                                                context),
                                                        fontSize: Dimensions
                                                            .FONT_SIZE_SMALL),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  if (setMenu
                                                              .setMenuList![
                                                                  index]
                                                              .matchedTag !=
                                                          null &&
                                                      setMenu
                                                              .setMenuList![
                                                                  index]
                                                              .matchedTag !=
                                                          '')
                                                    SizedBox(
                                                        height: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                  if (setMenu
                                                              .setMenuList![
                                                                  index]
                                                              .matchedTag !=
                                                          null &&
                                                      setMenu
                                                              .setMenuList![
                                                                  index]
                                                              .matchedTag !=
                                                          '')
                                                    Text(
                                                        setMenu
                                                                .setMenuList![
                                                                    index]
                                                                .matchedTag ??
                                                            '',
                                                        style: giftFont.copyWith(
                                                            fontSize: Dimensions
                                                                .FONT_SIZE_DEFAULT),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  RatingBar(
                                                    rating: setMenu
                                                                .setMenuList![
                                                                    index]
                                                                .rating!
                                                                .length >
                                                            0
                                                        ? double.parse(setMenu
                                                            .setMenuList![index]
                                                            .rating![0]
                                                            .average!)
                                                        : 0.0,
                                                    size: 12,
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .PADDING_SIZE_EXTRA_SMALL),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          '${PriceConverter.convertPrice(context, _startingPrice, discount: setMenu.setMenuList![index].discount, discountType: setMenu.setMenuList![index].discountType, asFixed: 1)}'
                                                          '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: setMenu.setMenuList![index].discount, discountType: setMenu.setMenuList![index].discountType, asFixed: 1)}' : ''}',
                                                          style: rubikBold.copyWith(
                                                              color: ColorResources
                                                                  .getTextColor(
                                                                      context),
                                                              fontSize: Dimensions
                                                                  .FONT_SIZE_SMALL),
                                                        ),
                                                      ),
                                                      _discount > 0
                                                          ? SizedBox()
                                                          : Icon(Icons.add,
                                                              color:ColorResources.getTextColor(context)),
                                                    ],
                                                  ),
                                                  _discount > 0
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                              Flexible(
                                                                child: Text(
                                                                  '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                                                  '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                                                  style: rubikBold
                                                                      .copyWith(
                                                                    fontSize:
                                                                        Dimensions
                                                                            .FONT_SIZE_EXTRA_SMALL,
                                                                    color: Provider.of<ThemeProvider>(context,
                                                                                listen:
                                                                                    false)
                                                                            .darkTheme
                                                                        ? ColorResources
                                                                            .DISABLE_COLOR
                                                                        : ColorResources
                                                                            .COLOR_GREY,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                  ),
                                                                ),
                                                              ),
                                                              IconButton(
                                                                  icon: Icon(
                                                                      Icons.add,
                                                                      color: ColorResources
                                                                          .getTextColor(
                                                                              context)),
                                                                  onPressed:
                                                                      () {}),
                                                            ])
                                                      : SizedBox(),
                                                ]),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                          getTranslated('no_set_menu_available', context),
                          style: TextStyle(
                              color: ColorResources.getTextColor(context)),
                        ))
                  : SetMenuShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class SetMenuShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Container(
            height: 200,
            width: 150,
            margin: EdgeInsets.only(
                right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
            decoration: BoxDecoration(
                color: ColorResources.getScaffoldBackgroundColor(context),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Provider.of<ThemeProvider>(context).darkTheme
                        ? Colors.black.withOpacity(0.4)
                        : Colors.grey[300]!,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 110,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  color: Colors.grey[
                      Provider.of<ThemeProvider>(context).darkTheme
                          ? 900
                          : 300]!,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: 120,
                          color: Colors.grey[
                              Provider.of<ThemeProvider>(context).darkTheme
                                  ? 900
                                  : 300]!,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RatingBar(rating: 0.0, size: 12),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(
                          height: 10,
                          width: 50,
                          color: Colors.grey[
                              Provider.of<ThemeProvider>(context).darkTheme
                                  ? 900
                                  : 300]!,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 10,
                                width: 50,
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 900
                                        : 300]!,
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.grey[
                                    Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? 900
                                        : 300]!,
                              ),
                            ]),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

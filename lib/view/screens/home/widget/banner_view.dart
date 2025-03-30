import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/cart_model.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wired_express/view/screens/category/category_screen.dart';
import 'package:wired_express/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:wired_express/view/screens/product/product_details_screen.dart';

class BannerView extends StatefulWidget {
  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  CarouselSliderController? carouselController;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 180,
        child: Consumer<BannerProvider>(builder: (context, banner, child) {
          return banner.bannerList != null
              ? banner.bannerList!.length > 0
              ? CarouselSlider.builder(
            carouselController: carouselController,
            options: CarouselOptions(
              height: ResponsiveHelper.isMobile(context) ? 240 : 260,
              viewportFraction:
              ResponsiveHelper.isDesktop(context) ? 0.2 : 0.99,
              enlargeFactor:
              ResponsiveHelper.isDesktop(context) ? 0.2 : 0.99,
              autoPlay: true,
              enlargeCenterPage: true,
              disableCenter: true,
              onPageChanged: (index, reason) {},
            ),
            itemCount: banner.bannerList!.length,
            itemBuilder: (context, index, _) {
              return Center(
                child: InkWell(
                  onTap: () {
                    if (banner.bannerList![index].productId != null) {
                      Product? product;
                      for (Product prod in banner.productList!) {
                        if (prod.id ==
                            banner.bannerList![index].productId) {
                          product = prod;
                          break;
                        }
                      }
                      ResponsiveHelper.isMobile(context)
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext? context) =>
                                  ProductDetailsScreen(
                                    product: product!,
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
                                        Colors.green,
                                      ));
                                    },
                                  )))
                          : showDialog(
                          context: context,
                          builder: (con) => Dialog(
                            child: CartBottomSheet(
                              product: product!,
                              callback:
                                  (CartModel cartModel) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(getTranslated(
                                      'added_to_cart',
                                      context)),
                                  backgroundColor:
                                  Colors.green,
                                ));
                              },
                            ),
                          ));
                    } else if (banner.bannerList![index].categoryId !=
                        null) {
                      CategoryModel? category;
                      for (CategoryModel categoryModel
                      in Provider.of<CategoryProvider>(context,
                          listen: false)
                          .categoryListFull!) {
                        if (categoryModel.id ==
                            banner.bannerList![index].categoryId) {
                          category = categoryModel;
                          break;
                        }
                      }
                      if (category != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CategoryScreen(
                                    categoryModel: category)));
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.bannerList![index].image}'),
                              fit: BoxFit.cover,
                            ),
                            color: ColorResources
                                .getScaffoldBackgroundColor(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Text(
                                    banner.bannerList![index].title
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                getTranslated('up_to', context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    banner.bannerList![index].describe
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'off',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
              : Center(
              child: Text(
                getTranslated('no_banner_available', context),
                style: TextStyle(
                    color: ColorResources.getTextColor(context)),
              ))
              : BannerShimmer();
        }),
      ),
    ]);
  }
}

class BannerShimmer extends StatelessWidget {
  CarouselSliderController? carouselController;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
        duration: const Duration(seconds: 2),
        enabled: true,
        child: CarouselSlider.builder(
            carouselController: carouselController,
            options: CarouselOptions(
              height: ResponsiveHelper.isMobile(context) ? 240 : 260,
              viewportFraction:
              ResponsiveHelper.isDesktop(context) ? 0.2 : 0.99,
              enlargeFactor: ResponsiveHelper.isDesktop(context) ? 0.2 : 0.99,
              autoPlay: true,
              enlargeCenterPage: true,
              disableCenter: true,
              onPageChanged: (index, reason) {},
            ),
            itemCount: 10,
            itemBuilder: (context, index, _) {
              return Row(children: [
                Center(
                    child: InkWell(
                        child: Stack(children: [
                          Center(
                            child: Container(
                              height: 175,
                              width: 366,
                              margin: EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                  color: ColorResources.getScaffoldBackgroundColor(
                                      context),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                      Provider.of<ThemeProvider>(context).darkTheme
                                          ? Colors.black.withOpacity(0.4)
                                          : Colors.grey[300]!,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ]),
                            ),
                          ),
                          Positioned(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          child: Container(
                                            height: 25,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey[
                                              Provider.of<ThemeProvider>(context)
                                                  .darkTheme
                                                  ? 900
                                                  : 300]!,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 25,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.grey[
                                                  Provider.of<ThemeProvider>(context)
                                                      .darkTheme
                                                      ? 700
                                                      : 300]!,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        height: 20,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.grey[
                                          Provider.of<ThemeProvider>(context).darkTheme
                                              ? 900
                                              : 300]!,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey[
                                            Provider.of<ThemeProvider>(context)
                                                .darkTheme
                                                ? 900
                                                : 300]!,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          height: 25,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey[
                                            Provider.of<ThemeProvider>(context)
                                                .darkTheme
                                                ? 900
                                                : 300]!,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 25,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[
                                        Provider.of<ThemeProvider>(context).darkTheme
                                            ? 900
                                            : 300]!,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                        ])))
              ]);
            }));
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:wired_express/view/screens/category/category_screen.dart';
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
                          child: GestureDetector(
                            onTap: () {
                              if (banner.bannerList![index].productId != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext? context) =>
                                            ProductDetailsScreen(
                                                productId: banner
                                                    .bannerList![index]
                                                    .productId)));
                              } else if (banner.bannerList![index].categoryId !=
                                  null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CategoryScreen(
                                            categoryModel: banner
                                                .bannerList![index].category)));
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
                                          fit: BoxFit.cover),
                                      color: ColorResources
                                          .getScaffoldBackgroundColor(context),
                                      borderRadius: BorderRadius.circular(10),
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
            itemBuilder: (context, index, _) => Row(children: [
                  Expanded(
                    child: Container(
                      height: 175,
                      width: double.infinity,
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
                ])));
  }
}

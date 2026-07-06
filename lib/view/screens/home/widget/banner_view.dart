import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/data/model/response/banner_model.dart';
import 'package:wired_express/provider/banner_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/base/shimmer/banner_shimmer.dart';
import 'package:wired_express/view/screens/product/product_by_category_screen.dart';
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
      Consumer<BannerProvider>(builder: (context, prov, child) {
        if (prov.bannerListIsLoading || prov.bannerList == null) {
          return BannerShimmer();
        }
        if (prov.bannerList != null && prov.bannerList!.isEmpty) {
          return SizedBox();
        }
        return SizedBox(
            height: 180.h,
            child: CarouselSlider.builder(
              carouselController: carouselController,
              options: CarouselOptions(
                  height: 240.h,
                  viewportFraction: 0.99,
                  enlargeFactor: 0.99,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  onPageChanged: (index, reason) {}),
              itemCount: prov.bannerList!.length,
              itemBuilder: (context, index, _) {
                BannerModel banner = prov.bannerList![index];
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      if (banner.productId != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext? context) =>
                                    ProductDetailsScreen(
                                        productId: banner.productId)));
                      } else if (banner.categoryId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProductByCategoryScreen(category: banner.category!),
                          ),
                        );
                      }
                    },
                    child: Center(
                      child: Container(
                        height: 180.h,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(right: 0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.image}'),
                              fit: BoxFit.cover),
                          color: ColorResources.getScaffoldBackgroundColor(
                              context),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ));
      }),
    ]);
  }
}

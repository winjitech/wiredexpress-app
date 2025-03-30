import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/title_widget.dart';
import 'package:wired_express/view/screens/category/category_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 500,
        child: Consumer<CategoryProvider>(
          builder: (context, category, child) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child: TitleWidget(
                      title: getTranslated('all_categories', context)),
                ),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: category.categoryList != null
                        ? category.categoryList!.length > 0
                            ? GridView.builder(
                                itemCount: category.categoryList!.length,
                                padding: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_SMALL),
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.2,
                                  crossAxisCount:
                                      ResponsiveHelper.isDesktop(context)
                                          ? 5
                                          : 4,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    child: InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (BuildContext? context) =>
                                                      CategoryScreen(
                                                        categoryModel: category
                                                                .categoryList!
                                                            as CategoryModel,
                                                      ))),
                                      // Navigator.pushNamed(
                                      //     context,
                                      //     Routes.getCategoryRoute(
                                      //       category.categoryList![index].id!,
                                      //       category
                                      //           .categoryList![index].image!,
                                      //       category.categoryList![index].name!
                                      //           .replaceAll(' ', '-'),
                                      //     )),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    Images.placeholder_image,
                                                image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}'
                                                    '/${category.categoryList![index].image}',
                                                width: 65, height: 65,
                                                fit: BoxFit.cover,
                                                // width: 100, height: 100, fit: BoxFit.cover,
                                              ),
                                            ),
                                            Text(
                                              category
                                                  .categoryList![index].name!,
                                              style: rubikMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ]),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(getTranslated(
                                    'no_category_available', context)))
                        : CategoryShimmer(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: true,
              child:  Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: ColorResources.COLOR_WHITE,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10, width: 50, color: ColorResources.COLOR_WHITE),
              ]),
            ),
          );
        },
      ),
    );
  }
}

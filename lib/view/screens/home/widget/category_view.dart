import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/provider/theme_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/title_widget.dart';
import 'package:wired_express/view/screens/category/category_screen.dart';
import 'package:wired_express/view/screens/home/widget/category_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
            //   child:
            //       TitleWidget(title: getTranslated('all_categories', context)),
            // ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    // height: 90,
                    child: category.categoryList != null
                        ? category.categoryList!.length > 0
                            ? GridView.builder(
                                key: UniqueKey(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 15,
                                        mainAxisExtent: 225,
                                        crossAxisCount: 2),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: category.categoryList!.length,
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          right: Dimensions.PADDING_SIZE_SMALL),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => CategoryScreen(
                                                      categoryModel: category
                                                              .categoryList![
                                                          index])));
                                        },
                                        // arguments:  category.categoryList[index].name),
                                        child: Container(
                                          child: Column(children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.grey[300]),
                                                width: double.maxFinite,
                                                height: 170,
                                                child: Image.network(
                                                  Provider.of<SplashProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .baseUrls !=
                                                          null
                                                      ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}'
                                                      : '',
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${category.categoryList![index].name}',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.black38,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            )
                                          ]),
                                        ),
                                      ));
                                })
                            : Center(
                                child: Text(getTranslated(
                                    'no_category_available', context)))
                        : CategoryShimmer(),
                  ),
                ),
                ResponsiveHelper.isMobile(context)
                    ? SizedBox()
                    : category.categoryList != null
                        ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (con) => Dialog(
                                          child: Container(
                                              height: 550,
                                              width: 600,
                                              child: CategoryPopUp())));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor:
                                        ColorResources.getPrimaryColor(context),
                                    child: Text(
                                        getTranslated('view_all', context),
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          )
                        : CategoryAllShimmer()
              ],
            ),
          ],
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 14,
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
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      color: ColorResources.getGreyColor(context),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Provider.of<ThemeProvider>(context).darkTheme
                              ? Colors.black.withOpacity(0.4)
                              : Colors.grey[300]!,
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ]),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10,
                    width: 50,
                    color: ColorResources.getGreyColor(context)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: true,
          child: Column(children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                  color: ColorResources.getGreyColor(context),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Provider.of<ThemeProvider>(context).darkTheme
                          ? Colors.black.withOpacity(0.4)
                          : Colors.grey[300]!,
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ]),
            ),
            SizedBox(height: 5),
            Container(
                height: 10,
                width: 50,
                color: ColorResources.getGreyColor(context)),
          ]),
        ),
      ),
    );
  }
}

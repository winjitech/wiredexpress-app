import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/category_product_widget.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/product_shimmer.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel? categoryModel;
  CategoryScreen({@required this.categoryModel});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        {
          Provider.of<CategoryProvider>(context, listen: false)
              .getCategoryProductListMore(
                  context, widget.categoryModel!.id.toString());
        }
      }
    });

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      appBar: CustomAppBar(title: widget.categoryModel!.name),
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          return Center(
              child: Scrollbar(
            controller: scrollController,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomScrollView(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: category.categoryProductList != null
                        ? category.categoryProductList!.length > 0
                            ? Column(
                                children: [
                                  GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            childAspectRatio: 3,
                                            crossAxisCount:
                                                ResponsiveHelper.isDesktop(
                                                        context)
                                                    ? 3
                                                    : ResponsiveHelper.isTab(
                                                            context)
                                                        ? 2
                                                        : 1),
                                    itemCount:
                                        category.categoryProductList!.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    itemBuilder: (context, index) {
                                      return CategoryProductWidget(
                                          product: category
                                              .categoryProductList![index]);
                                    },
                                  ),
                                  category.bottomLoading!
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: CustomCircularIndicator(
                                              color: ColorResources
                                                  .getScaffoldColor(context)),
                                        )
                                      : SizedBox(),
                                ],
                              )
                            : NoDataScreen()
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            physics: NeverScrollableScrollPhysics(),
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 3,
                              crossAxisCount:
                                  ResponsiveHelper.isDesktop(context)
                                      ? 3
                                      : ResponsiveHelper.isTab(context)
                                          ? 2
                                          : 1,
                            ),
                            itemBuilder: (context, index) {
                              return ProductShimmer(
                                  isEnabled:
                                      category.categoryProductList == null);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}

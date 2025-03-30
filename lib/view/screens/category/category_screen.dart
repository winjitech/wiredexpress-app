import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/category_product_widget.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/product_shimmer.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:provider/provider.dart';
//import 'package:wired_express/provider/language_provider.dart';
import 'package:wired_express/localization/language_constrants.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel? categoryModel;
  CategoryScreen({@required this.categoryModel});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false)
        .getSubCategoryList(context, widget.categoryModel!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    _scrollController?.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('Tab index: ${_tabIndex}');
        {
          if (_tabIndex == 0) {
            Provider.of<CategoryProvider>(context, listen: false)
                .getCategoryProductListMore(
                    context, widget.categoryModel!.id.toString());
          } else {
            print('sub category ids ///');
            print(jsonEncode(
                Provider.of<CategoryProvider>(context, listen: false)
                    .subCategoryList![_tabIndex - 1]
                    .name));
            Provider.of<CategoryProvider>(context, listen: false)
                .getCategoryProductListMore(
                    context,
                    Provider.of<CategoryProvider>(context, listen: false)
                        .subCategoryList![_tabIndex - 1]
                        .id
                        .toString());
          }
        }
      }
    });

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: CustomAppBar(
        title: widget.categoryModel!.name,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          return category.subCategoryList != null
              ? Center(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          category.subCategoryList!.isNotEmpty
                              ? SliverAppBar(
                                  expandedHeight: 5,
                                  toolbarHeight: 19,
                                  pinned: true,
                                  floating: false,
                                  backgroundColor:
                                      ColorResources.getScaffoldBackgroundColor(
                                          context),
                                  flexibleSpace: FlexibleSpaceBar(
                                    title: Text('${widget.categoryModel!.name}',
                                        style: TextStyle(
                                            color: ColorResources
                                                .getScaffoldBackgroundColor(
                                                    context))),
                                    titlePadding: EdgeInsets.only(
                                      bottom: 54 +
                                          (MediaQuery.of(context).padding.top /
                                              2),
                                      left: 50,
                                      right: 50,
                                    ),
                                    // background: Container(
                                    //   margin: EdgeInsets.only(bottom: 50),
                                    //   child: FadeInImage.assetNetwork(
                                    //     placeholder: Images.placeholder_rectangle,
                                    //     image:
                                    //         '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${widget.categoryModel!.image}',
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                  ),
                                  bottom: PreferredSize(
                                    preferredSize: Size.fromHeight(30.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      color: ColorResources
                                          .getScaffoldBackgroundColor(context),
                                      child: TabBar(
                                        controller: TabController(
                                            initialIndex: _tabIndex,
                                            length: category
                                                    .subCategoryList!.length +
                                                1,
                                            vsync: this),
                                        isScrollable: true,
                                        unselectedLabelColor:
                                            ColorResources.getHintColor(
                                                context),
                                        indicatorWeight: 3,
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
                                        indicatorColor:
                                            ColorResources.SCAFFOLD_COLOR,
                                        labelColor: ColorResources.getTextColor(
                                            context),

                                        // indicatorColor: ColorResources.SCAFFOLD_COLOR,
                                        // labelColor:
                                        //     ColorResources.getTextColor(context),
                                        tabs: _tabs(category),
                                        onTap: (int index) {
                                          category.resetPagesCount();
                                          _tabIndex = index;
                                          if (index == 0) {
                                            category.getCategoryProductList(
                                                context,
                                                widget.categoryModel!.id
                                                    .toString());
                                          } else {
                                            category.getCategoryProductList(
                                                context,
                                                category
                                                    .subCategoryList![index - 1]
                                                    .id
                                                    .toString());
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : SliverAppBar(
                                  expandedHeight: 0,
                                  toolbarHeight: 0,
                                  pinned: false,
                                  floating: false,
                                  backgroundColor:
                                      ColorResources.getScaffoldBackgroundColor(
                                          context),
                                ),

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
                                                        ResponsiveHelper
                                                                .isDesktop(
                                                                    context)
                                                            ? 3
                                                            : ResponsiveHelper
                                                                    .isTab(
                                                                        context)
                                                                ? 2
                                                                : 1),
                                            itemCount: category
                                                .categoryProductList!.length,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            itemBuilder: (context, index) {
                                              return CategoryProductWidget(
                                                  product: category
                                                          .categoryProductList![
                                                      index]);
                                            },
                                          ),
                                          category.bottomLoading!
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15),
                                                  child: Center(
                                                      child: CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  ColorResources
                                                                      .SCAFFOLD_COLOR))),
                                                )
                                              : SizedBox(),
                                        ],
                                      )
                                    : NoDataScreen()
                                : GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
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
                                              category.categoryProductList ==
                                                  null);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ColorResources.SCAFFOLD_COLOR)));
        },
      ),
    );
  }

  List<Tab> _tabs(CategoryProvider category) {
    List<Tab> tabList = [];
    tabList.add(Tab(text: 'All'));
    category.subCategoryList!.forEach(
        (subCategory) => tabList.add(Tab(text: '${subCategory.name}')));
    return tabList;
  }
}

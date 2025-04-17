import 'package:cached_network_image/cached_network_image.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/provider/localization_provider.dart';
import 'package:wired_express/provider/splash_provider.dart';
import 'package:wired_express/view/base/category_product_widget.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel? categoryModel;
  CategoryScreen({@required this.categoryModel});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _fetchCategoryProducts(resetOffset: true));
  }

  void _fetchCategoryProducts({bool resetOffset = false}) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    if (resetOffset) categoryProvider.clearCategoryProductListOffset();

    categoryProvider.getCategoryProductList(
        context, "1", widget.categoryModel!.id!.toString());
  }

  void _onScroll() {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    bool isAtBottom = _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
    bool canFetchMore = (categoryProvider.categoryProductList?.length ?? 0) <
        (categoryProvider.totalCategoryProductListSize ?? 0);

    if (isAtBottom &&
        !categoryProvider.bottomCategoryProductListLoading &&
        canFetchMore) {
      int nextOffset =
          (int.tryParse(categoryProvider.categoryProductListOffset ?? "1") ??
                  1) +
              1;
      categoryProvider.showBottomCategoryProductListLoader();
      categoryProvider.getCategoryProductList(
        context,
        nextOffset.toString(),
        widget.categoryModel!.id!.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context),
      appBar: CustomAppBar(title: widget.categoryModel!.name),
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            final localizationProvider =
                Provider.of<LocalizationProvider>(context, listen: false);

            List<ProductModel> categoryProducts =
                categoryProvider.categoryProductList ?? [];
            bool isLoading = categoryProvider.categoryProductListIsLoading;

            return Column(
              children: [
                Expanded(
                  child: isLoading
                      ? CustomCircularIndicator()
                      : categoryProducts.isEmpty
                          ? Center(
                              child: Text(
                                getTranslated(
                                    'no_any_product_available', context),
                                style: TextStyle(
                                    color:
                                        ColorResources.getTextColor(context)),
                              ),
                            )
                          : _buildCategoryProductsList(
                              categoryProducts, categoryProvider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CategoryModel category,
    SplashProvider splashProvider,
    LocalizationProvider localizationProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: ColorResources.getTextColor(context),
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              imageUrl:
                  '${splashProvider.configModel!.baseUrls!.productImageUrl}/${category.image!}',
              cacheKey:
                  '${splashProvider.configModel!.baseUrls!.productImageUrl}/${category.image!}',
            ),
          ),
          const SizedBox(width: 10),
          Text(
            category.name!,
            style: TextStyle(
              color: ColorResources.getTextColor(context),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProductsList(
    List<ProductModel> categoryProducts,
    CategoryProvider categoryProvider,
  ) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent &&
            categoryProducts.length <
                (categoryProvider.totalCategoryProductListSize ?? 0)) {
          _onScroll();
        }
        return false;
      },
      child: Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 100,
                  childAspectRatio: 4,
                  crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1,
                ),
                itemCount: categoryProvider.categoryProductList!.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => CategoryProductWidget(
                    product: categoryProvider.categoryProductList![index]),
              ),
              if (categoryProvider.bottomCategoryProductListLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CustomCircularIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

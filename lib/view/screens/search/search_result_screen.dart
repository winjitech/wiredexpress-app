import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/category_product_widget.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/product_shimmer.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatelessWidget {
  final String? searchString;
  final int? isServiceSearch;
  SearchResultScreen(
      {@required this.searchString, @required this.isServiceSearch});

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    int atamp = 0;
    if (atamp == 0) {
      _searchController.text = searchString!;
      atamp = 1;
    }

    return Scaffold(
      backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),
      appBar: ResponsiveHelper.isDesktop(context)
          ? PreferredSize(
              child: MainAppBar(), preferredSize: Size.fromHeight(80))
          : null,
      body: SafeArea(
        child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  isServiceSearch == 0
                      ?
                  GestureDetector(
                          onTap: () async {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            children: [
                              Container(
                                color:
                                    ColorResources.getScaffoldBackgroundColor(
                                        context),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Container(
                                      child: Text(
                                        '$searchString',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: ColorResources.getTextColor(
                                                context)),
                                      ),
                                      width: 300,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                          'assets/icon/search.png',
                                        ),
                                      )),
                                      height: 20,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ) ,

                                  ],
                                ),
                                height: 45,
                              ),
                            ],
                          ))
                      : SizedBox(),
                  SizedBox(height: 10),
                  if (isServiceSearch == 0)
                    searchProvider.searchProductList != null
                        ? Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                '${searchProvider.searchProductList!.length} ${getTranslated('product_found', context)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 16,
                                        color:
                                            ColorResources.getGreyBunkerColor(
                                                    context)
                                                .withOpacity(0.2)),
                              ),
                            ),
                          )
                        : SizedBox.shrink()
                  else
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                              ),
                              color: ColorResources.getGreyBunkerColor(context),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${getTranslated('suggested_products', context)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 16,
                                      color: ColorResources.getGreyBunkerColor(
                                          context)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 13),
                  Expanded(
                    child: searchProvider.searchProductList != null
                        ? searchProvider.searchProductList!.length > 0
                            ? Scrollbar(
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Center(
                                    child: SizedBox(
                                      // macbook
                                      width: MediaQuery.of(context).size.width,
                                      child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: searchProvider
                                            .searchProductList!.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisSpacing: 5,
                                                mainAxisSpacing: 5,
                                                childAspectRatio: 3,
                                                crossAxisCount: ResponsiveHelper
                                                        .isDesktop(context)
                                                    ? 4
                                                    : ResponsiveHelper.isTab(
                                                            context)
                                                        ? 3
                                                        : 1),
                                        itemBuilder: (context, index) =>
                                            CategoryProductWidget(
                                                product: searchProvider
                                                    .searchProductList![index]),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : NoDataScreen()
                        : GridView.builder(
                            itemCount:
                                10, //searchProvider.searchProductList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 3,
                              crossAxisCount:
                                  ResponsiveHelper.isDesktop(context)
                                      ? 4
                                      : ResponsiveHelper.isTab(context)
                                          ? 3
                                          : 1,
                            ),
                            itemBuilder: (context, index) => ProductShimmer(
                                isEnabled:
                                    searchProvider.searchProductList == null),
                          ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

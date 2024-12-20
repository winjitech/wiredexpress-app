import 'package:flutter/material.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/routes.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/product_shimmer.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class SearchNotification extends StatelessWidget {
  final String? searchString;

  SearchNotification({@required this.searchString});


  @override
  Widget build(BuildContext context) {

    Future<bool> _onWillPop() async {
      //MaterialPageRoute(builder: (context) => HomeScreen());
       Navigator.pushReplacementNamed(context, Routes.getMainRoute());
       return true;
    }
    TextEditingController _searchController = TextEditingController();
    int atamp = 0;
    if (atamp == 0) {
      _searchController.text = searchString!;
      atamp = 1;
    }
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

        appBar: ResponsiveHelper.isDesktop(context)?PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)):null,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: Consumer<SearchProvider>(
                builder: (context, searchProvider, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),

                    searchProvider.searchProductList != null ? Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '${searchProvider.searchProductList!.length} ${getTranslated('product_found', context)}',
                          style: TextStyle(color: ColorResources.getGreyBunkerColor(context)),
                        ),
                      ),
                    ) : SizedBox.shrink(),
                    SizedBox(height: 13),
                    Expanded(
                      child: searchProvider.searchProductList != null ? searchProvider.searchProductList!.length > 0 ? Scrollbar(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: searchProvider.searchProductList!.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 3,
                                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 1),
                                itemBuilder: (context, index) => ProductWidget(product: searchProvider.searchProductList![index]),
                              ),
                            ),
                          ),
                        ),
                      ) : NoDataScreen() : GridView.builder(
                        itemCount: 10,//searchProvider.searchProductList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 3,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 1,
                        ),
                        itemBuilder: (context, index) => ProductShimmer(isEnabled: searchProvider.searchProductList == null),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

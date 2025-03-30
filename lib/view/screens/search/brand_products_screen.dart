import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/product_shimmer.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:wired_express/utill/color_resources.dart';

class BrandProductsScreen extends StatefulWidget {

  @override
  _BrandProductsScreenState createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(getTranslated('products', context), style: TextStyle(color: Colors.black87)),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: ()async{
                    Provider.of<SearchProvider>(context, listen: false).
                    clearOffset();
                    Provider.of<SearchProvider>(context, listen: false).
                    getBrandsProductsList(
                        context,
                        '1',
                        '${Provider.of<SearchProvider>(context, listen: false).selectedBrand!.id.toString()}',
                        '${Provider.of<SearchProvider>(context, listen: false).selectedCategory!.id.toString()}'
                    );
                  },
                  child: Icon(Icons.refresh, color: Theme.of(context).primaryColor, size: 30)),
            ),
          ],
        ),

        body: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            int ordersLength = searchProvider.brandProductsList.length;
            int totalSize = searchProvider.totalBrandProductsSize ?? 0;
            List<Product> _productsList = searchProvider.brandProductsList;

            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: searchProvider.brandsLoading?
                Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))):
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                Expanded(
                child: searchProvider.brandProductsList != null ? searchProvider.brandProductsList.length > 0 ? Scrollbar(
                child: Scrollbar(
                child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchProvider.brandProductsList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 3,
                              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 1),
                          itemBuilder: (context, index) => ProductWidget(product: searchProvider.brandProductsList[index]),
                        ),
                      ),
                    ),
                    searchProvider.bottomLoading?
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                        SizedBox(height: 25),
                      ],
                    ) :
                    ordersLength < totalSize?
                    Center(child:
                    GestureDetector(
                        onTap: () {
                          String offset = searchProvider.brandOffset ?? '';
                          int offsetInt = int.parse(offset) + 1;
                          print('$offset -- $offsetInt');
                          String _categoryId;
                          if(searchProvider.selectedCategory != null) {
                            _categoryId = searchProvider.selectedCategory!.id.toString();
                          }else {
                            _categoryId = '0';
                          }
                          searchProvider.showBottomLoader();
                          searchProvider.getBrandsProductsList(
                              context,
                              offsetInt.toString(),
                              searchProvider.selectedBrand!.id.toString(),
                              _categoryId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 25),
                          child: Text(getTranslated('load_more', context),style: TextStyle(color: Theme.of(context).primaryColor)),
                        ))) : SizedBox(),
                  ],
                ),
              ),
            ),
            ) : NoDataScreen() :GridView.builder(
                  itemCount: 10,//searchProvider.searchProductList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 3,
                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 1,
                  ),
                  itemBuilder: (context, index) => ProductShimmer(isEnabled: searchProvider.brandProductsList == null),
                ),
                ),
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}

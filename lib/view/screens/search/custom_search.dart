import 'package:flutter/material.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/custom_app_bar.dart';
import 'package:wired_express/view/base/custom_button.dart';
import 'package:wired_express/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/search/brand_products_screen.dart';
import 'package:wired_express/view/screens/search/widget/category_bottom_sheet.dart';

import 'widget/brands_bottom_sheet.dart';

class CustomSearchScreen extends StatefulWidget {
  @override
  _CustomSearchScreenState createState() => _CustomSearchScreenState();
}

class _CustomSearchScreenState extends State<CustomSearchScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final String languageStr = getTranslated('set_language', context);
    return Scaffold(        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

      key: _scaffoldKey,
      appBar: CustomAppBar(title: getTranslated('brand_search', context)),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
        return !searchProvider.brandsLoading?
        Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(
                        Dimensions.PADDING_SIZE_SMALL),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 5),
                              child: Text(getTranslated('brand_name', context), style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                            searchProvider.selectedBrand == null?
                            GestureDetector(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (con) => BrandsBottomSheet(),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                                child: Container(
                                    height: 45,
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: ColorResources
                                              .COLOR_GREY_CHATEAU,

                                          width: 2),
                                    ),
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(searchProvider.selectedBrand != null? searchProvider.selectedBrand!.name! : getTranslated('select', context), style: TextStyle(fontSize: 15, color: Colors.black87)),
                                        SizedBox(width: 5),
                                        Icon(Icons.keyboard_arrow_down_rounded)
                                      ],
                                    )
                                ),
                              ),
                            ) :
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: GestureDetector(
                                  onTap: (){
                                    FocusScope.of(context).unfocus();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (con) => BrandsBottomSheet(),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text('${searchProvider.selectedBrand!.name}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                                      SizedBox(width: 20),

                                       const Spacer(),
                                      GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (con) => BrandsBottomSheet(),
                                            );
                                          },
                                          child: Container(
                                              width: 23,
                                              height: 23,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
                                                  borderRadius: BorderRadius.circular(3)),
                                              child: Icon(Icons.edit, color: ColorResources.COLOR_WHITE, size: 17)

                                          )
                                      )

                                    ],
                                  )
                              ),
                            ),

                            Divider(),

                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 5),
                              child: Text(getTranslated('category', context), style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
                            ),
                            searchProvider.selectedCategory == null?
                            GestureDetector(
                              onTap: (){
                                FocusScope.of(context).unfocus();
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (con) => CategoryBottomSheet(),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                                child: Container(
                                    height: 45,
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),

                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: ColorResources
                                              .COLOR_GREY_CHATEAU,

                                          width: 2),
                                    ),
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(searchProvider.selectedCategory != null?
                                        searchProvider.selectedCategory!.name! : getTranslated('select', context), style: TextStyle(fontSize: 15, color: Colors.black87)),
                                        SizedBox(width: 5),
                                        Icon(Icons.keyboard_arrow_down_rounded)
                                      ],
                                    )
                                ),
                              ),
                            ) :
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: GestureDetector(
                                  onTap: (){
                                    FocusScope.of(context).unfocus();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (con) => BrandsBottomSheet(),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text('${searchProvider.selectedCategory!.name}',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
                                      SizedBox(width: 20),

                                      new Spacer(),
                                      GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (con) => CategoryBottomSheet(),
                                            );
                                          },
                                          child: Container(
                                              width: 23,
                                              height: 23,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
                                                  borderRadius: BorderRadius.circular(3)),
                                              child: Icon(Icons.edit, color: ColorResources.COLOR_WHITE, size: 17)

                                          )
                                      )

                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(
                      Dimensions.PADDING_SIZE_SMALL),
                  child: CustomButton(
                    text: getTranslated(
                        'search', context),
                    onTap: () async {
                      if(searchProvider.selectedBrand == null){
                        showCustomSnackBar(getTranslated('please_select_brand', context), context);
                      }else {
                        String _categoryId;
                        if(searchProvider.selectedCategory != null) {
                          _categoryId = searchProvider.selectedCategory!.id.toString();
                        }else {
                          _categoryId = '0';
                        }
                         searchProvider.clearOffset();
                        searchProvider.getBrandsProductsList(
                            context,
                            '1',
                            searchProvider.selectedBrand!.id.toString(),
                          _categoryId,
                            ).then((value) {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> BrandProductsScreen()));
                        });
                      }
                    }
                  ),
                ),
              ),
            ],
          ) : Center(
            child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ));
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/custom_text_field.dart';

class CategoryBottomSheet extends StatefulWidget {

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CategoryModel> _searched = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String languageStr = getTranslated('set_language', context);
    return Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          List<CategoryModel> _categories = searchProvider.categoryList!;
          return  Stack(
            children: [
              Container(
                width: 550,
                height: 500,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                decoration: BoxDecoration(
                  color: ColorResources.BACKGROUND_COLOR,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) {
                    List<CategoryModel> _currentList = _searched.isNotEmpty? _searched : _categories;
                    return SingleChildScrollView(
                        child:  Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'Search',
                              isShowBorder: true,
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searched = _categories
                                      .where((element) => element.name!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                            ListView.builder(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              itemCount: _currentList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {

                                return GestureDetector(
                                  onTap: () async {
                                    searchProvider.setCategory(_currentList[index]);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      height: 60,
                                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(child: Text('${_currentList[index].name}', style: TextStyle(fontWeight: FontWeight.bold)))
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
              Positioned(
                right: 10,
                top: 5,
                child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close)),
              ),
            ],
          );
        });
  }
}

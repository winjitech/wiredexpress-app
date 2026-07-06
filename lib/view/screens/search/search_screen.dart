import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/localization/language_constrants.dart';
import 'package:wired_express/provider/search_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/utill/images.dart';
import 'package:wired_express/utill/styles.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/custom_text_field.dart';
import 'package:wired_express/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:wired_express/view/screens/search/search_result_screen.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();

    return Scaffold(
        backgroundColor: ColorResources.getScaffoldBackgroundColor(context!),

        body: SafeArea(
            child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child: Consumer<SearchProvider>(
                            builder:
                                (context, searchProvider, child) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CustomTextField(fill: true,
                                                  fillColor: ColorResources
                                                      .getTextFieldFillColor(
                                                          context),
                                                  hintText: getTranslated(
                                                      'search_items_here',
                                                      context),
                                                  isShowBorder: false,
                                                  isShowSuffixIcon: true,
                                                  suffixIconUrl: Images.search,
                                                  onSuffixTap: () {
                                                    if (_searchController
                                                            .text.length >
                                                        0) {
                                                      searchProvider
                                                          .saveSearchAddress(
                                                              _searchController
                                                                  .text);
                                                      searchProvider.sendSearch(
                                                          _searchController
                                                              .text);
                                                      searchProvider
                                                          .searchProduct(
                                                              _searchController
                                                                  .text,
                                                              context);

                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) => SearchResultScreen(
                                                                  searchString:
                                                                      _searchController
                                                                          .text,)));
                                                    }
                                                  },
                                                  controller: _searchController,
                                                  inputAction:
                                                      TextInputAction.search,
                                                  isIcon: true,
                                                  onSubmit: (text) {
                                                    if (_searchController
                                                            .text.length >
                                                        0) {
                                                      searchProvider
                                                          .saveSearchAddress(
                                                              _searchController
                                                                  .text);
                                                      searchProvider.sendSearch(
                                                          _searchController
                                                              .text);
                                                      searchProvider
                                                          .searchProduct(
                                                              _searchController
                                                                  .text,
                                                              context);
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) => SearchResultScreen(
                                                                  searchString:
                                                                      _searchController
                                                                          .text,)));
                                                    }
                                                  },
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    getTranslated(
                                                        'cancel', context),
                                                    style: AppTextStyles.h7(
                                                            context)
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ColorResources
                                                          .getTextColor(
                                                              context),
                                                    ),
                                                  ))
                                            ],
                                          ),

                                          // for resent search section
                                          SizedBox(height: 10.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    'recent_search', context),
                                                style: AppTextStyles.h4(context)
                                                    .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: ColorResources
                                                      .getGreyBunkerColor(
                                                          context),
                                                ),
                                              ),
                                              searchProvider
                                                          .historyList.length >
                                                      0
                                                  ? TextButton(
                                                      onPressed: searchProvider
                                                          .clearSearchAddress,
                                                      child: Text(
                                                        getTranslated(
                                                            'remove_all',
                                                            context),
                                                        style: AppTextStyles.h7(
                                                                context)
                                                            .copyWith(
                                                          color: ColorResources
                                                              .getGreyBunkerColor(
                                                                  context),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                            ],
                                          ),

                                          // for recent search list section
                                          Expanded(
                                              child: ListView.builder(
                                                  itemCount: searchProvider
                                                      .historyList.length,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemBuilder: (context,
                                                          index) =>
                                                      GestureDetector(
                                                          onTap: () {
                                                            searchProvider
                                                                .searchProduct(
                                                                    searchProvider
                                                                            .historyList[
                                                                        index],
                                                                    context);
                                                            searchProvider.sendSearch(
                                                                searchProvider
                                                                        .historyList[
                                                                    index]);
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        SearchResultScreen(
                                                                            searchString:
                                                                                searchProvider.historyList[index])));
                                                          },
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(Dimensions
                                                                      .PADDING_SIZE_SMALL),
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.history,
                                                                              size: 17.sp,
                                                                              color: ColorResources.getHintColor(context)),
                                                                          SizedBox(
                                                                              width: 13),
                                                                          Text(
                                                                            searchProvider.historyList[index],
                                                                            style:
                                                                                AppTextStyles.h7(
                                                                              context,
                                                                              fontSize: 17.sp,
                                                                            ).copyWith(
                                                                              color: ColorResources.getHintColor(context),
                                                                            ),
                                                                          )
                                                                        ]),
                                                                    Icon(
                                                                        Icons
                                                                            .arrow_upward,
                                                                        size:
                                                                            17,
                                                                        color: ColorResources.getHintColor(
                                                                            context))
                                                                  ])))))
                                        ])))))));
  }
}

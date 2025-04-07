import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/product_model.dart';
import 'package:wired_express/helper/product_type.dart';
import 'package:wired_express/helper/responsive_helper.dart';
import 'package:wired_express/provider/product_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:wired_express/utill/dimensions.dart';
import 'package:wired_express/view/base/circular_indicator_widget.dart';
import 'package:wired_express/view/base/no_data_screen.dart';
import 'package:wired_express/view/base/product_shimmer.dart';
import 'package:wired_express/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  final ProductType? productType;
  final ScrollController? scrollController;
  ProductView({@required this.productType, this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (productType == ProductType.POPULAR_PRODUCT) {
      Provider.of<ProductProvider>(context, listen: false)
          .getPopularProductList(context, '1');
    }

    int offset = 1;
    scrollController?.addListener(() {
      if (scrollController!.position.pixels ==
              scrollController!.position.maxScrollExtent &&
          Provider.of<ProductProvider>(context, listen: false)
                  .popularProductList !=
              null &&
          !Provider.of<ProductProvider>(context, listen: false).isLoading) {
        int? pageSize;
        if (productType == ProductType.POPULAR_PRODUCT) {
          pageSize = (Provider.of<ProductProvider>(context, listen: false)
                      .popularPageSize! /
                  10)
              .ceil();
        }
        if (offset < pageSize!) {
          offset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false)
              .showBottomLoader();
          Provider.of<ProductProvider>(context, listen: false)
              .getPopularProductList(context, offset.toString());
        }
      }
    });

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product>? productList = [];
        if (productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.popularProductList != null
              ? prodProvider.popularProductList
              : [];
          // print('product list -- ${jsonEncode(productList)}');
        }

        return Column(children: [
          productList != null
              ? productList.length > 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 0,
                          mainAxisExtent: 250,
                          crossAxisCount: 2),
                      itemCount: productList.length,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidget(product: productList![index]);
                      },
                    )
                  : NoDataScreen()
              : GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 225,
                      crossAxisCount: 2),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductShimmer(isEnabled: productList == null);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL)),
          prodProvider.isLoading
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child:CustomCircularIndicator(),
                ))
              : SizedBox(),
        ]);
      },
    );
  }
}

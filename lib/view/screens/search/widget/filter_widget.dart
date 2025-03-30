// import 'package:flutter/material.dart';
// import 'package:wired_express/data/model/response/category_model.dart';
// import 'package:wired_express/provider/category_provider.dart';
// import 'package:wired_express/utill/color_resources.dart';
// import 'package:provider/provider.dart';
//
// class FilterWidget extends StatelessWidget {
//   final CategoryProvider categoryProvider;
//
//   FilterWidget(this.categoryProvider);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [_categoryButtons(categoryProvider)],
//       ),
//     );
//   }
//
//   Widget _categoryButtons(CategoryProvider categoryProvider) {
//     List<CategoryModel> categoryList = categoryProvider.categoryFeaturedList!;
//     int recommendedIndex = categoryList.indexWhere(
//         (category) => category.name!.toLowerCase() == 'recommended');
//     if (recommendedIndex != -1) {
//       CategoryModel recommendedCategory = categoryList[recommendedIndex];
//       categoryList.removeAt(recommendedIndex);
//       categoryList.insert(0, recommendedCategory);
//     }
//
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: BouncingScrollPhysics(),
//       scrollDirection: Axis.horizontal,
//       itemCount: categoryList.length,
//       itemBuilder: (context, index) {
//         CategoryModel categoryModel = categoryList[index];
//         return Row(
//           children: [
//             _categoryText(context, categoryModel.name!, categoryProvider),
//             SizedBox(width: 8)
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _categoryText(
//       BuildContext context, String text, CategoryProvider categoryProvider) {
//     bool isSelected = categoryProvider.selectedCategory == text;
//
//     var featuredElement = categoryProvider.categoryFeaturedList
//         ?.firstWhere((element) => element.name == text);
//
//     int? getId = featuredElement?.id ?? null;
//
//     return MaterialButton(
//       onPressed: () {
//         categoryProvider.setCategory(text);
//         if (getId != null) {
//           categoryProvider.getCategoryProductList(context, getId.toString());
//         }
//       },
//       child: Text(
//         text,
//         style: TextStyle(
//           color: isSelected ? Colors.white : Colors.black,
//           fontSize: 16,
//         ),
//       ),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(40),
//       ),
//       color: isSelected ? ColorResources.SCAFFOLD_COLOR : Colors.grey[350],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/utill/color_resources.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  final CategoryProvider categoryProvider;

  FilterWidget(this.categoryProvider);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [_categoryButtons(categoryProvider)],
      ),
    );
  }

  Widget _categoryButtons(CategoryProvider categoryProvider) {
    List<CategoryModel> categoryList = categoryProvider.categoryFeaturedList!;
    // int recommendedIndex = categoryList.indexWhere(
    //         (category) => category.name!.toLowerCase() == 'recommended');
    // if (recommendedIndex != -1) {
    //   CategoryModel recommendedCategory = categoryList[recommendedIndex];
    //   categoryList.removeAt(recommendedIndex);
    //   categoryList.insert(0, recommendedCategory);
    // }

    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        CategoryModel categoryModel = categoryList[index];
        return Row(
          children: [
            _categoryText(context, categoryModel.name!, categoryProvider),
            SizedBox(width: 8)
          ],
        );
      },
    );
  }

  Widget _categoryText(
      BuildContext context, String text, CategoryProvider categoryProvider) {
    bool isSelected = categoryProvider.selectedCategory == text;

    var featuredElement = categoryProvider.categoryFeaturedList
        ?.firstWhere((element) => element.name == text);

    int? getId = featuredElement?.id ?? null;

    return MaterialButton(
      onPressed: () {
        categoryProvider.setCategory(text);
        if (getId != null) {
          categoryProvider.getCategoryProductList(context, getId.toString());
        }
      },
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: isSelected ? ColorResources.SCAFFOLD_COLOR : Colors.grey[350],
    );
  }
}

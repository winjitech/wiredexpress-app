import 'package:flutter/material.dart';
import 'package:wired_express/data/model/response/category_model.dart';
import 'package:wired_express/provider/category_provider.dart';
import 'package:wired_express/utill/color_resources.dart';

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
    bool isSelected = categoryProvider.selectedCategory?.name!.toLowerCase() ==
        text.toLowerCase();

    var featuredElement = categoryProvider.categoryFeaturedList
        ?.firstWhere((element) => element.name == text);

    int? getId = featuredElement?.id ?? null;

    return MaterialButton(
      onPressed: () {
        categoryProvider.setCategory(featuredElement!);
        if (getId != null) {
          categoryProvider.clearCategoryProductListOffset();

          categoryProvider.getCategoryProductList(
              context, "1", getId.toString());
        }
      },
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: isSelected
              ? ColorResources.getCardColor(context)
              : ColorResources.getTextColor(context),
          fontSize: 16,
        ),
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: isSelected
          ? ColorResources.getPrimaryColor(context)
          : ColorResources.getTextFieldFillColor(context),
    );
  }
}

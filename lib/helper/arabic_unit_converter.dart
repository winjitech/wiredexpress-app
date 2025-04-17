class ArabicUnitConverter {

  static String convert(String str) {
    str = str.replaceAll('piece', 'قطعة');
    str = str.replaceAll('gram', 'جرام');
    str = str.replaceAll('liter', 'ليتر');
    str = str.replaceAll('milliliter', 'مليلتر');
    str = str.replaceAll('teaspoon', 'ملعقة صغيرة');
    str = str.replaceAll('tablespoon', 'ملعقة كبيرة');
    str = str.replaceAll('slice', 'شريحة');
    str = str.replaceAll('cup', 'كوب');
    str = str.replaceAll('breast', 'صدر');
    str = str.replaceAll('meal', 'وجبة');
    str = str.replaceAll('breast', 'صدر');

    return str;
  }
}

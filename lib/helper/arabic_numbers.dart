class ArabicNumberConverter {

  static String textSelect(String str) {
    str = str.replaceAll('1', '١');
    str = str.replaceAll('2', '٢');
    str = str.replaceAll('3', '٣');
    str = str.replaceAll('4', '٤');
    str = str.replaceAll('5', '٥');
    str = str.replaceAll('6', '٦');
    str = str.replaceAll('7', '٧');
    str = str.replaceAll('8', '٨');
    str = str.replaceAll('9', '٩');
    str = str.replaceAll('0', '٠');
    str = str.replaceAll('.', '،');
    return str;
  }
}

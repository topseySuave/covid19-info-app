class Helpers {
  static String addCommas(String val) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return val.replaceAllMapped(reg, mathFunc);
  }
}

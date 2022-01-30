import '../config.dart';

class Utils {
  static bool isImage(String name) {
    return Config.imageExtensions.contains(getFileExtension(name));
  }

  static String getFileExtension(String fileName) {
    return fileName.split('.')[fileName.split('.').length - 1];
  }

  static String decoratePhoneNumber(String number) {
    List<String> numberList = [];
    Map numberMap = number.split('').asMap();

    numberList.add('+7(');
    numberList.add(numberMap.containsKey(0) ? numberMap[0] : '');
    numberList.add(numberMap.containsKey(1) ? numberMap[1] : '');
    numberList.add(numberMap.containsKey(2) ? numberMap[2] : '');
    numberList.add(')');
    numberList.add(numberMap.containsKey(3) ? numberMap[3] : '');
    numberList.add(numberMap.containsKey(4) ? numberMap[4] : '');
    numberList.add(numberMap.containsKey(5) ? numberMap[5] : '');
    numberList.add(numberMap.containsKey(5) ? '-' : '');
    numberList.add(numberMap.containsKey(6) ? numberMap[6] : '');
    numberList.add(numberMap.containsKey(7) ? numberMap[7] : '');
    numberList.add(numberMap.containsKey(7) ? '-' : '');
    numberList.add(numberMap.containsKey(8) ? numberMap[8] : '');
    numberList.add(numberMap.containsKey(9) ? numberMap[9] : '');

    return numberList.join('');
  }
}

import 'package:cashcow/utils/constants/languages.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  // Define your translations in a map with language codes as keys
  @override
  Map<String, Map<String, String>> get keys => languages;
}

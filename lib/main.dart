import 'dart:io';
import 'package:easy_ops/constants/constant.dart';
import 'package:easy_ops/constants/dependency_injection/dependency_injection.dart';
import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/constants/values/app_language.dart';
import 'package:easy_ops/route_managment/all_pages.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:easy_ops/ui/binding/screen_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/theme_controller.dart';
import 'network/my_http_overrides.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  await GetStorage.init();
  HttpOverrides.global = MyHttpOverrides();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  Get.put(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final String language;
    final String country;
    language = Constant.englishLanguage;
    country = Constant.englishCountry;
    return Obx(() {
      return GetMaterialApp(
        
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        translations: Languages(),
        locale: Locale(language, country),
        fallbackLocale: Locale(language, country),
        theme: themeController.currentTheme.value,
        initialRoute: Routes.splashPage,
        initialBinding: ScreenBindings(),
        getPages: AllPages.getPages(),
      );
    });
  }
}

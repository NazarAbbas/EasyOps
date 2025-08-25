import 'package:easy_ops/route_managment/routes.dart';
import 'package:easy_ops/ui/binding/screen_binding.dart';
import 'package:easy_ops/ui/modules/assest_management/assest_management_dashboard/ui/assest_management_dashboard.dart';
import 'package:easy_ops/ui/modules/break_down_management/break_down_management_dashboard/ui/work_order_management.dart';
import 'package:easy_ops/ui/modules/forgot_password/ui/forgot_password_page.dart';
import 'package:easy_ops/ui/modules/login/ui/login_page.dart';
import 'package:easy_ops/ui/modules/splash/ui/spalsh_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AllPages {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: Routes.splashPage,
        page: () => SplashPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.loginScreen,
        page: () => LoginPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.forgotPasswordScreen,
        page: () => ForgotPasswordPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
       GetPage(
        name: Routes.workOrderManagement,
        page: () => WorkOrderManagement(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
       GetPage(
        name: Routes.assestManagementDashboard,
        page: () => AssestManagementDashboard(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
    ];
  }
}

import 'package:easy_ops/route_managment/routes.dart';
import 'package:easy_ops/ui/binding/screen_binding.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/mc_history/ui/mc_history_page.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/operator_info/ui/operator_info_page.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/work_order_detail/ui/work_order_detail_page.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/tabs/ui/work_order_tabs_shell.dart';
import 'package:easy_ops/ui/modules/work_order_management/work_order_management_dashboard/ui/bottom_navigation/navigation_bottom_assets.dart';
import 'package:easy_ops/ui/modules/work_order_management/work_order_management_dashboard/ui/bottom_navigation/navigation_bottom_home_page.dart';
import 'package:easy_ops/ui/modules/work_order_management/work_order_management_dashboard/ui/work_order_list/work_orders_page.dart';
import 'package:easy_ops/ui/modules/forgot_password/ui/forgot_password_page.dart';
import 'package:easy_ops/ui/modules/update_password/ui/update_password_page.dart';
import 'package:easy_ops/ui/modules/login/ui/login_page.dart';
import 'package:easy_ops/ui/modules/splash/ui/spalsh_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AllPages {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: Routes.splashScreen,
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
        name: Routes.updatePasswordScreen,
        page: () => UpdatePasswordPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.workOrderScreen,
        page: () => WorkOrdersPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.bottomNavigationHomeScreen,
        page: () => NavigationBottomHomePage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.bottomNavigationAssetsScreen,
        page: () => NavigationBottomAssets(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.workOrderInfoScreen,
        page: () => WorkOrdersPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.operatorInfoScreen,
        page: () => OperatorInfoPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.mcHistoryScreen,
        page: () => McHistoryPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.workOrderTabShellScreen,
        page: () => WorkOrderTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.workOrderDetailScreen,
        page: () => WorkOrderDetailsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
    ];
  }
}

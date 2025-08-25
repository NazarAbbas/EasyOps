import 'package:easy_ops/ui/modules/assest_management/assest_management_dashboard/controller/assest_management_dashboard_controller.dart';
import 'package:easy_ops/ui/modules/break_down_management/break_down_management_dashboard/controller/work_order_management_controller.dart';
import 'package:easy_ops/ui/modules/forgot_password/controller/forgot_password_controller.dart';
import 'package:easy_ops/ui/modules/login/controller/login_controller.dart';
import 'package:easy_ops/ui/modules/splash/controller/splash_controller.dart';
import 'package:get/instance_manager.dart';

class ScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashPageController());
    Get.lazyPut(() => LoginPageController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => WorkOrderManagementController());
    Get.lazyPut(() => AssestManagementDashboardController());
  }
}

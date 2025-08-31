import 'package:easy_ops/ui/modules/work_order_management/create_work_order/operator_info/controller/operator_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/work_order_info/controller/work_order_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/work_order_management_dashboard/controller/work_order_list_controller.dart';
import 'package:easy_ops/ui/modules/forgot_password/controller/forgot_password_controller.dart';
import 'package:easy_ops/ui/modules/login/controller/login_controller.dart';
import 'package:easy_ops/ui/modules/splash/controller/splash_controller.dart';
import 'package:easy_ops/ui/modules/update_password/controller/update_password_controller.dart';
import 'package:get/instance_manager.dart';

class ScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashPageController());
    Get.lazyPut(() => LoginPageController());
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => WorkOrdersController());
    Get.lazyPut(() => UpdatePasswordController());
    Get.lazyPut(() => WorkOrdersController());
    Get.lazyPut(() => WorkorderInfoController());
    Get.lazyPut(() => WorkTabsController());
    Get.lazyPut(() => OperatorInfoController());
  }
}

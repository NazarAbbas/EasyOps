import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/controller/operator_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/work_order_info/controller/work_order_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/controller/WorkTabsController.dart';
import 'package:easy_ops/ui/modules/work_order_management/dashboard/controller/work_orders_controller.dart';
import 'package:easy_ops/ui/modules/forgot_password/controller/forgot_password_controller.dart';
import 'package:easy_ops/ui/modules/login/controller/login_controller.dart';
import 'package:easy_ops/ui/modules/splash/controller/splash_controller.dart';
import 'package:easy_ops/ui/modules/update_password/controller/UpdatePasswordController.dart';
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

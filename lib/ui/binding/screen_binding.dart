import 'package:easy_ops/ui/modules/assets_management/assets_dashboard/controller/assets_dashboard_controller.dart';
import 'package:easy_ops/ui/modules/assets_management/assets_details/controller/assets_details_controller.dart';
import 'package:easy_ops/ui/modules/assets_management/assets_management_dashboard/controller/assets_management_list_controller.dart';
import 'package:easy_ops/ui/modules/assets_management/assets_specification/controller/assets_specification_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/mc_history/controller/mc_history_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/operator_info/controller/operator_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/work_order_info/controller/work_order_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/update_work_order/closure_work_order/controller/closure_work_order_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/update_work_order/history/controller/update_history_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/update_work_order/re_open_work_order/controller/re_open_work_order_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/update_work_order/timeline/controller/update_timeline_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/update_work_order/work_order/controller/update_work_order_controller.dart';
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
    Get.lazyPut(() => UpdateWorkOrderDetailsController());
    Get.lazyPut(() => UpdateWorkTabsController());
    Get.lazyPut(() => ReopenWorkOrderController());
    Get.lazyPut(() => ClosureWorkOrderController());
    Get.lazyPut(() => WorkOrderTimelineController());
    Get.lazyPut(() => UpdateHistoryController());
    Get.lazyPut(() => McHistoryController());
    Get.lazyPut(() => AssetsManagementDashboardController());
    Get.lazyPut(() => AssetsDetailController());
    Get.lazyPut(() => AssetSpecificationController());
    Get.lazyPut(() => AssetsDashboardController());
  }
}

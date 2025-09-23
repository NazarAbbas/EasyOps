import 'package:easy_ops/features/assets_management/assets_dashboard/controller/assets_dashboard_controller.dart';
import 'package:easy_ops/features/assets_management/assets_details/controller/assets_details_controller.dart';
import 'package:easy_ops/features/assets_management/assets_history/controller/assets_history_controller.dart';
import 'package:easy_ops/features/assets_management/assets_management_dashboard/controller/assets_management_list_controller.dart';
import 'package:easy_ops/features/assets_management/assets_specification/controller/assets_specification_controller.dart';
import 'package:easy_ops/features/assets_management/pm_checklist/controller/pm_checklist_controller.dart';
import 'package:easy_ops/features/assets_management/pm_schedular/controller/pm_schedular_controller.dart';
import 'package:easy_ops/features/cancel_work_order/controller/cancel_work_order_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/alerts/controller/alerts_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/home_dashboard/controller/home_dashboard_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/my_dashboard/controller/my_dashboard_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/new_suggestion/controller/new_suggestions_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/profile/controller/profile_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestion/controller/suggestion_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/suggestions_details/controller/suggestions_details_controller.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/support/controller/support_controller.dart';
import 'package:easy_ops/features/dashboard_screens/landing_dashboard/controller/landing_dashboard_nav_controller.dart';
import 'package:easy_ops/features/staff/controller/current_shift_controller.dart';
import 'package:easy_ops/features/staff/controller/staff_search_controller.dart';
import 'package:easy_ops/features/work_order_management/common_models/work_draft_model.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/mc_history/controller/mc_history_controller.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/operator_info/controller/operator_info_controller.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/work_order_info/controller/work_order_info_controller.dart';
import 'package:easy_ops/features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/closure_work_order/controller/closure_work_order_controller.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/history/controller/update_history_controller.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/re_open_work_order/controller/re_open_work_order_controller.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/timeline/controller/update_timeline_controller.dart';
import 'package:easy_ops/features/work_order_management/update_work_order/work_order/controller/update_work_order_controller.dart';
import 'package:easy_ops/features/work_order_management/work_order_management_dashboard/controller/work_order_list_controller.dart';
import 'package:easy_ops/features/forgot_password/controller/forgot_password_controller.dart';
import 'package:easy_ops/features/login/controller/login_controller.dart';
import 'package:easy_ops/features/splash/controller/splash_controller.dart';
import 'package:easy_ops/features/update_password/controller/update_password_controller.dart';
import 'package:get/instance_manager.dart';

class ScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.putAsync<WorkOrderDraft>(
      () => WorkOrderDraft().init(),
      permanent: true,
    );

    //Controllers
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
    Get.lazyPut(() => PMScheduleController());
    Get.lazyPut(() => PMChecklistController());
    Get.lazyPut(() => AssetsHistoryController());
    Get.lazyPut(() => HomeDashboardController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => SupportController());
    Get.lazyPut(() => SuggestionsController());
    Get.lazyPut(() => NewSuggestionController());
    Get.lazyPut(() => SuggestionDetailController());
    Get.lazyPut(() => AlertsController());
    Get.lazyPut(() => CancelWorkOrderController());
    Get.lazyPut(() => CurrentShiftController());
    Get.lazyPut(() => StaffSearchController());
    Get.lazyPut(() => MyDashboardController());
    // e.g. in main() or a Binding of the root shell
    // Get.put(LandingRootNavController(), permanent: true);
    Get.lazyPut<LandingRootNavController>(
      () => LandingRootNavController(),
      fenix: true,
    );

    Get.lazyPut<WorkOrderBag>(
      () => WorkOrderBag(),
      fenix: false,
    );

    //Get.find<WorkOrderBag>().clear();

    // Get.lazyPut(() => LandingRootNavController());

    //  Get.lazyPut(() => AlertsController());
    //   Get.lazyPut(() => AlertsController());
    //    Get.lazyPut(() => AlertsController());
    //     Get.lazyPut(() => AlertsController());
    //      Get.lazyPut(() => AlertsController());
    //       Get.lazyPut(() => AlertsController());
  }
}

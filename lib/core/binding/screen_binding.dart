import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_dashboard/controller/assets_dashboard_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_details/controller/assets_details_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_history/controller/assets_history_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_management_dashboard/controller/assets_management_list_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_specification/controller/assets_specification_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/pm_checklist/controller/pm_checklist_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/pm_schedular/controller/pm_schedular_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/alerts/controller/alerts_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/home_dashboard/controller/home_dashboard_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/my_dashboard/controller/my_dashboard_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/staff/controller/current_shift_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/staff/controller/staff_search_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/suggestions_details/controller/suggestions_details_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_screens/general_work_order/controller/genral_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_screens/landing_dashboard/controller/landing_dashboard_nav_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_screens/preventive_dashboard/controller/preventive_dashboard_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_cancel_work_order/controller/me_cancel_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_closure/controller/general_closure_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_closure_signature/controller/general_sign_off_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_diagnostics/controller/general_diagnostics_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_hold_work_order/controller/general_hold_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_pending_activity/controller/general_pending_activity_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_rca_analysis/controller/general_rca_analysis_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_reassign_work_order/ui/me_general_reassign_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_reopen_work_order/controller/general_reopen_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_return_spare_parts/controller/general_return_spare_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_start_work_order/controller/general_start_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_tabs/controller/general_work_order_details_tabs_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_timeline/controller/general_work_order_timeline_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_work_order_list/controller/general_work_order_list_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_work_order_submit/controller/general_work_order_submit_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/WorkTabsController.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/accept_work_order/controller/accept_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/cancel_work_order/controller/cancel_work_order_controller_from_diagnostics.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/closure/controller/closure_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/closure_signature/controller/sign_off_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/diagnostics/controller/me_diagnostics_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/history/controller/history_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/hold_work_order/controller/me_hold_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/maintenance_wotk_order_management/controller/work_order_management_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/controller/pending_activity_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/controller/rca_analysis_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/reassign_work_order/controller/me_reassign_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/controller/request_spares_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/ui/maintenance_engeneer_request_spares_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/return_spare_parts/controller/return_spare_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/controller/spare_cart_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/start_work_order/controller/me_start_work_order_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/start_work_submit/controller/start_work_submit_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/tabs/controller/work_order_details_tabs_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/timeline/controller/timeline_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/add_resource/controller/add_resource_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/confirm_wotk_order_slot/controller/me_confirm_work_order_slot_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/preventive_start_work/controller/preventive_start_work_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/preventive_work_order_list/controller/me_preventive_work_order_list_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/puposed_new_slot/controller/purposed_new_slot_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/reschedular/controller/reschedule_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_spare_parts/consume_spare_parts/controller/consume_spare_parts_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_spare_parts/return_spare_parts/controller/return_spare_parts_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_spare_parts/tabs/controller/spare_parts_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_dashboard/controller/assets_dashboard_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_details/controller/assets_details_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_history/controller/assets_history_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_management_dashboard/controller/assets_management_list_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_specification/controller/assets_specification_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/pm_checklist/controller/pm_checklist_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/pm_schedular/controller/pm_schedular_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/controller/cancel_work_order_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/alerts/controller/alerts_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/home_dashboard/controller/home_dashboard_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/my_dashboard/controller/my_dashboard_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/controller/new_suggestions_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/profile/controller/profile_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/suggestion/controller/suggestion_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/suggestions_details/controller/suggestions_details_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/support/controller/support_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_screens/landing_dashboard/controller/landing_dashboard_nav_controller.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_screens/preventive_dashboard/controller/preventive_dashboard_controller.dart';
import 'package:easy_ops/features/production_manager_features/feature_preventive_maintenance/preventive_work_order_list/controller/preventive_work_order_list_controller.dart';
import 'package:easy_ops/features/production_manager_features/feature_preventive_maintenance/puposed_new_slot/controller/purposed_new_slot_controller.dart';
import 'package:easy_ops/features/production_manager_features/staff/controller/current_shift_controller.dart';
import 'package:easy_ops/features/production_manager_features/staff/controller/staff_search_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/common_models/work_draft_model.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/lookups/create_work_order_bag.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/mc_history/controller/mc_history_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/operator_info/controller/operator_info_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/work_order_info/controller/work_order_info_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/closure_work_order/controller/closure_work_order_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/history/controller/update_history_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/re_open_work_order/controller/re_open_work_order_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/controller/update_work_tabs_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/timeline/controller/update_timeline_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/work_order/controller/update_work_order_controller.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/controller/work_order_list_controller.dart';
import 'package:easy_ops/features/common_features/forgot_password/controller/forgot_password_controller.dart';
import 'package:easy_ops/features/common_features/login/controller/login_controller.dart';
import 'package:easy_ops/features/common_features/splash/controller/splash_controller.dart';
import 'package:easy_ops/features/common_features/update_password/controller/update_password_controller.dart';
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
    //Get.put(WorkTabsController(), permanent: true);
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
    Get.lazyPut(() => PreventiveWorkOrderListController());
    Get.lazyPut(() => PurposedNewSlotController());
    Get.lazyPut(() => PreventiveRootNavController());
    Get.lazyPut<LandingRootNavController>(
      () => LandingRootNavController(),
      fenix: true,
    );

    Get.lazyPut<WorkOrderBag>(
      () => WorkOrderBag(),
      fenix: false,
    );

    //Engineer App

    Get.lazyPut(() => MaintenanceEnginnerSparePartsController());
    Get.lazyPut(() => MaintenanceEngineerWorkTabsController());
    Get.lazyPut(() => MaintenanceEnginnerWorkOrderDetailsTabsController());
    Get.lazyPut(() => MaintenanceEngeneerAssetsManagementDashboardController());
    Get.lazyPut(() => MaintenanceEngineerAssetsDetailController());
    Get.lazyPut(() => MaintenanceEngineerAssetSpecificationController());
    Get.lazyPut(() => MaintenanceEnginnerAssetsDashboardController());
    Get.lazyPut(() => MaintenanceEnginnerPMScheduleController());
    Get.lazyPut(() => MaintenanceEnginnerPMChecklistController());
    Get.lazyPut(() => MaintenanceEnginnerAssetsHistoryController());
    Get.lazyPut(() => MaintenanceEnginnerHomeDashboardController());
    // Get.lazyPut(() => MaintenanceEnginnerProfileController());
    //  Get.lazyPut(() => MaintenanceEnginnerSupportController());
    //Get.lazyPut(() => MaintenanceEnginnerSuggestionsController());
    //  Get.lazyPut(() => MaintenanceEnginnerNewSuggestionController());
    Get.lazyPut(() => MaintenanceEnginnerSuggestionDetailController());
    Get.lazyPut(() => MaintenanceEnginnerAlertsController());
    Get.lazyPut(() => MaintenanceEnginnerReturnSparePartsController());
    Get.lazyPut(() => MaintenanceEnginnerConsumedSparePartsController());
    Get.lazyPut(() => MaintenanceEnginnerWorkOrdersManagementController());
    Get.lazyPut(() => MEReassignWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerStartWorkSubmitController());
    Get.lazyPut(() => MEHoldWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerDiagnosticsController());
    Get.lazyPut(
        () => MaintenanceEnginnerCancelWorkOrderControllerFromDiagnostics());
    Get.lazyPut(() => MaintenanceEnginnerClosureController());
    Get.lazyPut(() => MaintenanceEnginnerSignOffController());
    Get.lazyPut(() => MaintenanceEnginnerReturnSparesController());
    Get.lazyPut(() => MaintenanceEnginnerRcaAnalysisController());
    Get.lazyPut(() => MaintenanceEnginnerPendingActivityController());
    Get.lazyPut(() => MaintenanceEnginnerSparesRequestController());
    Get.lazyPut(() => MaintenanceEnginnerHistoryController());
    Get.lazyPut(() => MaintenanceEnginnerTimelineController());
    Get.lazyPut(() => MEPreventiveWorkOrderListController());
    Get.lazyPut(() => MEPreventiveWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerPurposedNewSlotController());
    Get.lazyPut(() => MaintenanceEnginnerPreventiveStartWorkController());
    Get.lazyPut(() => MaintenanceEnginnerAddResourceController());
    Get.lazyPut(() => MaintenanceEnginnerRescheduleController());
    Get.lazyPut(() => MaintenanceEnginnerAcceptWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerCurrentShiftController());
    Get.lazyPut(() => MaintenanceEnginnerStaffSearchController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralWorkOrderListController());
    Get.lazyPut(() => MaintenanceEnginnerGenreralOrderDetailsTabsController);
    Get.lazyPut(() => MaintenanceEnginnerMyDashboardController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralWorkOrderTimelineController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralStartWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralReOpenWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralWorkOrderSubmitController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralDiagnosticsController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralReassignWorkOrderPage());
    Get.lazyPut(() => MaintenanceEnginnerGeneralCancelWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralHoldWorkOrderController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralClosureController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralSignOffController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralPendingActivityController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralRcaAnalysisController());
    Get.lazyPut(() => MaintenanceEnginnerGeneralReturnSpareController());
    Get.lazyPut(() => MaintenanceEnginnerStartWorkOrderController());

    //Get.lazyPut(() => PreventiveRootNavController());
    Get.lazyPut<MaintenanceEnginnerPreventiveRootNavController>(
      () => MaintenanceEnginnerPreventiveRootNavController(),
      fenix: true,
    );
    Get.lazyPut<MaintenanceEnginnerLandingRootNavController>(
      () => MaintenanceEnginnerLandingRootNavController(),
      fenix: true,
    );
    Get.lazyPut<MaintenanceEnginnerGenralWorkOrderRootNavController>(
      () => MaintenanceEnginnerGenralWorkOrderRootNavController(),
      fenix: true,
    );
    Get.put(MaintenanceEnginnerSpareCartController(),
        permanent: true); // shared cart
    // Keep ONE StartWorkOrderController for the active WO.
    // (If you support multiple WO pages at once, use tags.)
    if (!Get.isRegistered<MaintenanceEnginnerStartWorkOrderController>()) {
      Get.put(MaintenanceEnginnerStartWorkOrderController(), permanent: true);
    }
  }
}

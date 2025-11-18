import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/binding/screen_binding.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_dashboard/ui/maintenance_engeneer_assets_dashboard_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_details/ui/maintenance_engeneer_assets_details_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_history/ui/maintenance_engeneer_assets_history_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_management_dashboard/ui/maintenance_engeneer_assets_management_dashboard_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/assets_specification/ui/maintenance_engeneer_assets_specification_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/pm_checklist/ui/maintenance_engeneer_pm_checklist_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_assets_management/pm_schedular/ui/maintenance_engeneer_pm_schedular_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/alerts/ui/maintenance_engeneer_alerts_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/home_dashboard/ui/maintenance_engeneer_home_dashboard_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/my_dashboard/ui/maintenance_engeneer_my_dashboard_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/new_suggestion/ui/maintenance_engeneer_new_suggestion_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/profile/ui/maintenance_engeneer_profile_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/staff/ui/maintenance_engeneer_staff_tabs_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/suggestion/ui/maintenance_engeneer_suggestion_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/suggestions_details/ui/maintenance_engeneer_suggestions_details_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_profile_staff_suggestion/support/ui/maintenance_engeneer_support_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_screens/general_work_order/ui/maintenance_engeneer_general_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_screens/landing_dashboard/ui/maintenance_engeneer_landing_dashboard_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_screens/preventive_dashboard/ui/maintenance_engeneer_preventive_dashboard_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_cancel_work_order/ui/me_cancel_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_closure/ui/maintenance_engeneer_general_closure_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_closure_signature/ui/maintenance_engineer_general_sign_off_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_diagnostics/ui/maintenance_engineer_general_diagnostics_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_hold_work_order/ui/maintenance_engineer_general_hold_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_pending_activity/ui/maintenance_engineer_general_panding_activity_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_rca_analysis/ui/maintenance_engineer_general_rca_analysis_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_reassign_work_order/ui/me_general_reassign_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_reopen_work_order/ui/maintenance_engineer_general_reopen_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_return_spare_parts/ui/maintenance_engineer_general_return_spare_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_start_work_order/ui/maintenance_engineer_general_start_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_tabs/ui/maintenance_engeneer_general_work_order_details_tabs_shell.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_work_order_submit/ui/maintenance_engineer_general_work_order_submit_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/accept_work_order/ui/maintenance_engeneer_accept_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/cancel_work_order/ui/maintenance_engeneer_cancel_work_order_page_from_diagnostic.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/closure_signature/ui/maintenance_engeneer_sign_off_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/diagnostics/ui/maintenance_engeneer_diagnostics_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/history/ui/maintenance_engeneer_history_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/hold_work_order/ui/me_hold_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/maintenance_wotk_order_management/ui/maintenance_engeneer_work_order_management_list_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/ui/maintenance_engeneer_panding_activity_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/ui/maintenance_engeneer_rca_analysis_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/reassign_work_order/ui/me_reassign_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/controller/request_spares_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/ui/maintenance_engeneer_request_spares_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/return_spare_parts/ui/me_return_spare_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/ui/maintenance_engeneer_spare_cart_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/start_work_order/ui/maintenance_engeneer_start_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/start_work_submit/ui/maintenance_engeneer_start_work_submit_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/tabs/ui/maintenance_engeneer_work_order_details_tabs_shell.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/timeline/ui/maintenance_engeneer_timeline_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/add_resource/ui/maintenance_engeneer_add_resource_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/confirm_wotk_order_slot/ui/me_confirm_work_order_slot_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/preventive_start_work/ui/maintenance_engeneer_preventive_start_work_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/preventive_work_order_list/ui/me_preventive_work_order_list_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/puposed_new_slot/ui/maintenance_engeneer_purposed_new_slot_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/reschedular/ui/maintenance_engeneer_reschedule_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_spare_parts/tabs/ui/maintenance_engeneer_spare_parts_tabs_shell.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_dashboard/ui/assets_dashboard_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_details/ui/assets_details_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_history/ui/assets_history_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_management_dashboard/ui/assets_management_dashboard_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/assets_specification/ui/assets_specification_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/pm_checklist/ui/pm_checklist_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/assets_management/pm_schedular/ui/pm_schedular_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/cancel_work_order/ui/cancel_work_order_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/alerts/ui/alerts_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/home_dashboard/ui/home_dashboard_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/my_dashboard/ui/my_dashboard_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/ui/new_suggestion_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/profile/ui/profile_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/suggestion/ui/suggestion_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/suggestions_details/ui/suggestions_details_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/support/ui/support_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_screens/landing_dashboard/ui/landing_dashboard_page.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_screens/preventive_dashboard/ui/preventive_dashboard_page.dart';
import 'package:easy_ops/features/production_manager_features/feature_preventive_maintenance/preventive_work_order_list/ui/preventive_work_order_list_page.dart';
import 'package:easy_ops/features/production_manager_features/feature_preventive_maintenance/puposed_new_slot/ui/purposed_new_slot_page.dart';
import 'package:easy_ops/features/production_manager_features/staff/ui/staff_tabs_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/mc_history/ui/mc_history_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/operator_info/ui/operator_info_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/work_order_detail/ui/work_order_detail_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/tabs/ui/work_order_tabs_shell.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/work_order_info/ui/work_order_info_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/edit_work_order/operator_info/ui/edit_operator_info_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/edit_work_order/tabs/ui/edit_work_order_tabs_shell.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/edit_work_order/work_order_detail/ui/edit_work_order_detail_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/edit_work_order/work_order_info/ui/edit_work_order_info_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/closure_work_order/ui/closure_work_order_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/re_open_work_order/ui/re_open_work_order_page.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/update_work_order/tabs/ui/update_work_order_tabs_shell.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/ui/bottom_navigation/navigation_bottom_assets.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/ui/work_order_list/work_orders_list_page.dart';
import 'package:easy_ops/features/common_features/forgot_password/ui/forgot_password_page.dart';
import 'package:easy_ops/features/common_features/update_password/ui/update_password_page.dart';
import 'package:easy_ops/features/common_features/login/ui/login_page.dart';
import 'package:easy_ops/features/common_features/splash/ui/spalsh_page.dart';
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
        page: () => WorkOrdersListPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.homeDashboardScreen,
        page: () => HomeDashboardPage(),
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
        page: () => WorkOrderInfoPage(),
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
      GetPage(
        name: Routes.updateWorkOrderTabScreen,
        page: () => WorkOrderTabsDetails(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.reOpenWorkOrderScreen,
        page: () => ReopenWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.closureWorkOrderScreen,
        page: () => ClosureWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.assetsManagementDashboardScreen,
        page: () => AssetsManagementDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.assetsDetailsScreen,
        page: () => AssetsDetailPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.assetsSpecificationScreen,
        page: () => AssetsSpecificationPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.assetsDashboardScreen,
        page: () => AssetsDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.assetsPMSchedular,
        page: () => PMSchedulePage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.pMCheckListScreen,
        page: () => PMChecklistPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.assetsHistoryScreen,
        page: () => AssetsHistoryPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.profileScreen,
        page: () => ProfilePage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.supportScreen,
        page: () => SupportPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.suggestionScreen,
        page: () => SuggestionsPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.newSuggestionScreen,
        page: () => NewSuggestionPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.suggestionDetailsScreen,
        page: () => SuggestionDetailPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.alertScreen,
        page: () => AlertsPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.editWorkOrderTabShellScreen,
        page: () => EditWorkOrderTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.editWorkOrderInfoScreen,
        page: () => EditWorkOrderInfoPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.editOperatorInfoScreen,
        page: () => EditOperatorInfoPage(),
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
        name: Routes.editWorkOrderDetailScreen,
        page: () => EditWorkOrderDetailsPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.cancelWorkOrderScreen,
        page: () => CancelWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.landingDashboardScreen,
        page: () => LandingDashboardTabShell(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.staffScreen,
        page: () => StaffTabsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.myDashboardScreen,
        page: () => MyDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.preventivePurposeNewSlotScreen,
        page: () => PurposedNewSlotPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.preventiveWorkOrderListScreen,
        page: () => PreventiveWorkOrderListPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.preventiveDashboardScreen,
        page: () => PreventiveDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      //Engineer App

      GetPage(
        name: Routes.maintenanceEngeneerworkOrderManagementScreen,
        page: () => MaintenanceEngineerWorkOrdersManagementListPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerhomeDashboardScreen,
        page: () => MaintenanceEngineerHomeDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerassetsManagementDashboardScreen,
        page: () =>
            MaintenanceEngineerHomeDashboardPageAssetsManagementDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsDetailsScreen,
        page: () => MaintenanceEngineerAssetsDetailPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsSpecificationScreen,
        page: () => MaintenanceEngineerAssetsSpecificationPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsDashboardScreen,
        page: () => MaintenanceEngineerAssetsDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsPMSchedular,
        page: () => MaintenanceEngineerPMSchedulePage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpMCheckListScreen,
        page: () => MaintenanceEngineerPMChecklistPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsHistoryScreen,
        page: () => MaintenanceEngineerAssetsHistoryPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerupdateWorkOrderTabScreen,
        page: () => MaintenanceEngineerWorkOrderDetailsTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      // GetPage(
      //   name: Routes.maintenanceEngeneerprofileScreen,
      //   page: () => MaintenanceEngineerProfilePage(),
      //   binding: ScreenBindings(),
      //   transition: Transition.zoom,
      // ),
      // GetPage(
      //   name: Routes.maintenanceEngeneersupportScreen,
      //   page: () => MaintenanceEngineerSupportPage(),
      //   binding: ScreenBindings(),
      //   transition: Transition.zoom,
      // ),
      // GetPage(
      //   name: Routes.maintenanceEngeneersuggestionScreen,
      //   page: () => MaintenanceEngineerSuggestionsPage(),
      //   binding: ScreenBindings(),
      //   transition: Transition.zoom,
      // ),
      // GetPage(
      //   name: Routes.maintenanceEngeneernewSuggestionScreen,
      //   page: () => MaintenanceEngineerNewSuggestionPage(),
      //   binding: ScreenBindings(),
      //   transition: Transition.zoom,
      // ),
      GetPage(
        name: Routes.maintenanceEngeneersuggestionDetailsScreen,
        page: () => MaintenanceEngineerSuggestionDetailPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneeralertScreen,
        page: () => MaintenanceEngineerAlertsPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),

      GetPage(
        name: Routes.maintenanceEngeneersparePartsTabsShellScreen,
        page: () => MaintenanceEngineerSparePartsTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerworkOrderDetailsTabScreen,
        page: () => MaintenanceEngineerWorkOrderDetailsTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerstartWorkOrderScreen,
        page: () => MaintenanceEngineerStartWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerreassignWorkOrderScreen,
        page: () => MEReassignWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerstartWorkSubmitScreen,
        page: () => MaintenanceEngineerStartWorkSubmitPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerholdWorkOrderScreen,
        page: () => MaintenanceEngineerHoldWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerdiagnosticsScreen,
        page: () => MaintenanceEngineerDiagnosticsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneercancelWorkOrderFromDiagnosticsScreen,
        page: () => MaintenanceEngineerCancelWorkOrderPageFromDiagnostic(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerclosureScreen,
        page: () => MaintenanceEngineerClosurePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneersignOffScreen,
        page: () => MaintenanceEngineerSignOffPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerreturnSpareScreen,
        page: () => MEReturnSparesPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerrcaAnalysisScreen,
        page: () => MaintenanceEngineerRcaAnalysisPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpendingActivityScreen,
        page: () => MaintenanceEngineerPendingActivityPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerrequestSparesScreen,
        page: () => MaintenanceEngineerRequestSparesPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneersparesCartScreen,
        page: () => MaintenanceEngineerSparesCartPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerhistorytScreen,
        page: () => MaintenanceEngineerHistoryPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneertimeLineScreen,
        page: () => MaintenanceEngineerTimelinePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveMaintenanceDashboardScreen,
        page: () => MEPreventiveWorkOrderListPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveWorkOrderScreen,
        page: () => MEConfirmSlotPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpurposedNewSlotScreen,
        page: () => MaintenanceEngineerPurposedNewSlotPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveStartWorkScreen,
        page: () => MaintenanceEngineerPreventiveStartWorkPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneeraddResourceScreen,
        page: () => MaintenanceEngineerAddResourcePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerrescheduleScreen,
        page: () => MaintenanceEngineerReschedulePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerworkOrderDetailScreen,
        page: () => MaintenanceEngineerAcceptWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveDashboardScreen,
        page: () => MaintenanceEngineerPreventiveDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerlandingDashboardScreen,
        page: () => MaintenanceEngineerLandingDashboardTabShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerstaffScreen,
        page: () => MaintenanceEngineerStaffTabsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneermyDashboardScreen,
        page: () => MaintenanceEngineerMyDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralWorkOrderScreen,
        page: () => MaintenanceEngineerGeneralWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralWorkOrderDetailScreen,
        page: () => MaintenanceEngineerGeneralOrderDetailsTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralStartWorkOrderScreen,
        page: () => MaintenanceEngineerGeneralStartWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralReOpensWorkOrderScreen,
        page: () => MaintenanceEngineerGeneralReOpenWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralDiagnosticsWorkOrderScreen,
        page: () => MaintenanceEngineerGeneralDiagnosticsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralReassignStartWorkOrderScreen,
        page: () => MaintenanceEnginnerGeneralReassignWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralCancelWorkOrderScreen,
        page: () => MaintenanceEngineerGeneralCancelWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralHoldWorkOrderScreen,
        page: () => MaintenanceEngineerGeneralHoldWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralSubmitWorkOrderScreen,
        page: () => MaintenanceEngineerGeneralWorkOrderSubmitPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      // GetPage(
      //   name: Routes.generalClosureScreen,
      //   page: () => GeneralClosurePage(),
      //   binding: ScreenBindings(),
      //   transition: Transition.rightToLeft,
      // ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralSignOffScreen,
        page: () => MaintenanceEngineerGeneralSignOffPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerpendingActivityScreen,
        page: () => MaintenanceEngineerGeneralPandingActivityPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralRCAScreen,
        page: () => MaintenanceEngineerGeneralRcaAnalysisPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralRetuenSpareScreen,
        page: () => MaintenanceEngineerGeneralReturnSparePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
    ];
  }
}

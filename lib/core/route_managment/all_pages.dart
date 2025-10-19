import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/binding/screen_binding.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_dashboard_screens/general_work_order/ui/general_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_cancel_work_order/ui/general_cancel_work_order_page_from_diagnostic.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_closure/ui/general_closure_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_closure_signature/ui/general_sign_off_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_diagnostics/ui/general_diagnostics_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_hold_work_order/ui/general_hold_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_pending_activity/ui/general_panding_activity_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_rca_analysis/ui/general_rca_analysis_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_reassign_work_order/ui/general_reassign_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_reopen_work_order/ui/general_reopen_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_return_spare_parts/ui/general_return_spare_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_start_work_order/ui/general_start_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_tabs/ui/general_work_order_details_tabs_shell.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_work_order_submit/ui/general_work_order_submit_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/accept_work_order/ui/accept_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/cancel_work_order/ui/cancel_work_order_page_from_diagnostic.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/closure_signature/ui/sign_off_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/diagnostics/ui/diagnostics_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/history/ui/history_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/hold_work_order/ui/hold_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/maintenance_wotk_order_management/ui/work_order_management_list_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/ui/panding_activity_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/ui/rca_analysis_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/reassign_work_order/ui/reassign_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/request_spares/ui/request_spares_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/return_spare_parts/ui/return_spare_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/spare_cart/ui/spare_cart_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/start_work_order/ui/start_work_order_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/start_work_submit/ui/start_work_submit_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/tabs/ui/work_order_details_tabs_shell.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/timeline/ui/timeline_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/add_resource/ui/add_resource_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/confirm_wotk_order_slot/ui/confirm_work_order_slot_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/preventive_start_work/ui/preventive_start_work_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_preventive_maintenance/reschedular/ui/reschedule_page.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_spare_parts/tabs/ui/spare_parts_tabs_shell.dart';
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
        page: () => WorkOrdersManagementListPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerhomeDashboardScreen,
        page: () => HomeDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerassetsManagementDashboardScreen,
        page: () => AssetsManagementDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsDetailsScreen,
        page: () => AssetsDetailPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsSpecificationScreen,
        page: () => AssetsSpecificationPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsDashboardScreen,
        page: () => AssetsDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsPMSchedular,
        page: () => PMSchedulePage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpMCheckListScreen,
        page: () => PMChecklistPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerassetsHistoryScreen,
        page: () => AssetsHistoryPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerprofileScreen,
        page: () => ProfilePage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneersupportScreen,
        page: () => SupportPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneersuggestionScreen,
        page: () => SuggestionsPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneernewSuggestionScreen,
        page: () => NewSuggestionPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneersuggestionDetailsScreen,
        page: () => SuggestionDetailPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: Routes.maintenanceEngeneeralertScreen,
        page: () => AlertsPage(),
        binding: ScreenBindings(),
        transition: Transition.zoom,
      ),

      GetPage(
        name: Routes.maintenanceEngeneersparePartsTabsShellScreen,
        page: () => SparePartsTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerworkOrderDetailsTabScreen,
        page: () => WorkOrderDetailsTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerstartWorkOrderScreen,
        page: () => StartWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerreassignWorkOrderScreen,
        page: () => ReassignWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerstartWorkSubmitScreen,
        page: () => StartWorkSubmitPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerholdWorkOrderScreen,
        page: () => HoldWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerdiagnosticsScreen,
        page: () => DiagnosticsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneercancelWorkOrderFromDiagnosticsScreen,
        page: () => CancelWorkOrderPageFromDiagnostic(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerclosureScreen,
        page: () => ClosurePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneersignOffScreen,
        page: () => SignOffPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerreturnSpareScreen,
        page: () => ReturnSparesPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerrcaAnalysisScreen,
        page: () => RcaAnalysisPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpendingActivityScreen,
        page: () => PendingActivityPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerrequestSparesScreen,
        page: () => RequestSparesPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneersparesCartScreen,
        page: () => SparesCartPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerhistorytScreen,
        page: () => HistoryPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneertimeLineScreen,
        page: () => TimelinePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveMaintenanceDashboardScreen,
        page: () => PreventiveWorkOrderListPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveWorkOrderScreen,
        page: () => ConfirmSlotPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpurposedNewSlotScreen,
        page: () => PurposedNewSlotPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveStartWorkScreen,
        page: () => PreventiveStartWorkPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneeraddResourceScreen,
        page: () => AddResourcePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerrescheduleScreen,
        page: () => ReschedulePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerworkOrderDetailScreen,
        page: () => AcceptWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerpreventiveDashboardScreen,
        page: () => PreventiveDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerlandingDashboardScreen,
        page: () => LandingDashboardTabShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneerstaffScreen,
        page: () => StaffTabsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneermyDashboardScreen,
        page: () => MyDashboardPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralWorkOrderScreen,
        page: () => GeneralWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralWorkOrderDetailScreen,
        page: () => GeneralOrderDetailsTabsShell(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralStartWorkOrderScreen,
        page: () => GeneralStartWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralReOpensWorkOrderScreen,
        page: () => GeneralReOpenWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralDiagnosticsWorkOrderScreen,
        page: () => GeneralDiagnosticsPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralReassignStartWorkOrderScreen,
        page: () => GeneralReassignWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralCancelWorkOrderScreen,
        page: () => GeneralCancelWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneergeneralHoldWorkOrderScreen,
        page: () => GeneralHoldWorkOrderPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralSubmitWorkOrderScreen,
        page: () => GeneralWorkOrderSubmitPage(),
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
        page: () => GeneralSignOffPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),

      GetPage(
        name: Routes.maintenanceEngeneerpendingActivityScreen,
        page: () => GeneralPandingActivityPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralRCAScreen,
        page: () => GeneralRcaAnalysisPage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: Routes.maintenanceEngeneergeneralRetuenSpareScreen,
        page: () => GeneralReturnSparePage(),
        binding: ScreenBindings(),
        transition: Transition.rightToLeft,
      ),
    ];
  }
}

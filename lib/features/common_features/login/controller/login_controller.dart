import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/theme/theme_controller.dart';
import 'package:easy_ops/core/utils/app_snackbar.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/common_features/login/validator/validator.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageController extends GetxController {
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();
  final repository = Get.find<DBRepository>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // UI state
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final role = ''.obs;
  final themeController = Get.find<ThemeController>();

  @override
  void onInit() async {
    super.onInit();
    //emailController.text = 'raajvastra11@gmail.com';
    //passwordController.text = '@Raaj1234';

//Maintaince engineer
    //emailController.text = "monazarabbas07@gmail.com";
    //passwordController.text = "fB7#xEGoL0WU";

//Production supervisor
    emailController.text = "nnazarabbas07@gmail.com";
    passwordController.text = "!Z@z5tqFTpH3";
  }

  Future<void> login() async {
    if (isLoading.value) return;

    final userName = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate
    final validationMsg = Validator.validate(userName, password);
    if (validationMsg != null) {
      AppSnackbar.error(
        validationMsg,
        duration: Duration(seconds: Constant.snackbarLongDuration),
      );
      return;
    }

    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    try {
      final result = await repositoryImpl.login(
        userName: userName,
        password: password,
      );

      //final authorities = json['authorities']; // whatever came from API/JWT

      final isProdSuper =
          hasRole(result.data?.authorities, 'ROLE_PRODUCTION_SUPERVISOR') ||
              hasRole(result.data?.authorities, 'ROLEPRODUCTION_SUPERVISOR');

      debugPrint('Login HTTP code: ${result.httpCode}');

      if (result.isSuccess && result.data != null) {
        // const userRole = 'maintenance_engineer';
        //const userRole = 'production_manager';

        final organization = await repositoryImpl.organization();

        await repository
            .upsertAllOrganization(organization.data!.content); // cache locally

        final userList = await repositoryImpl.getUsersList();
        await repository.upsertAllUsers(userList.data!);
        //final details = await repository.getAllUsers();

        final loginPersonDetails =
            await repositoryImpl.loginPersonDetails(result.data!.userName);

        final operatorsDetails = await repositoryImpl.operatorsDetails();
        await repository.upsertOperators(operatorsDetails.data!);

        // final details = await operatorDetailsRepository.getAllOperator();

        await repository.upsertLoginPersonDetails(loginPersonDetails.data!);

        final person = await repository.getPersonById(loginPersonDetails.data!.id);
        debugPrint('Person contact : ${person?.managerName}   ${person?.managerContact}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            Constant.loginPersonId, loginPersonDetails.data!.id);
        // final details = await loginPersonDetailsRepository
        //     .getPersonById(loginPersonDetails.data!.id);

        final loginPerson =
            await repository.getPersonById(loginPersonDetails.data!.id);

        final plantsOrgData = await repositoryImpl.getPlantsOrg();           //getplantorg
        if(plantsOrgData.isSuccess && plantsOrgData.data != null){
          await repository.upsertPlantsOrgData(plantsOrgData.data!);
        }

        final dropDownData = await repositoryImpl.lookup();
        final workOrderCategory = await repositoryImpl.workOrderCategoryLookup();
        final shiftData = await repositoryImpl.shiftData();
        final assetsData = await repositoryImpl.assetsData();
        if (dropDownData.data != null &&
            workOrderCategory.data!=null &&
            shiftData.data != null &&
            assetsData.data != null) {

          await repository.upsertLookupData(dropDownData.data!);
          // final alllookup = repository.getLookupByType(LookupType.assetcat1);

          await repository.upsertLookupData(workOrderCategory.data!);

          await repository.upsertAssetData(assetsData.data!);

          final assets = await repository.getAllAssets();
          debugPrint('asset count in DB: ${assets.length}');
          for (final a in assets) {
            debugPrint('${a.id} - ${a.serialNumber} - ${a.name}');
          }

          await repository.upsertAllShift(shiftData.data!);

          final themeCtrl = Get.put(ThemeController(), permanent: true);
          if (isProdSuper) {
            themeCtrl.setThemeByRole('ROLEPRODUCTION_SUPERVISOR');
            await SharePreferences.put(SharePreferences.userRole,
                SharePreferences.productionManagerRole);
          } else {
            themeCtrl.setThemeByRole('ROLEMAINTENANCE_ENGINEER');
            await SharePreferences.put(
                SharePreferences.userRole, SharePreferences.engineerRole);
          }
          Get.toNamed(Routes.landingDashboardScreen);
          AppSnackbar.success(
            'Logged in successfully)',
            duration: Duration(seconds: Constant.snackbarSmallDuration),
          );
        } else {
          AppSnackbar.error(
            result.message ?? 'Login failed (HTTP ${result.httpCode})',
            duration: Duration(seconds: Constant.snackbarLongDuration),
          );
        }
      } else {
        AppSnackbar.error(
          'OOPS! something went wrong',
          duration: Duration(seconds: Constant.snackbarLongDuration),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void forgotPassword() {
    final idRaw = emailController.text.trim();
    if (idRaw.isEmpty) {
      AppSnackbar.error(
        'Please enter mobile number',
        duration: Duration(seconds: Constant.snackbarLongDuration),
      );
      return;
    }
    if (!Validator.isValidPhone(idRaw)) {
      AppSnackbar.error(
        'Please enter a valid phone number',
        duration: Duration(seconds: Constant.snackbarLongDuration),
      );
      return;
    }
    final phone = Validator.normalizePhone(idRaw);
    Get.toNamed(Routes.forgotPasswordScreen, arguments: {'phone': phone});
  }

  /* ================= Helpers ================= */

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void authenticateWithFingerprint() {}

  /// Normalize & extract authorities as a List<String>
  List<String> parseAuthorities(dynamic raw) {
    if (raw == null) return const [];

    // Case 1: already a List<String>
    if (raw is List<String>) return raw;

    // Case 2: List<dynamic> of strings or maps
    if (raw is List) {
      return raw
          .map((e) {
            if (e is String) return e;
            if (e is Map) {
              // Common keys: "authority", "role", "name"
              final v = e['authority'] ?? e['role'] ?? e['name'];
              return (v is String) ? v : null;
            }
            return null;
          })
          .whereType<String>()
          .toList();
    }

    // Fallback: single string like "ROLE_USER,ROLE_PRODUCTION_SUPERVISOR"
    if (raw is String) {
      return raw
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return const [];
  }

  /// Flexible role comparer:
  /// - case-insensitive
  /// - treats "ROLEPRODUCTION_SUPERVISOR" and "ROLE_PRODUCTION_SUPERVISOR" as equal
  bool hasRole(dynamic authoritiesRaw, String targetRole) {
    List<String> auths = parseAuthorities(authoritiesRaw);

    String norm(String s) =>
        s.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();

    final want = norm(targetRole);
    return auths.any((r) => norm(r) == want);
  }
}

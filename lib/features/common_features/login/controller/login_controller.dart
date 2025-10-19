import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/core/theme/theme_controller.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/database/db_repository/assets_repository.dart';
import 'package:easy_ops/database/db_repository/login_person_details_repository.dart';
import 'package:easy_ops/database/db_repository/lookup_repository.dart';
import 'package:easy_ops/database/db_repository/operators_details_repository.dart';
import 'package:easy_ops/database/db_repository/shift_repositoty.dart';
import 'package:easy_ops/features/common_features/login/domain/login_repository_impl.dart';
import 'package:easy_ops/core/utils/app_snackbar.dart';
import 'package:easy_ops/features/common_features/login/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageController extends GetxController {
  final LoginRepositoryImpl repositoryImpl = LoginRepositoryImpl();
  final lookupRepository = Get.find<LookupRepository>();
  final assetRepository = Get.find<AssetRepository>();
  final shiftRepository = Get.find<ShiftRepository>();
  final operatorDetailsRepository = Get.find<OperatorDetailsRepository>();
  final loginPersonDetailsRepository = Get.find<LoginPersonDetailsRepository>();
  // Inputs
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
    //db = await AppDatabase.open();
    // emailController.text = "satya.eazysaas@gmail.com";
    //passwordController.text = "r@Iv2Zi8iu?M";

    emailController.text = "raajvastra11@gmail.com";
    passwordController.text = "@Raaj1234";
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

      debugPrint('Login HTTP code: ${result.httpCode}');

      if (result.isSuccess && result.data != null) {
        final themeCtrl = Get.put(ThemeController(), permanent: true);
        const userRole = 'maintenance_engineer';
        themeCtrl.setThemeByRole(userRole);

        final loginPersonDetails =
            await repositoryImpl.loginPersonDetails(result.data!.userName);

        final operatorsDetails = await repositoryImpl.operatorsDetails();
        await operatorDetailsRepository.upsertOperators(operatorsDetails.data!);

        // final details = await operatorDetailsRepository.getAllOperator();

        await loginPersonDetailsRepository
            .upsertLoginPersonDetails(loginPersonDetails.data!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            Constant.loginPersonId, loginPersonDetails.data!.id);
        // final details = await loginPersonDetailsRepository
        //     .getPersonById(loginPersonDetails.data!.id);

        final dropDownData =
            await repositoryImpl.dropDownData(0, 20, 'sort_order,asc');
        final shiftData = await repositoryImpl.shiftData();
        final assetsData = await repositoryImpl.assetsData();
        if (dropDownData.data != null &&
            shiftData.data != null &&
            assetsData.data != null) {
          await lookupRepository.upsertLookupData(dropDownData.data!);
          await assetRepository.upsertAssetData(assetsData.data!);
          await shiftRepository.upsertAllShift(shiftData.data!);

          if (userRole == 'maintenance_engineer') {
            await SharePreferences.put(SharePreferences.userRole, 'engineer');
            Get.toNamed(Routes.maintenanceEngeneerlandingDashboardScreen);
          } else {
            await SharePreferences.put(SharePreferences.userRole, 'operator');
            Get.toNamed(Routes.landingDashboardScreen);
          }
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
}

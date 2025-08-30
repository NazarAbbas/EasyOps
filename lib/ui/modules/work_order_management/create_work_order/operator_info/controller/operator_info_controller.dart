import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/tabs/controller/work_tabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorInfoController extends GetxController {
  // Reporter
  final reporterCtrl = TextEditingController();
  final employeeId = '-'.obs;
  final phoneNumber = '-'.obs;

  // Location & shift
  final location = ''.obs;
  final plant = ''.obs;
  final reportedTime = Rxn<TimeOfDay>();
  final reportedDate = Rxn<DateTime>();
  final shift = ''.obs;

  // Options
  final locations = const ['Assets Shop', 'Assembly', 'Bay 1', 'Bay 3'];
  final plantsOpt = const ['Plant A', 'Plant B', 'Plant C'];
  final shiftsOpt = const ['A', 'B', 'C'];

  String get timeText {
    final t = reportedTime.value;
    if (t == null) return 'hh:mm';
    final h = t.hourOfPeriod.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  String get dateText {
    final d = reportedDate.value;
    if (d == null) return 'dd/mm/yyyy';
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  Future<void> pickTime(BuildContext context) async {
    final res = await showTimePicker(
      context: context,
      initialTime: reportedTime.value ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          timePickerTheme: TimePickerThemeData(
            dialHandColor: AppColors.primaryBlue,
            hourMinuteTextStyle: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            dayPeriodTextStyle: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
            helpTextStyle: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          colorScheme: Theme.of(
            ctx,
          ).colorScheme.copyWith(primary: AppColors.primaryBlue),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
          ),
        ),
        child: child!,
      ),
    );
    if (res != null) reportedTime.value = res;
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final res = await showDatePicker(
      context: context,
      initialDate: reportedDate.value ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: AppColors.primaryBlue,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.text,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
          ),
        ),
        child: child!,
      ),
    );
    if (res != null) reportedDate.value = res;
  }

  void discard() {
    reporterCtrl.clear();
    employeeId.value = '-';
    phoneNumber.value = '-';
    location.value = '';
    plant.value = '';
    reportedTime.value = null;
    reportedDate.value = null;
    shift.value = '';
    Get.snackbar(
      'Discarded',
      'All fields cleared.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryBlue,
      colorText: AppColors.white,
    );
  }

  void saveAndBack() {
    Get.snackbar(
      'Saved',
      'Operator info saved.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: AppColors.text,
    );
    Get.find<WorkTabsController>().goTo(0);
    //Get.back();
  }
}

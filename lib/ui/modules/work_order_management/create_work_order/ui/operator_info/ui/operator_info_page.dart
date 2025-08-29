import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/controller/WorkTabsController.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/controller/operator_info_controller.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/widgets/label.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/widgets/label_value.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/widgets/section_box.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/widgets/selection_card.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/ui/operator_info/widgets/tap_field.dart';
import 'package:easy_ops/ui/theme/AppInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _kHint = Color(0xFF9AA3B2);
const _kBlue = Color(0xFF2F6BFF);

class OperatorInfoPage extends GetView<OperatorInfoController> {
  const OperatorInfoPage({super.key});

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double padH = isTablet ? 18 : 14;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(padH, 10, padH, 10),
        children: [
          SectionCard(
            title: 'Reporter',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label('Reporter'),
                TextField(
                  controller: controller.reporterCtrl,
                  decoration: AppInput.bordered(
                    hintText: "Enter Reporter's Name",
                    suffixIcon: const Icon(
                      CupertinoIcons.search,
                      size: 18,
                      color: _kHint,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LabelValue(
                        label: 'Employee ID',
                        valueRx: controller.employeeId,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LabelValue(
                        label: 'Phone Number',
                        valueRx: controller.phoneNumber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Location & Shift Info',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Label(
                        'Location',
                        child: Obx(() {
                          return SelectBox<String>(
                            value: controller.location.value,
                            hint: 'Select',
                            items: controller.locations,
                            onPick: (v) => controller.location.value = v,
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Label(
                        'Plant',
                        child: Obx(() {
                          return SelectBox<String>(
                            value: controller.plant.value,
                            hint: 'Select',
                            items: controller.plants,
                            onPick: (v) => controller.plant.value = v,
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Label(
                        'Reported At',
                        child: Obx(() {
                          final t = controller.reportedTime.value;
                          final text = (t == null)
                              ? 'hh:mm'
                              : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                          return TapField(
                            text,
                            icon: const Icon(
                              CupertinoIcons.clock,
                              size: 18,
                              color: _kHint,
                            ),
                            onTap: () async {
                              const blue = AppColors.primaryBlue;

                              final res = await showTimePicker(
                                context: context,
                                initialTime:
                                    controller.reportedTime.value ??
                                    TimeOfDay.now(),
                                builder: (context, child) {
                                  final theme = Theme.of(context);
                                  return Theme(
                                    data: theme.copyWith(
                                      colorScheme: theme.colorScheme.copyWith(
                                        primary: blue,
                                        onPrimary: Colors.white,
                                        secondary: blue,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: blue,
                                        ), // OK/CANCEL
                                      ),
                                      timePickerTheme: TimePickerThemeData(
                                        // Big H:MM text
                                        hourMinuteTextStyle: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w700,
                                        ).copyWith(color: blue),

                                        // AM/PM text
                                        dayPeriodTextStyle: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ).copyWith(color: blue),

                                        // ✅ For your Flutter version (expects Color?)
                                        // If you want a light tint behind the selected AM/PM:
                                        // (If you don't want a background, just delete this line.)
                                        dayPeriodColor: blue.withOpacity(0.10),

                                        // Dial colors (optional)
                                        dialTextColor: blue,
                                        dialHandColor: blue,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (res != null) {
                                controller.reportedTime.value = res;
                              }
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Label(
                        'Reported On',
                        child: Obx(() {
                          final d = controller.reportedDate.value;
                          final text = (d == null)
                              ? 'dd/mm/yyyy'
                              : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
                          return TapField(
                            text,
                            icon: const Icon(
                              CupertinoIcons.calendar,
                              size: 18,
                              color: _kHint,
                            ),
                            onTap: () async {
                              final now = DateTime.now();
                              final res = await showDatePicker(
                                context: context,
                                initialDate: d ?? now,
                                firstDate: DateTime(now.year - 5),
                                lastDate: DateTime(now.year + 5),
                                builder: (context, child) {
                                  const blue = AppColors.primaryBlue;
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      // Works for both Material 2 & 3 pickers
                                      colorScheme: Theme.of(context).colorScheme
                                          .copyWith(
                                            primary:
                                                blue, // header, focused day, etc.
                                            onPrimary: Colors.white,
                                            secondary: blue, // buttons
                                          ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: blue,
                                        ), // action buttons
                                      ),
                                      // Optional (Material 3 specific tweaks)
                                      datePickerTheme:
                                          const DatePickerThemeData(
                                            headerBackgroundColor: blue,
                                            headerForegroundColor: Colors.white,
                                            todayBackgroundColor:
                                                WidgetStatePropertyAll(blue),
                                            todayForegroundColor:
                                                WidgetStatePropertyAll(
                                                  Colors.white,
                                                ),
                                          ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (res != null) {
                                controller.reportedDate.value = res;
                              }
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Label(
                  'Shift',
                  child: Obx(() {
                    return SelectBox<String>(
                      value: controller.shift.value,
                      hint: 'Select Shift',
                      items: controller.shifts,
                      onPick: (v) => controller.shift.value = v,
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Operator',
            child: Obx(() {
              return CheckboxListTile(
                value: controller.sameAsReporter.value,
                onChanged: (v) => controller.sameAsReporter.value = v ?? false,
                contentPadding: EdgeInsets.zero,
                title: const Text('Same as Operator'),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
          const SizedBox(height: 80), // space for bottom buttons overlay
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(padH, 10, padH, 10),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _kBlue),
                    foregroundColor: _kBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Discard',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _kBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Get.find<WorkTabsController>().goTo(2),
                  child: const Text(
                    'Save and Back',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

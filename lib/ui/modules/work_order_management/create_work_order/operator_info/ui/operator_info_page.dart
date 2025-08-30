import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/ui/modules/work_order_management/create_work_order/operator_info/controller/operator_info_controller.dart';
import 'package:easy_ops/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OperatorInfoPage extends GetView<OperatorInfoController> {
  const OperatorInfoPage({super.key});

  @override
  OperatorInfoController get controller =>
      Get.put<OperatorInfoController>(OperatorInfoController());

  bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    final double hPad = isTablet ? 20 : 14;
    final double vGap = isTablet ? 16 : 14;
    final double btnH = isTablet ? 56 : 52;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 12),
          child: Column(
            children: [
              _SectionBox(
                title: 'Reporter',
                subtitle: 'Who is raising this work order?',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label(
                      'Reporter',
                      child: TextField(
                        controller: controller.reporterCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: AppInput.bordered(
                          hintText: "Enter Reporter's Name",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 10, right: 4),
                            child: Icon(
                              CupertinoIcons.person,
                              color: AppColors.muted,
                            ),
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              CupertinoIcons.search,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: vGap - 2),
                    _Row2(
                      spacing: 12,
                      left: Obx(
                        () => _LabelValuePlain(
                          'Employee ID',
                          controller.employeeId.value,
                        ),
                      ),
                      right: Obx(
                        () => _LabelValuePlain(
                          'Phone Number',
                          controller.phoneNumber.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: vGap),

              _SectionBox(
                title: 'Location & Shift Info',
                subtitle: 'Where and when was this reported?',
                child: Obx(
                  () => Column(
                    children: [
                      _Row2(
                        spacing: 12,
                        left: _Label(
                          'Location',
                          child: _TapField(
                            text: controller.location.value.isEmpty
                                ? 'Select'
                                : controller.location.value,
                            leading: const Icon(
                              CupertinoIcons.placemark,
                              size: 18,
                              color: AppColors.muted,
                            ),
                            trailing: Icon(
                              CupertinoIcons.chevron_down,
                              color: AppColors.muted,
                            ),
                            onTap: () => _pickFromList(
                              context,
                              title: 'Select Location',
                              options: controller.locations,
                              onSelected: (v) => controller.location.value = v,
                            ),
                          ),
                        ),
                        right: _Label(
                          'Plant',
                          child: _TapField(
                            text: controller.plant.value.isEmpty
                                ? 'Select'
                                : controller.plant.value,
                            leading: const Icon(
                              CupertinoIcons.building_2_fill,
                              size: 18,
                              color: AppColors.muted,
                            ),
                            trailing: Icon(
                              CupertinoIcons.chevron_down,
                              color: AppColors.muted,
                            ),
                            onTap: () => _pickFromList(
                              context,
                              title: 'Select Plant',
                              options: controller.plantsOpt,
                              onSelected: (v) => controller.plant.value = v,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: vGap - 4),
                      _Row2(
                        spacing: 12,
                        left: _Label(
                          'Reported At',
                          child: _TapField(
                            text: controller.timeText,
                            leading: const Icon(
                              CupertinoIcons.time,
                              size: 18,
                              color: AppColors.muted,
                            ),
                            onTap: () => controller.pickTime(context),
                          ),
                        ),
                        right: _Label(
                          'Reported On',
                          child: _TapField(
                            text: controller.dateText,
                            leading: const Icon(
                              CupertinoIcons.calendar,
                              size: 18,
                              color: AppColors.muted,
                            ),
                            onTap: () => controller.pickDate(context),
                          ),
                        ),
                      ),
                      SizedBox(height: vGap - 4),
                      _Label(
                        'Shift',
                        child: _TapField(
                          text: controller.shift.value.isEmpty
                              ? 'Select Shift'
                              : 'Shift ${controller.shift.value}',
                          leading: const Icon(
                            CupertinoIcons.square_stack_3d_down_dottedline,
                            size: 18,
                            color: AppColors.muted,
                          ),
                          trailing: Icon(
                            CupertinoIcons.chevron_down,
                            color: AppColors.muted,
                          ),
                          onTap: () => _pickFromList(
                            context,
                            title: 'Select Shift',
                            options: controller.shiftsOpt,
                            onSelected: (v) => controller.shift.value = v,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: vGap),

              _SectionBox(
                title: 'Operator',
                subtitle: 'Who will execute the work?',
                child: _CheckboxLine(
                  label: 'Same as Operator',
                  value: false,
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(btnH),
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => controller.discard(),
                  child: const Text(
                    'Discard',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: Size.fromHeight(btnH),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1.5,
                  ),
                  onPressed: () => controller.saveAndBack(),
                  child: const Text(
                    'Save and Back',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// BOTTOM SHEET — bounded height & keyboard-aware (no overflow)
  Future<void> _pickFromList(
    BuildContext context, {
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // keyboard + tall sheets
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: FractionallySizedBox(
            heightFactor: 0.7, // take up to 70% of screen height
            child: _PickerContent(
              title: title,
              options: options,
              onSelected: onSelected,
            ),
          ),
        );
      },
    );
  }
}

/* ──────────────────────────────────────────────────────────────────────────
   PIECES
─────────────────────────────────────────────────────────────────────────── */

class _SectionBox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  const _SectionBox({required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12.5,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;
  final Widget child;
  const _Label(this.label, {required this.child});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
            fontSize: 15.5,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Plain value like the mock (no border)
class _LabelValuePlain extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValuePlain(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return _Label(
      label,
      child: Text(
        value,
        style: const TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TapField extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  const _TapField({
    required this.text,
    required this.onTap,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: InputDecorator(
        decoration: AppInput.bordered(
          prefixIcon: leading == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 4),
                  child: leading!,
                ),
          suffixIcon: trailing == null
              ? null
              : Padding(padding: EdgeInsets.only(right: 8), child: trailing),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                (text == 'Select' ||
                    text == 'Select Shift' ||
                    text == 'hh:mm' ||
                    text == 'dd/mm/yyyy')
                ? AppColors.muted
                : AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CheckboxLine extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  const _CheckboxLine({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
        const SizedBox(width: 6),
        // single-line, ellipsized
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Always two columns (keeps the compact, premium look even on phones).
class _Row2 extends StatelessWidget {
  final double spacing;
  final Widget left;
  final Widget right;
  const _Row2({required this.spacing, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(fit: FlexFit.tight, child: left),
        SizedBox(width: spacing),
        Flexible(fit: FlexFit.tight, child: right),
      ],
    );
  }
}

/* ─────────────  Bottom-sheet content (bounded, scrollable)  ───────────── */

class _PickerContent extends StatelessWidget {
  final String title;
  final List<String> options;
  final ValueChanged<String> onSelected;
  const _PickerContent({
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEF6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: Get.back,
                icon: const Icon(CupertinoIcons.xmark, size: 18),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: options.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFF2F5FA)),
            itemBuilder: (_, i) => ListTile(
              dense: true,
              title: Text(
                options[i],
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                onSelected(options[i]);
                Get.back();
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:easy_ops/constants/values/app_colors.dart';
import 'package:easy_ops/route_managment/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// If you already have a controller, keep using it; just ensure it exposes the
// same fields used below (issueType, impact, typeText, descriptionText, etc.)
class WorkorderInfoController extends GetxController {
  // dropdown values
  final issueType = ''.obs;
  final impact = ''.obs;

  // inputs
  final assetsCtrl = TextEditingController();
  final problemCtrl = TextEditingController();

  // static/derived values for the tiles
  final typeText = '-'.obs;
  final descriptionText = '-'.obs;

  // sample options
  final issueTypes = ['Electrical', 'Mechanical', 'Instrumentation'];
  final impacts = ['Low', 'Medium', 'High'];

  // Overflow-safe picker (bounded height)
  Future<void> pickFromList({
    required BuildContext context,
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final maxH = MediaQuery.of(ctx).size.height * 0.60;
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFF2F5FA)),
                    itemBuilder: (_, i) => ListTile(
                      dense: true,
                      title: Text(
                        items[i],
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        onSelected(items[i]);
                        Get.back();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goToWorkOrderDetailScreen() {
    Get.snackbar(
      'Create',
      'Work order created',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryBlue,
      colorText: AppColors.white,
    );
    Get.toNamed(Routes.workOrderDetailScreen);
    //Get.back();
  }
}

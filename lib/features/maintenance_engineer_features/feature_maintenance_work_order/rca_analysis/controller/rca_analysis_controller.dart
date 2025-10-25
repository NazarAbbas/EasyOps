import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/core/utils/utils.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_rca_analysis/controller/general_rca_analysis_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/WorkTabsController.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/rca_analysis/models/rca_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceEnginnerRcaAnalysisController extends GetxController {
  // UI state
  final isSaving = false.obs;
  final fiveWhyOpen = true.obs;

  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();

  // Pass the WO id in constructor / Get.arguments if needed
  //final String workOrderId;
  // MaintenanceEnginnerRcaAnalysisController({
  //   this.workOrderId = 'WO-02Oct2025071055551008',
  // });

  // Form controllers — initialize ONCE at declaration
  final TextEditingController problemCtrl = TextEditingController();
  final List<TextEditingController> whyCtrls =
      List<TextEditingController>.generate(5, (_) => TextEditingController());
  final TextEditingController rootCauseCtrl = TextEditingController();
  final TextEditingController correctiveCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();
  WorkOrders? workOrderInfo;

  // Nothing to init now
  @override
  void onInit() async {
    super.onInit();

    // final workTabsController =
    //     Get.find<MaintenanceEngineerWorkTabsController>();
    // if (workTabsController.workOrder == null) {
    //   workOrderInfo = getWorkOrderFromArgs(Get.arguments);
    // } else {
    //   workOrderInfo = workTabsController.workOrder;
    // }
    final loaded = await SharePreferences.getObject(
        Constant.workOrder, WorkOrders.fromJson);
    workOrderInfo = loaded;
  }

  @override
  void onClose() {
    problemCtrl.dispose();
    for (final c in whyCtrls) {
      c.dispose();
    }
    rootCauseCtrl.dispose();
    correctiveCtrl.dispose();
    super.onClose();
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSaving.value = true;
    try {
      final req = RcaRequest(
        workOrderId: workOrderInfo!.id,
        problem: problemCtrl.text.trim(),
        why1: whyCtrls[0].text.trim(),
        why2: whyCtrls[1].text.trim(),
        why3: whyCtrls[2].text.trim(),
        why4: whyCtrls[3].text.trim(),
        why5: whyCtrls[4].text.trim(),
        rca: rootCauseCtrl.text.trim(),
        cap: correctiveCtrl.text.trim(),
      );

      final result = await repositoryImpl.createRca(req);
      final code = result.httpCode ?? 0;
      if (code == 200) {
        final result = RcaResult(
          problemIdentified: problemCtrl.text.trim(),
          fiveWhys: whyCtrls.map((e) => e.text.trim()).toList(growable: false),
          rootCause: rootCauseCtrl.text.trim(),
          correctiveAction: correctiveCtrl.text.trim(),
        );
        Get.back(result: result);
      }

      Get.snackbar(
        'Failed',
        (result.message?.trim().isNotEmpty ?? false)
            ? result.message!.trim()
            : 'Unexpected response (code $code).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(12),
      );
    } finally {
      isSaving.value = false;
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RcaResult {
//   final String problemIdentified;
//   final List<String> fiveWhys; // length = 5
//   final String rootCause;
//   final String correctiveAction;

//   const RcaResult({
//     required this.problemIdentified,
//     required this.fiveWhys,
//     required this.rootCause,
//     required this.correctiveAction,
//   });
// }

// class MaintenanceEnginnerRcaAnalysisController extends GetxController {
//   // UI state
//   final isSaving = false.obs;
//   final fiveWhyOpen = true.obs;

//   // Form controllers
//   late final TextEditingController problemCtrl;
//   late final List<TextEditingController> whyCtrls; // 5 items
//   late final TextEditingController rootCauseCtrl;
//   late final TextEditingController correctiveCtrl;

//   final formKey = GlobalKey<FormState>();

//   @override
//   void onInit() {
//     problemCtrl = TextEditingController();
//     whyCtrls = List.generate(5, (_) => TextEditingController());
//     rootCauseCtrl = TextEditingController();
//     correctiveCtrl = TextEditingController();
//     super.onInit();
//     final arg = Get.arguments;
//     if (arg is RcaResult) {
//       // Prefill with incoming data
//       problemCtrl.text = arg.problemIdentified;
//       rootCauseCtrl.text = arg.rootCause;
//       correctiveCtrl.text = arg.correctiveAction;
//       whyCtrls[0].text = arg.fiveWhys[0];
//       whyCtrls[1].text = arg.fiveWhys[1];
//       whyCtrls[2].text = arg.fiveWhys[2];
//       whyCtrls[3].text = arg.fiveWhys[3];
//       whyCtrls[4].text = arg.fiveWhys[4];
//     }
//   }

//   // void saveAndBack() {
//   //   final model = RcaFormData(
//   //     problemIdentified: problemCtrl.text.trim(),
//   //     rootCause: rootCauseCtrl.text.trim(),
//   //     correctiveAction: correctiveCtrl.text.trim(),
//   //   );
//   //   Get.back(result: model); // <-- return TYPED model
//   // }

//   // @override
//   // void onInit() {
//   //   // (Optional demo defaults)
//   //   // problemCtrl.text = 'Vehicle will not start';
//   //   // whyCtrls[0].text = 'The Battery is dead';
//   //   // whyCtrls[1].text = 'The alternator is not functioning';
//   //   // whyCtrls[2].text = 'The alternator belt has broken';
//   //   // whyCtrls[3].text =
//   //   //     'The alternator belt was well beyond its useful service life and replaced.';
//   //   // whyCtrls[4].text =
//   //   //     'The vehicle was not maintained according to the recommended service schedule.';
//   //   // rootCauseCtrl.text = 'Service Scheduled not followed';
//   //   // correctiveCtrl.text =
//   //   //     'Ensure 100% schedule adherence of preventive maintenance';
//   //   super.onInit();
//   // }

//   @override
//   void onClose() {
//     problemCtrl.dispose();
//     for (final c in whyCtrls) c.dispose();
//     rootCauseCtrl.dispose();
//     correctiveCtrl.dispose();
//     super.onClose();
//   }

//   Future<void> save() async {
//     if (!(formKey.currentState?.validate() ?? false)) return;

//     isSaving.value = true;
//     await Future.delayed(const Duration(milliseconds: 800)); // fake API
//     isSaving.value = false;

//     final result = RcaResult(
//       problemIdentified: problemCtrl.text.trim(),
//       fiveWhys: whyCtrls.map((e) => e.text.trim()).toList(growable: false),
//       rootCause: rootCauseCtrl.text.trim(),
//       correctiveAction: correctiveCtrl.text.trim(),
//     );

//     Get.back(result: result);
//   }
// }

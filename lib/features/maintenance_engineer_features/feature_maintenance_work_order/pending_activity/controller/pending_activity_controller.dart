import 'dart:async';
import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/utils/share_preference.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/common_features/login/models/user_response.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_closure/controller/general_closure_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_general_work_order/general_pending_activity/controller/general_pending_activity_controller.dart';
import 'package:easy_ops/features/maintenance_engineer_features/feature_maintenance_work_order/pending_activity/models/pending_activity_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/work_order_management_dashboard/models/work_order_list_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceEnginnerPendingActivityController extends GetxController {
  // ---- Local UI list
  final RxList<ActivityItem> activities = <ActivityItem>[].obs;

  // ---- Repos
  final NetworkRepositoryImpl repositoryImpl = NetworkRepositoryImpl();
  final DBRepository repository = Get.find<DBRepository>();

  // ---- Lookups (activity type)
  final RxList<LookupValues> reason = <LookupValues>[].obs;
  final Rxn<LookupValues> selectedReason = Rxn<LookupValues>();
  final selectedReasonValue = 'Select Reason'.obs;
  bool _isPlaceholder(LookupValues? v) =>
      v == null || (v.id.isEmpty && v.displayName == 'Select activity type');

  // ---- Users (from Floor)
  final RxList<UserSummary> userSummary = <UserSummary>[].obs;
  final Rxn<UserSummary> selectedAssignee = Rxn<UserSummary>();

  // ---- Form fields
  final titleCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  final Rx<PendingActivityType> selectedType =
      PendingActivityType.pmShutdownWeekend.obs;
  final Rx<DateTime?> targetDate = Rx<DateTime?>(null);

  // ---- UI state
  final RxBool isSubmitting = false.obs;
  final RxnInt editingIndex = RxnInt();

  WorkOrders? workOrdersInfo;

  // Helper: Full name for display
  String _fullName(UserSummary u) => [u.firstName, u.lastName]
      .where((s) => s.trim().isNotEmpty)
      .join(' ')
      .trim();

  // Helper: find user by display name (used when editing an existing row)
  UserSummary? _findUserByName(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final n = name.trim().toLowerCase();
    for (final u in userSummary) {
      final fn = _fullName(u).toLowerCase();
      if (fn == n) return u;
    }
    return null;
  }

  @override
  void onInit() async {
    super.onInit();

    // Load incoming activities (if any)
    final args = Get.arguments;
    if (args is PendingActivityArgs) {
      activities.assignAll(List<ActivityItem>.from(args.initial));
    }

    // Active work order
    workOrdersInfo = await SharePreferences.getObject(
      Constant.workOrder,
      WorkOrders.fromJson,
    );

    // Lookups for activity type
    final List<LookupValues> activityTypeList =
        await repository.getLookupByType(LookupType.activityType);

    final placeholder = LookupValues(
      id: '',
      code: '',
      displayName: 'Select activity type',
      description: '',
      lookupType: LookupType.department.name,
      sortOrder: -1,
      recordStatus: 1,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      tenantId: '',
      clientId: '',
    );
    reason.assignAll([placeholder, ...activityTypeList]);
    selectedReason.value = placeholder;

    // Users from Floor
    final usersList = await repository.getAllUsers();

    // Placeholder for users dropdown
    final userPlaceholder = UserSummary(
      id: '',
      email: '',
      communicationEmail: '',
      passwordHash: '',
      firstName: 'Select',
      lastName: 'assignee',
      phone: '',
      userType: UserType.unknown,
      recordStatus: 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
      tenantId: '',
      tenantName: '',
      clientId: '',
      clientName: '',
      orgId: '',
      orgName: '',
    );

    userSummary.assignAll([userPlaceholder, ...usersList]);
    selectedAssignee.value = userPlaceholder;
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    noteCtrl.dispose();
    super.onClose();
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: targetDate.value ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) targetDate.value = picked;
  }

  String _newId() => 'AC-${300 + activities.length + 1}';
  bool get isEditing => editingIndex.value != null;

  void beginEdit(int index) {
    final a = activities[index];
    editingIndex.value = index;

    titleCtrl.text = a.title;
    noteCtrl.text = a.note ?? '';
    selectedType.value = a.type;
    targetDate.value = a.targetDate;

    // try to find matching user in the loaded list
    selectedAssignee.value = _findUserByName(a.assignee) ?? userSummary.first;
  }

  void cancelEdit() {
    editingIndex.value = null;
    _resetForm();
  }

  // ===== Helpers: UI -> API =====

  String _typeIdFor(PendingActivityType t) {
    switch (t) {
      case PendingActivityType.pmShutdownWeekend:
        return 'CLU-PM-SHUTDOWN-WEEKEND';
      case PendingActivityType.breakdown:
        return 'CLU-BREAKDOWN';
      case PendingActivityType.inspection:
        return 'CLU-INSPECTION';
    }
  }

  String _yyyyMmDd(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  /// Build payload for API from current `activities`
  List<PendingActivityRequest> _buildRequests() {
    final woId = workOrdersInfo?.id ?? '';
    if (woId.isEmpty) {
      throw StateError('Work order not loaded.');
    }

    final list = <PendingActivityRequest>[];
    for (var i = 0; i < activities.length; i++) {
      final a = activities[i];

      // Resolve assignedToId from the name stored in ActivityItem.assignee
      final matchedUser = _findUserByName(a.assignee);
      final assignedToId = (matchedUser == null || matchedUser.id.isEmpty)
          ? 'UNASSIGNED'
          : matchedUser.id;

      list.add(PendingActivityRequest(
        sequence: i + 1,
        workOrderId: woId,
        title: a.title,
        typeId: _typeIdFor(a.type),
        requestedTargetDate: _yyyyMmDd(a.targetDate ?? DateTime.now()),
        remark: (a.note ?? '').trim(),
        status: a.status.isEmpty ? 'Pending' : a.status,
        assignedToId: assignedToId,
      ));
    }
    return list;
  }

  /// Add / Update locally
  Future<void> submit() async {
    final title = titleCtrl.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Missing Title', 'Please enter Activity Title',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Determine selected assignee name (for local UI list)
    final assigneeUser = selectedAssignee.value;
    final assigneeName = (assigneeUser == null || assigneeUser.id.isEmpty)
        ? null
        : _fullName(assigneeUser);

    isSubmitting.value = true;
    try {
      if (isEditing) {
        final idx = editingIndex.value!;
        final updated = activities[idx].copyWith(
          title: title,
          type: selectedType.value,
          assignee: assigneeName, // store display name locally
          targetDate: targetDate.value,
          note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
          status: 'Pending',
        );
        activities[idx] = updated;
        activities.removeAt(idx);
        activities.insert(0, updated);
        cancelEdit();
        Get.snackbar('Updated', 'Activity updated',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        activities.insert(
          0,
          ActivityItem(
            id: _newId(),
            title: title,
            type: selectedType.value,
            assignee: assigneeName, // store display name locally
            targetDate: targetDate.value,
            note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
            status: 'Pending',
          ),
        );
        _resetForm();
        Get.snackbar('Added', 'Activity added',
            snackPosition: SnackPosition.BOTTOM);
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Save to API (bulk) & go back with typed result
  Future<void> saveAndBack() async {
    isSubmitting.value = true;
    try {
      final pendingActivityList = _buildRequests();
      final res =
          await repositoryImpl.createActivitiesBulk(pendingActivityList);
      final code = res.httpCode ?? 0;

      if (code == 200 || code == 201 || code == 204) {
        final result = PendingActivityResult(
          action: PendingActivityAction.back,
          activities: List<ActivityItem>.from(activities),
        );
        Get.back(result: result);
      } else {
        Get.snackbar(
          'Failed',
          (res.message?.trim().isNotEmpty ?? false)
              ? res.message!.trim()
              : 'Unexpected response (code $code).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.black87,
          margin: const EdgeInsets.all(12),
        );
      }
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
      isSubmitting.value = false;
    }
  }

  void deleteAt(int index) {
    activities.removeAt(index);
    if (editingIndex.value == index) cancelEdit();
    Get.snackbar('Deleted', 'Activity removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  void _resetForm() {
    titleCtrl.clear();
    noteCtrl.clear();
    selectedType.value = PendingActivityType.pmShutdownWeekend;
    targetDate.value = null;

    // reset assignee to placeholder
    if (userSummary.isNotEmpty) {
      selectedAssignee.value = userSummary.first;
    } else {
      selectedAssignee.value = null;
    }
  }
}

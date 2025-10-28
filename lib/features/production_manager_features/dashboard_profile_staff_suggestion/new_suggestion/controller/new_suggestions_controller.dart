import 'package:easy_ops/core/network/network_repository/network_repository.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/domain/new_suggestion_repository_impl.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/new_suggestion/models/new_suggestion_request.dart';
import 'package:easy_ops/features/production_manager_features/work_order_management/create_work_order/models/lookup_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// =================== CONTROLLER ===================

class NewSuggestionController extends GetxController {
  final NetworkRepositoryImpl suggestionRepositoryImpl =
      NetworkRepositoryImpl();
  //final LookupRepository lookupRepository = Get.find<LookupRepository>();
  final repository = Get.find<DBRepository>();
  final RxList<LookupValues> locationTypeOptions = <LookupValues>[].obs;
  final RxList<LookupValues> suggestionTypeOptions = <LookupValues>[].obs;

  final RxList<String> locationOptions = <String>[].obs; // DEPARTMENT names
  final RxList<String> suggestionOptions = <String>[].obs; // PLANT names

  // Shorthand getters for UI
  List<String> get locations => locationOptions;
  List<String> get suggestionOpt => suggestionOptions;

  // Filtered (exclude placeholder)
  List<String> get locationsForPicker =>
      locationOptions.where((e) => e != _placeholder).toList();
  List<String> get suggestionForPicker =>
      suggestionOptions.where((e) => e != _placeholder).toList();

  final Map<String, String> _suggestionNameToId = {};
  final Map<String, String> _deptNameToId = {};

  // Display names currently selected in UI
  RxString suggestion = '-'.obs; // PLANT name
  RxString location = '-'.obs; // DEPARTMENT name
  final RxString suggestionId = ''.obs;
  final RxString locationId = ''.obs; // department id

  static const String _placeholder = 'Select';

  // Collapsible card
  final reporterExpanded = true.obs;

  // Reporter data (normally from auth/profile)
  final reporterName = 'Raj Kumar'.obs;
  final employeeCode = 'AS4512'.obs;
  final role = 'Worker'.obs;
  final reporterDept = 'Assets Shop'.obs;

  // Form state
  final formKey = GlobalKey<FormState>();
  final department = RxnString('Banbury Department');
  final type = RxnString('Cost Saving');

  final titleC = TextEditingController();
  final descriptionC = TextEditingController();
  final justificationC = TextEditingController();
  final amountC = TextEditingController();
  bool _isPlaceholder(String v) => v.trim().isEmpty || v.trim() == _placeholder;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAsync();
  }

  void _initAsync() async {
    final List<LookupValues> deptList =
        await repository.getLookupByType(LookupType.department);

    final List<LookupValues> suggestionList =
        await repository.getLookupByType(LookupType.suggestion);

    // Build typed option lists (with placeholders)
    locationTypeOptions.assignAll([
      LookupValues(
        id: '',
        code: '',
        displayName: 'Select location',
        description: '',
        lookupType: LookupType.department.name,
        sortOrder: -1,
        recordStatus: 1,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        tenantId: '',
        clientId: '',
      ),
      ...deptList,
    ]);

    suggestionTypeOptions.assignAll([
      LookupValues(
        id: '',
        code: '',
        displayName: 'Select suggestion',
        description: '',
        lookupType: LookupType.suggestion.name,
        sortOrder: -1,
        recordStatus: 1,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
        tenantId: '',
        clientId: '',
      ),
      ...suggestionList,
    ]);

    // Names lists for simpler dropdowns
    locationOptions
      ..clear()
      ..addAll([_placeholder, ...deptList.map((e) => e.displayName)]);

    suggestionOptions
      ..clear()
      ..addAll([_placeholder, ...suggestionList.map((e) => e.displayName)]);
    // Build name → id maps
    _suggestionNameToId
      ..clear()
      ..addEntries(suggestionList.map((e) => MapEntry(e.displayName, e.id)));

    _deptNameToId
      ..clear()
      ..addEntries(deptList.map((e) => MapEntry(e.displayName, e.id)));
  }

  void onSuggestionChanged(String name) {
    suggestion.value = name;
    suggestionId.value = _suggestionNameToId[name] ?? '';
  }

  void onLocationChanged(String name) {
    location.value = name;
    locationId.value = _deptNameToId[name] ?? '';
  }

  @override
  void onClose() {
    titleC.dispose();
    descriptionC.dispose();
    justificationC.dispose();
    amountC.dispose();
    super.onClose();
  }

  void toggleReporter() => reporterExpanded.toggle();

  String? _req(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? validateTitle(String? v) => _req(v);
  String? validateDesc(String? v) => _req(v);
  String? validateJust(String? v) => _req(v);
  String? validateAmount(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  void submit() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      if (validateAllFields()) {
        // All fields valid → proceed to API or navigation

        final newSuggestionRequest = NewSuggestionRequest(
          plantId: locationId.value,
          suggestionTypeId: suggestionId.value,
          name: titleC.text.toString(),
          description: descriptionC.text.toString(),
          status: 'Open',
          impactEstimate: amountC.text.toString(),
          comment: justificationC.text.toString(),
        );

        final newSuggestionResponse = await suggestionRepositoryImpl
            .addNewSuggestion(newSuggestionRequest: newSuggestionRequest);

        if (newSuggestionResponse.httpCode == 200) {
          Get.snackbar(
            'Validated',
            'All fields are valid ✅',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
          );

          // Example: Navigate to details page
          Get.toNamed(Routes.suggestionDetailsScreen);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Master Validation Function
  bool validateAllFields() {
    final errors = <String>[];
    if (_isPlaceholder(location.value) || locationId.value.isEmpty) {
      errors.add('Department');
    }
    if (_isPlaceholder(suggestion.value) || suggestionId.value.isEmpty) {
      errors.add('Type');
    }

    // 1. Text fields
    if (titleC.text.trim().isEmpty) errors.add('Title');
    if (descriptionC.text.trim().isEmpty) errors.add('Description');
    if (justificationC.text.trim().isEmpty) errors.add('Justification');
    if (amountC.text.trim().isEmpty) errors.add('Impact Amount');

    // 2. Department / Location
    if (_isPlaceholder(location.value)) errors.add('Department');

    // 3. Plant / Type
    if (_isPlaceholder(suggestion.value)) errors.add('Type / Suggestion');

    // Show error if any
    if (errors.isNotEmpty) {
      Get.snackbar(
        'Missing / Invalid Fields',
        'Please fill: ${errors.join(', ')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
      );
      return false;
    }
    return true;
  }
}

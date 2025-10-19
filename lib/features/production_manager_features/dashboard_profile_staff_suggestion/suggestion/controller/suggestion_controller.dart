import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/suggestion/models/suggestions_response.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SuggestionsController extends GetxController {
  /// Observable list of suggestions
  final RxList<Suggestion> itemList = <Suggestion>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load mock or API data
    loopAllSuggestions();
  }

  /// Load all suggestions (mock for now)
  void loopAllSuggestions() {
    // Instead of loop+add, we can directly assign the list
    itemList.assignAll(items.content);
  }

  /// expanded state per suggestion id
  final expanded = <String, bool>{}.obs;

  bool isOpen(String id) => expanded[id] ?? false;

  void toggleOpen(String id) {
    expanded[id] = !(expanded[id] ?? false);
    expanded.refresh();
  }

  /// Navigate or handle suggestion tap
  void openSuggestion(Suggestion s) {
    // Example: Navigate to a detail screen
    // Get.to(() => SuggestionDetailPage(), arguments: s);
  }

  /// Call reporter — right now your Suggestion model doesn't have a reporterPhone.
  /// You can pass a raw phone number directly if you later add that field.
  Future<void> callReporter(String raw) async {
    if (raw.isEmpty) return;
    final num = raw.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: num);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      // Optionally show snackbar here
    }
  }

  /// Navigate to "Add New Suggestion" screen
  void addNew() {
    Get.toNamed(Routes.newSuggestionScreen);
  }
}

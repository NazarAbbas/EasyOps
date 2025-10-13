import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/database/db_repository/login_person_details_repository.dart';
import 'package:easy_ops/features/dashboard_profile_staff_suggestion/profile/domain/profile_repository_impl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfile {
  final String avatarUrl;
  final String name;
  final String employeeCode; // e.g. "20164"
  final int age;
  final String bloodGroup;
  final String phone;
  final String email;
  final String department;
  final String supervisorName;
  final String supervisorPhone;
  final String location;

  final String emergencyName;
  final String emergencyPhone;
  final String emergencyEmail;
  final String emergencyRelationship;

  final int emergencyContactsCount;
  final int holidaysCount;

  const UserProfile({
    required this.avatarUrl, // <-- fixed
    required this.name,
    required this.employeeCode,
    required this.age,
    required this.bloodGroup,
    required this.phone,
    required this.email,
    required this.department,
    required this.supervisorName,
    required this.supervisorPhone,
    required this.location,
    required this.emergencyName,
    required this.emergencyPhone,
    required this.emergencyEmail,
    required this.emergencyRelationship,
    required this.emergencyContactsCount,
    required this.holidaysCount,
  });

  String get displayName => '$name ($employeeCode)';
}

class ProfileController extends GetxController {
  final loginPersonDetailsRepository = Get.find<LoginPersonDetailsRepository>();
  final ProfileRepositoryImpl profileRepositoryImpl = ProfileRepositoryImpl();

  final emergencyExpanded = false.obs;
  final holidayExpanded = false.obs;

  final Rxn<UserProfile> profile = Rxn<UserProfile>();

  @override
  void onInit() {
    super.onInit();
    _loadProfile(); // keep async work outside onInit signature
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginPersonId = prefs.getString(Constant.loginPersonId);

      if (loginPersonId == null || loginPersonId.isEmpty) {
        Get.snackbar('Profile', 'No logged-in user found.');
        return;
      }

      final details =
          await loginPersonDetailsRepository.getPersonById(loginPersonId);
      if (details == null) {
        Get.snackbar('Profile', 'Could not load user details.');
        return;
      }

      // Safe reads with fallbacks
      final contact0 =
          (details.contacts.isNotEmpty) ? details.contacts.first : null;

      profile.value = UserProfile(
        avatarUrl: 'https://i.pravatar.cc/256?img=12',
        name: details.name ?? '—',
        employeeCode: details.id ?? '—',
        age: 21, // (details.age is int) ? details.age as int : 0,
        bloodGroup: details.bloodGroup ?? '—',
        phone: contact0?.phone ?? '—',
        email: contact0?.email ?? '—',
        department: details.departmentName ?? '—',
        supervisorName: 'Ram Sharma',
        supervisorPhone: '+91 9876543210',
        location: 'Branburry',
        emergencyName: 'Rakesh Kumar',
        emergencyPhone: '+91 9875466484',
        emergencyEmail: 'sanjaykumar222@abc.com',
        emergencyRelationship: 'Brother',
        emergencyContactsCount: 5,
        holidaysCount: 17,
      );
    } catch (e) {
      Get.snackbar('Profile', 'Failed to load profile: $e');
    }
  }

  void onEditAvatar() {
    // TODO: navigate to image picker / avatar edit
  }

  Future<void> logout() async {
    final result = await profileRepositoryImpl.logout();
    if (result.httpCode == 200 && result.message == 'Success') {
      Get.offAllNamed(Routes.loginScreen);
    } else {
      Get.snackbar('Logout', 'Failed to logout. Please try again.');
    }
  }

  Future<void> callNumber(String rawNumber) async {
    final sanitized = rawNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: sanitized);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar('Call', 'Could not open dialer for $rawNumber');
    }
  }

  Future<void> sendEmail(
    String address, {
    String? subject,
    String? body,
  }) async {
    final qp = <String, String>{};
    if (subject != null && subject.isNotEmpty) qp['subject'] = subject;
    if (body != null && body.isNotEmpty) qp['body'] = body;

    final uri = Uri(
        scheme: 'mailto',
        path: address,
        queryParameters: qp.isEmpty ? null : qp);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar('Email', 'Could not open email app for $address');
    }
  }
}

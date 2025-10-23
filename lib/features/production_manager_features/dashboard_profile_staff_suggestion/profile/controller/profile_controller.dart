import 'package:easy_ops/core/constants/constant.dart';
import 'package:easy_ops/core/network/network_repository/nework_repository_impl.dart';
import 'package:easy_ops/core/route_managment/routes.dart';
import 'package:easy_ops/database/db_repository/db_repository.dart';
import 'package:easy_ops/features/production_manager_features/dashboard_profile_staff_suggestion/profile/domain/profile_repository_impl.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// domain models
import 'package:easy_ops/features/common_features/login/models/login_person_details.dart'
    show LoginPersonDetails, LoginPersonContact, OrganizationHoliday;

class UserProfile {
  final String avatarUrl;
  final String name;
  final String employeeCode;
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
    required this.avatarUrl,
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
  // final loginPersonDetailsRepository = Get.find<LoginPersonDetailsRepository>();
  final NetworkRepositoryImpl profileRepositoryImpl = NetworkRepositoryImpl();
  final repository = Get.find<DBRepository>();

  final emergencyExpanded = false.obs;
  final holidayExpanded = false.obs;

  final Rxn<UserProfile> profile = Rxn<UserProfile>();

  /// lists from DB
  final RxList<LoginPersonContact> contactList = <LoginPersonContact>[].obs;
  final RxList<OrganizationHoliday> holidayList = <OrganizationHoliday>[].obs;

  /// -------- derived holiday helpers ----------
  /// sorted ascending by date (date-only)
  List<OrganizationHoliday> get sortedHolidays {
    final list = [...holidayList];
    list.sort((a, b) {
      final ad = _dateOnly(a.holidayDate)?.millisecondsSinceEpoch ?? 0;
      final bd = _dateOnly(b.holidayDate)?.millisecondsSinceEpoch ?? 0;
      return ad.compareTo(bd);
    });
    return list;
  }

  /// map of YYYY-MM -> [holidays]
  Map<String, List<OrganizationHoliday>> get holidaysByMonth {
    final map = <String, List<OrganizationHoliday>>{};
    for (final h in sortedHolidays) {
      final d = _dateOnly(h.holidayDate);
      if (d == null) continue;
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
      (map[key] ??= []).add(h);
    }
    return map;
  }

  /// first holiday that is today or after today
  OrganizationHoliday? get nextUpcomingHoliday {
    final today = _dateOnly(DateTime.now())!;
    for (final h in sortedHolidays) {
      final d = _dateOnly(h.holidayDate);
      if (d == null) continue;
      if (!d.isBefore(today)) return h;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginPersonId = prefs.getString(Constant.loginPersonId);

      if (loginPersonId == null || loginPersonId.isEmpty) {
        Get.snackbar('Profile', 'No logged-in user found.');
        return;
      }

      final details = await repository.getPersonById(loginPersonId);
      if (details == null) {
        Get.snackbar('Profile', 'Could not load user details.');
        return;
      }

      contactList.assignAll(details.contacts);
      holidayList.assignAll(details.organizationHolidays);

      final primaryContact = contactList.isNotEmpty ? contactList.first : null;
      final phone = details.userPhone ?? primaryContact?.phone ?? '—';
      final email = details.userEmail ?? primaryContact?.email ?? '—';

      profile.value = UserProfile(
        avatarUrl: 'https://i.pravatar.cc/256?img=12',
        name: details.name ?? '—',
        employeeCode: details.id ?? '—',
        age: 21,
        bloodGroup: details.bloodGroup ?? '—',
        phone: phone,
        email: email,
        department: details.departmentName ?? '—',
        supervisorName: details.managerName ?? '-',
        supervisorPhone: details.managerContact ?? 'Not Available',
        location: details.organizationName ?? '—',
        emergencyName: primaryContact?.name ?? '—',
        emergencyPhone: primaryContact?.phone ?? '—',
        emergencyEmail: primaryContact?.email ?? '—',
        emergencyRelationship: primaryContact?.relationship ?? '—',
        emergencyContactsCount: contactList.length,
        holidaysCount: holidayList.length,
      );
    } catch (e) {
      Get.snackbar('Profile', 'Failed to load profile: $e');
    }
  }

  DateTime? _dateOnly(DateTime? d) =>
      d == null ? null : DateTime(d.year, d.month, d.day);

  // ----- actions -----
  void onEditAvatar() {}
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
    if (sanitized.isEmpty) {
      Get.snackbar('Call', 'No phone number available');
      return;
    }
    final uri = Uri(scheme: 'tel', path: sanitized);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      Get.snackbar('Call', 'Could not open dialer for $rawNumber');
    }
  }

  Future<void> sendEmail(String address,
      {String? subject, String? body}) async {
    if (address.trim().isEmpty || !address.contains('@')) {
      Get.snackbar('Email', 'Invalid email address');
      return;
    }
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

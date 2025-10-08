import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum DocType { pdf, video }

class SupportDoc {
  final String title;
  final int pages;
  final DocType type;
  final String? url; // http(s) to open
  const SupportDoc({
    required this.title,
    required this.pages,
    required this.type,
    this.url,
  });
}

class SupportController extends GetxController {
  // ===== Reactive fields =====
  final softwareVersion = ''.obs;
  final deviceModel = ''.obs;
  final osVersion = ''.obs;
  final connectivity = ''.obs;
  final lastSync = DateTime.now().obs;

  // ===== Internal helpers =====
  final _deviceInfo = DeviceInfoPlugin();

  // ===== Contact =====
  final supportEmail = 'support@easy-ops.example';
  final supportPhone = '+91 9876543210';

  // ===== Support materials =====
  final docs = <SupportDoc>[
    SupportDoc(
      title: 'How to create Breakdown Work Order',
      pages: 122,
      type: DocType.pdf,
      url: 'https://www.africau.edu/images/default/sample.pdf',
    ),
    SupportDoc(
      title: 'Safety & Privacy',
      pages: 22,
      type: DocType.pdf,
      url:
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    ),
    SupportDoc(
      title: 'How to return unused inventory',
      pages: 22,
      type: DocType.video,
      url: 'https://youtu.be/dQw4w9WgXcQ', // sample
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchStaticDeviceInfo();
    _checkConnectivity();
    _listenConnectivityChanges();
  }

  // ===== Device & Software Info =====
  Future<void> _fetchStaticDeviceInfo() async {
    try {
      // 1. App version
      final pkgInfo = await PackageInfo.fromPlatform();
      softwareVersion.value = pkgInfo.version;
    } catch (e, st) {
      softwareVersion.value = 'Unknown';
      debugPrint('Error getting PackageInfo: $e\n$st');
    }

    try {
      // 2. Device model & OS version
      if (Platform.isAndroid) {
        final android = await _deviceInfo.androidInfo;
        deviceModel.value = '${android.manufacturer} ${android.model}';
        osVersion.value = 'Android ${android.version.release}';
      } else if (Platform.isIOS) {
        final ios = await _deviceInfo.iosInfo;
        deviceModel.value = ios.utsname.machine ?? 'iPhone';
        osVersion.value = '${ios.systemName} ${ios.systemVersion}';
      } else {
        deviceModel.value = 'Unknown Device';
        osVersion.value = 'Unknown OS';
      }
    } catch (e, st) {
      deviceModel.value = 'Unknown Device';
      osVersion.value = 'Unknown OS';
      debugPrint('Error getting DeviceInfo: $e\n$st');
    }
  }

// ===== Connectivity =====
  Future<void> _checkConnectivity() async {
    final results = await Connectivity()
        .checkConnectivity(); // returns List<ConnectivityResult>
    connectivity.value = _mapConnectivityList(results);
  }

  void _listenConnectivityChanges() {
    Connectivity().onConnectivityChanged.listen((results) {
      // 'results' is List<ConnectivityResult>
      connectivity.value = _mapConnectivityList(results);
    });
  }

  String _mapConnectivityList(List<ConnectivityResult> results) {
    if (results.isEmpty) return 'Offline';

    final types = results
        .map((r) {
          switch (r) {
            case ConnectivityResult.wifi:
              return 'WiFi';
            case ConnectivityResult.mobile:
              return 'Mobile';
            case ConnectivityResult.ethernet:
              return 'Ethernet';
            case ConnectivityResult.bluetooth:
              return 'Bluetooth';
            case ConnectivityResult.vpn:
              return 'VPN';
            case ConnectivityResult.other:
              return 'Other';
            case ConnectivityResult.none:
              return 'Offline';
          }
        })
        .where((t) => t != 'Offline')
        .toList();

    return types.isEmpty ? 'Offline' : types.join(' + ');
  }

  // ===== Actions =====
  Future<void> refreshSoftware() async {
    await Future.delayed(const Duration(milliseconds: 600));
    Get.snackbar('Up to date', 'Latest version is installed');
  }

  Future<void> refreshSync() async {
    await Future.delayed(const Duration(milliseconds: 300));
    lastSync.value = DateTime.now();
  }

  Future<void> sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {
        'subject': 'Support query from Easy Ops',
        'body': 'Hi Support Team,%0D%0A%0D%0A(Describe your issue here.)',
      },
    );
    await _launch(uri, 'email app');
  }

  Future<void> callSupport() async {
    final sanitized = supportPhone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: sanitized);
    await _launch(uri, 'dialer');
  }

  Future<void> openDoc(SupportDoc d) async {
    if (d.url == null || d.url!.isEmpty) {
      Get.snackbar('Unavailable', 'No link provided for this item');
      return;
    }
    final uri = Uri.parse(d.url!);
    await _launch(uri, 'browser');
  }

  Future<void> _launch(Uri uri, String appName) async {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) Get.snackbar('Couldn\'t open $appName', uri.toString());
  }
}

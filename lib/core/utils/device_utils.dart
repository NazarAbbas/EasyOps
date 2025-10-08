import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class DeviceUtils {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static final NetworkInfo _networkInfo = NetworkInfo();

  /// Returns a map containing device info, app version and network status.
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final Map<String, dynamic> data = {};

    // 1. App version info
    final packageInfo = await PackageInfo.fromPlatform();
    data['appName'] = packageInfo.appName;
    data['packageName'] = packageInfo.packageName;
    data['version'] = packageInfo.version;
    data['buildNumber'] = packageInfo.buildNumber;

    // 2. Device info
    if (Platform.isAndroid) {
      final android = await _deviceInfoPlugin.androidInfo;
      data['deviceModel'] = '${android.manufacturer} ${android.model}';
      data['osVersion'] =
          'Android ${android.version.release} (SDK ${android.version.sdkInt})';
      data['deviceId'] = android.id;
    } else if (Platform.isIOS) {
      final ios = await _deviceInfoPlugin.iosInfo;
      data['deviceModel'] = ios.utsname.machine;
      data['osVersion'] = '${ios.systemName} ${ios.systemVersion}';
      data['deviceId'] = ios.identifierForVendor;
    } else {
      data['deviceModel'] = 'Unknown';
      data['osVersion'] = 'Unknown';
      data['deviceId'] = 'Unknown';
    }

    // 3. Connectivity status
    final connectivityResult = await Connectivity().checkConnectivity();
    String networkType = 'None';
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      networkType = 'WiFi';
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      networkType = 'Mobile';
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      networkType = 'Ethernet';
    }
    data['connectivity'] = networkType;

    // 4. Extra Wi-Fi details (optional)
    if (networkType == 'WiFi') {
      final wifiName = await _networkInfo.getWifiName();
      final wifiIP = await _networkInfo.getWifiIP();
      data['wifiName'] = wifiName;
      data['wifiIP'] = wifiIP;
    }

    return data;
  }
}

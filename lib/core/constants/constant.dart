class Constant {
  static String databaseName = 'easy_ops.db';
  static String selectedLanguage = 'selected_language';
  static String selectedLocation = 'selected_location';
  static String token = 'token';
  static String hindiLanguage = 'hi';
  static String hindiCountry = 'IN';
  static const String englishLanguage = 'en';
  static const String englishCountry = 'US';
  static const int snackbarLongDuration = 2;
  static const int snackbarSmallDuration = 1;
  static const String workOrderInfo = 'work_order_info';
  static const String workOrderStatus = 'work_order_status';
}

enum WorkOrderStatus {
  open,
  resolved,
  inProgress,
  completed,
}

import 'package:ba_merchandise/modules/admin/operation/model/user_by_role_model.dart';
import 'package:ba_merchandise/modules/auth/model/auth_model.dart';
import 'package:ba_merchandise/services/local_storage/auth_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Utils {
  static Future<int?> getUserId() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    return authResponse!.data?.userId;
  }

  static String? getCompanyNameByUserId(
      RxList<ByUserRoleData> companyNameList, String userId) {
    // Find the ByUserRoleData instance with the matching userId
    final ByUserRoleData? userRoleData = companyNameList.firstWhere(
      (data) => data.userId.toString() == userId,
      orElse: () => ByUserRoleData(name: 'N/A'),
    );

    // Return the company name if found, otherwise return null
    return userRoleData?.name;
  }

  static Future<String?> getMartId() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    return authResponse!.data?.martId;
  }

  static Future<String?> getCompanyId() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    return authResponse!.data?.companyId;
  }

  static Future<String?> getUserRole() async {
    final AuthStorage authStorage = Get.find<AuthStorage>();
    AuthResponse? authResponse = await authStorage.get();
    return authResponse?.data?.role ?? '';
  }

  static setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceToken', token);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('deviceToken') ?? '';
  }

  /// Converts a [dateTimeString] in the format "yyyy-MM-dd HH:mm:ss" to "dd MMM yyyy"
  static String formatDate(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
      return formattedDate;
    } catch (e) {
      return 'Invalid Date';
    }
    // Parse the provided date string to DateTime
  }

  static String formatDay(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  static String formatTime(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }
}

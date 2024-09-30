import 'package:flutter/foundation.dart';

class Endpoints {
  static String get baseUrl {
    return kReleaseMode ? baseUrlProduction : baseUrlTesting;
  }

  static const String baseUrlProduction = "http://194.233.69.219:3005/";
  static const String baseUrlTesting = "http://194.233.69.219:3005/";
  static const String baseUrlStaging = "http://194.233.69.219:3005/";

  static const String login = "auth/login";
  static const String attendance = "auth/attendance";
  static const String recordSales = "auth/insertSales";
  static const String createUser = "auth/createUser";
  static const String createMart = "auth/createMart";
  static const String createProduct = "auth/createProduct";
  static const String createCategory = "auth/createCategory";
  static const String baIntercept = "/auth/intercepts";
  static const String updateProductPrice = "/auth/updateProductPrice";
  static const String restockApi = "/auth/createRestock";
  static const String getAllCompanyMartProduct =
      "auth/getCompanyAndMartProducts";
  static const String getUserByRole = "auth/getUsersByRole";
  static const String updateRestock = "/auth/updateRestock";
  static const String getAllCategories = "auth/getAllCategories";
  static const String getAllMart = "auth/getAllMarts";
  static const String updateToken = "auth/updateDeviceToken";
  static const String grandAccess = "auth/updateUser";
  static const String getAllBaAttendance = "auth/getAttendence";
  static const String assignBatoCompany = "auth/assignCompanyToBa";
  static const String getSales = "auth/getSales";
  static const String getAllRestockRequest = "auth/getAllRestocks";
}

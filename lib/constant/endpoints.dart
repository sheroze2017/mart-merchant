import 'package:flutter/foundation.dart';

class Endpoints {
  static String get baseUrl {
    return kReleaseMode ? baseUrlProduction : baseUrlTesting;
  }

  static const String baseUrlProduction =
      "https://canvas-prod.comsrvssoftwaresolutions.com/";
  static const String baseUrlTesting =
      "https://canvas-prod.comsrvssoftwaresolutions.com/";
  static const String baseUrlStaging =
      "https://canvas-prod.comsrvssoftwaresolutions.com/";
  static const String login = "auth/login";
  static const String attendance = "auth/attendance";
  static const String checkAttendance = "auth/checkAttendence";
  static const String recordSales = "auth/insertSales";
  static const String updateSales = "auth/updateSales";
  static const String deleteSales = "auth/deleteSales";

  static const String createUser = "auth/createUser";
  static const String restockRecord = "auth/shelfRestocked";
  static const String createMart = "auth/createMart";
  static const String createProduct = "auth/createProduct";
  static const String updateProduct = "auth/updateProduct";

  static const String submitSupervisorData = "auth/submitSupervisorData";
  static const String deleteProduct = "auth/deleteProduct";
  static const String createCategory = "auth/createCategory";
  static const String baIntercept = "auth/intercepts";
  static const String updateProductPrice = "auth/updateProductPrice";
  static const String addCompetitorActivity = "auth/insertActivity";
  static const String updateProductQuantityMerchant = "auth/updateProductsQty";
  static const String restockApi = "auth/createRestock";
  static const String getAllCompanyMartProduct =
      "auth/getCompanyAndMartProducts";
  static const String getUserByRole = "auth/getUsersByRole";
  static const String updateRestock = "auth/updateRestock";
  static const String getAllCategories = "auth/getAllCategories";
  static const String getAllMerchantRestockDetail =
      "auth/getAllRestocksByMerchant";
  static const String getAllMart = "auth/getAllMarts";
  static const String updateToken = "auth/updateDeviceToken";
  static const String grandAccess = "auth/updateUser";
  static const String getAllBaAttendance = "auth/getAttendence";
  static const String assignBatoCompany = "auth/assignCompanyToBa";
  static const String getSales = "auth/getSales";
  static const String getIntercepts = "auth/getIntercepts";

  static const String getActivity = "auth/getActivities";
  static const String getSupervisorData = "auth/getSupervisorData";

  static const String getAllRestockRequest = "auth/getAllRestocks";
}

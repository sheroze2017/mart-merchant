import 'package:ba_merchandise/modules/admin/dashboard/view/admin_dashboard.dart';
import 'package:ba_merchandise/modules/admin/operation/view/assign_employee.dart';
import 'package:ba_merchandise/modules/admin/operation/view/ba_attendance.dart';
import 'package:ba_merchandise/modules/admin/operation/view/grant_revoke_access.dart';
import 'package:ba_merchandise/modules/admin/operation/view/new_company.dart';
import 'package:ba_merchandise/modules/admin/operation/view/search_company_product.dart';
import 'package:ba_merchandise/modules/attendence/view/attendece_view.dart';
import 'package:ba_merchandise/modules/auth/view/login_view.dart';
import 'package:ba_merchandise/modules/auth/view/role_select_view.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/competitor_data.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/product_priceset.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/record_intercept.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/record_sales.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/stock_count.dart';
import 'package:ba_merchandise/modules/company/dashboard/view/company_home.dart';
import 'package:ba_merchandise/modules/merchandiser/dasboard/view/dashboard.dart';
import 'package:get/get.dart';

class Routes {
  static const LOGIN = '/login';
  static const USERROLE = '/userRole';
  static const BAHOME = '/baHome';
  static const ATTENDENCE = '/attendence';
  static const RECORD_SALES = '/recordSales';
  static const COMPETITORDATA = '/competitorData';
  static const SEARCHCOMPANYPRODUCT = '/searchCompanyProduct';

  static const STOCK_COUNT = '/stockCount';
  static const PRODUCT_PRICE = '/productPrice';
  static const RECORD_INTERCEPT = '/recordIntercept';
  static const SYNC_DATA = '/syncData';
  static const MERCHANTDASHBOARD = '/merchantHome';
  static const COMPANY_HOME = '/companyHome';
  static const ADMIN_HOME = '/adminHome';
  static const NEW_COMPANTY = '/newCompany';
  static const ASSIGNNEWEMPLOYEE = "/assignNewEmployee";
  static const BAADMINATTENDANCE = "/BaAttendance";
  static const GRANTREVOKEACCESS = "/grantRevokeAccess";
  static final routes = [
    GetPage(
        name: ADMIN_HOME,
        page: () => AdminHome(),
        transition: Transition.rightToLeft),
    GetPage(
        name: LOGIN,
        page: () => LoginScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: USERROLE,
        page: () => UserRoleSelect(),
        transition: Transition.rightToLeft),
    GetPage(
        name: BAHOME, page: () => BaHome(), transition: Transition.rightToLeft),
    GetPage(
        name: ATTENDENCE,
        page: () => AttendanceScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RECORD_INTERCEPT,
        page: () => RecordIntercept(),
        transition: Transition.rightToLeft),
    GetPage(
        name: RECORD_SALES,
        page: () => RecordSales(),
        transition: Transition.rightToLeft),
    GetPage(
        name: COMPETITORDATA,
        page: () => CompetitorData(),
        transition: Transition.rightToLeft),
    GetPage(
        name: STOCK_COUNT,
        page: () => StockCount(),
        transition: Transition.rightToLeft),
    GetPage(
        name: PRODUCT_PRICE,
        page: () => ProductPriceSet(),
        transition: Transition.rightToLeft),
    GetPage(
        name: MERCHANTDASHBOARD,
        page: () => MerchantDashboard(),
        transition: Transition.rightToLeft),
    GetPage(
        name: COMPANY_HOME,
        page: () => CompanyHome(),
        transition: Transition.rightToLeft),
    GetPage(
        name: NEW_COMPANTY,
        page: () => NewCompany(),
        transition: Transition.rightToLeft),
    GetPage(
        name: SEARCHCOMPANYPRODUCT,
        page: () => SearchCompanyProduct(),
        transition: Transition.rightToLeft),
    GetPage(
        name: ASSIGNNEWEMPLOYEE,
        page: () => AssignNewEmploye(),
        transition: Transition.rightToLeft),
    GetPage(
        name: BAADMINATTENDANCE,
        page: () => BaAttendance(),
        transition: Transition.rightToLeft),
    GetPage(
        name: GRANTREVOKEACCESS,
        page: () => GrantRevokeAccess(),
        transition: Transition.rightToLeft)
  ];
}

import 'package:ba_merchandise/modules/admin/dashboard/view/admin_dashboard.dart';
import 'package:ba_merchandise/modules/admin/operation/view/other_operation/all_ba_to_assign.dart';
import 'package:ba_merchandise/modules/admin/operation/view/attendance/ba_attendance.dart';
import 'package:ba_merchandise/modules/admin/operation/view/grant_revoke_access.dart';
import 'package:ba_merchandise/modules/admin/operation/view/create_user/new_company.dart';
import 'package:ba_merchandise/modules/admin/operation/view/create_user/new_employee.dart';
import 'package:ba_merchandise/modules/admin/operation/view/create_user/new_mart.dart';
import 'package:ba_merchandise/modules/admin/operation/view/sales/sales_screen.dart';
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
import 'package:ba_merchandise/modules/company/operation/view/attendance/attendance_screen.dart';
import 'package:ba_merchandise/modules/company/operation/view/sales/company_sales.dart';
import 'package:ba_merchandise/modules/merchandiser/dasboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/welcome/screen/welcome.dart';
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
  static const SYNC_DATA = '/syncData';
  static const MERCHANTDASHBOARD = '/merchantHome';
  static const COMPANY_HOME = '/companyHome';
  static const ADMIN_HOME = '/adminHome';
  static const NEW_COMPANTY = '/newCompany';
  static const NEW_EMPLOYEE = '/newEmployee';
  static const NEW_MART = "/newMart";
  static const ASSIGNNEWEMPLOYEE = "/assignNewEmployee";
  static const BAADMINATTENDANCE = "/BaAttendance";
  static const GRANTREVOKEACCESS = "/grantRevokeAccess";
  static const WELCOMESCREEN = "/welcomeScreen";
  static const COMPANYBAATTENDANCE = "/baAttendanceCompany";
  static const ADMINSALESROUTE = "/adminSalesRoute";
  static const COMPANYSALES = "/companySales";

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
        page: () => AllBaToAssign(),
        transition: Transition.rightToLeft),
    GetPage(
        name: BAADMINATTENDANCE,
        page: () => BaAttendance(),
        transition: Transition.rightToLeft),
    GetPage(
        name: GRANTREVOKEACCESS,
        page: () => GrantRevokeAccess(),
        transition: Transition.rightToLeft),
    GetPage(
        name: NEW_EMPLOYEE,
        page: () => NewEmployee(),
        transition: Transition.rightToLeft),
    GetPage(
        name: WELCOMESCREEN,
        page: () => SplashScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: NEW_MART,
        page: () => NewMartScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: COMPANYBAATTENDANCE,
        page: () => BaAttendanceCompanyView(),
        transition: Transition.rightToLeft),
    GetPage(
        name: ADMINSALESROUTE,
        page: () => SalesScreenMartCompany(),
        transition: Transition.rightToLeft),
    GetPage(
        name: COMPANYSALES,
        page: () => CompanySales(),
        transition: Transition.rightToLeft),
  ];
}

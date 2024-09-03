import 'package:ba_merchandise/modules/attendence/view/attendece_view.dart';
import 'package:ba_merchandise/modules/auth/view/login_view.dart';
import 'package:ba_merchandise/modules/auth/view/role_select_view.dart';
import 'package:ba_merchandise/modules/b.a/dashboard/view/dashboard.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/competitor_data.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/product_priceset.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/record_intercept.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/record_sales.dart';
import 'package:ba_merchandise/modules/b.a/record_data/view/stock_count.dart';
import 'package:ba_merchandise/modules/merchandiser/dasboard/view/dashboard.dart';
import 'package:get/get.dart';

class Routes {
  static const LOGIN = '/login';
  static const USERROLE = '/userRole';
  static const BAHOME = '/baHome';
  static const ATTENDENCE = '/attendence';
  static const RECORD_SALES = '/recordSales';
  static const COMPETITORDATA = '/competitorData';
  static const STOCK_COUNT = '/stockCount';
  static const PRODUCT_PRICE = '/productPrice';
  static const RECORD_INTERCEPT = '/recordIntercept';
  static const SYNC_DATA = '/syncData';
  static const MERCHANTDASHBOARD = '/merchantHome';

  static final routes = [
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
  ];
}

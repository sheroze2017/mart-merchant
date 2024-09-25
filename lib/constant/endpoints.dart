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
}

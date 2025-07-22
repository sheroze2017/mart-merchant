import 'dart:io';

import 'package:ba_merchandise/constant/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DioClient {
  static final DioClient _singletonRequest = DioClient._internal();

  static DioClient getInstance() {
    return _singletonRequest;
  }

  DioClient._internal();

  static final String url = Endpoints.baseUrl;

  static BaseOptions opts = BaseOptions(
    baseUrl: url,
    responseType: ResponseType.json,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 20),
  );

  static Dio createDio() {
    return Dio(opts);
  }

  static Dio addInterceptors(Dio dio) {
    dio
      ..options.headers = {
        'Content-Type': 'application/json; charset=utf-8',
        "x-app-type": Platform.isIOS ? "CUSTOMER_IOS" : "CUSTOMER_ANDROID",
      }
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            try {} catch (e) {
              print('interceptor error');
            }
            handler.next(options);
          },
          onError: (e, handler) async {
            print('error');

            if (e.type == DioErrorType.connectionTimeout ||
                e.type == DioErrorType.unknown ||
                e.type == DioErrorType.cancel) {
              Fluttertoast.showToast(
                msg: "no_internet_connection",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 12.0,
              );
              return handler.next(e);
            }

            if (e.response != null) {
              print('response not null');
              if (e.response?.statusCode == 401) {
                try {} catch (e) {}
              } else if (e.response!.statusCode! >= 500) {}
            }
            return handler.next(e);
          },
        ),
      );

    return dio;
  }

  static Dio addInterceptorsForRegistration(Dio dio) {
    dio
      ..options.headers = {
        'Content-Type': 'application/json; charset=utf-8',
        "x-app-type": Platform.isIOS ? "CUSTOMER_IOS" : "CUSTOMER_ANDROID",
      }
      // ..interceptors.add(DioLogInterceptor())
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            try {} catch (e) {
              print('interceptor error');
            }
            handler.next(options);
          },
          onError: (e, handler) async {
            print('error');

            if (e.type == DioErrorType.connectionTimeout ||
                e.type == DioErrorType.unknown ||
                e.type == DioErrorType.cancel) {
              Fluttertoast.showToast(
                  msg: "no_internet_connection",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 12.0);
              return handler.next(e);
            }

            return handler.next(e);
          },
        ),
      );

    return dio;
  }

  static final dio = createDio();
  static final baseAPI = addInterceptors(dio);
  static final baseAPIForRegister = dio;

  Future<dynamic> get<T>(String url,
      {dynamic queryParameters, bool consumer = false}) async {
    try {
      baseAPI.options.baseUrl = Endpoints.baseUrl;
      // var token = await Utils.getToken();
//      baseAPI.options.headers['Authorization'] = 'Bearer $token';

      Response<T> response =
          await baseAPI.get(url, queryParameters: queryParameters);

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post<T>(String url, {dynamic data}) async {
    try {
      baseAPI.options.baseUrl = Endpoints.baseUrl;
      Response<T> response = await baseAPI.post(url, data: data);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postPublicWithToken(String url, String token,
      {dynamic data}) async {
    try {
      baseAPIForRegister.options.baseUrl = Endpoints.baseUrl;

      final response = await baseAPIForRegister.post(url, data: data);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<dynamic> postPublic(String url, {dynamic data}) async {
    try {
      baseAPIForRegister.options.baseUrl = Endpoints.baseUrl;
      final response = await baseAPIForRegister.post(url, data: data);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<dynamic> put(String url, {dynamic data}) async {
    try {
      print(url);
      print('data ${data.toString()}');
      baseAPI.options.baseUrl = Endpoints.baseUrl;

      final response = await baseAPI.put(url, data: data);

      return response.data;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> delete(String url, {dynamic data}) async {
    try {
      baseAPI.options.baseUrl = Endpoints.baseUrl;

      final response = await baseAPI.delete(url, data: data);
      return true;
    } catch (e) {
      // print(e.toString());
      //return false;
      throw e;
    }
  }

  Future<dynamic> upload(String url, {data}) async {
    try {
      baseAPI.options.baseUrl = Endpoints.baseUrl;
      Options options = Options();
      options.headers?.putIfAbsent('Content-Type', () => 'multipart/form-data');

      final response = await baseAPI.post(url, data: data, options: options);

      return response.data;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // helper methods

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return baseAPI.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

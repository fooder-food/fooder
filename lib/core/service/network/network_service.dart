import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notification/core/service/network/config.dart';
import 'package:flutter_notification/core/service/storage/storage_service.dart';
import 'package:flutter_notification/model/auth_model.dart';

class NetworkService {

  BaseOptions? baseOptions;

  final Dio _dio = Dio();
  final StorageService _storage = StorageService();

  void init({Interceptor? customInterceptor, BaseOptions? baseOptions}) {
    final defaultBaseOptions = BaseOptions(
      baseUrl: HttpConfig.baseURL,
    );
    _dio.options = baseOptions ?? defaultBaseOptions;
    //interceptors
    Interceptor dioInterceptor = InterceptorsWrapper(
        onRequest: (RequestOptions requestOptions, RequestInterceptorHandler handler) async {

          final prefs = await _storage.getByKey('user');
          if(prefs != null) {
            final Auth auth =
            Auth.fromJson(jsonDecode(prefs) as Map<String, dynamic>);
            requestOptions.headers["Authorization"] = "Bearer ${auth.token}";
          }
          handler.next(requestOptions);
        },
        onError: (DioError err, ErrorInterceptorHandler handler) {
          handler.next(err);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          handler.next(response);
        }
    );

    List<Interceptor> interceptorList =[dioInterceptor];

    if(customInterceptor != null) {
      interceptorList.add(customInterceptor);
    }

    _dio.interceptors.addAll(interceptorList);
  }

  NetworkService._constructor() {
    init();
  }

  NetworkService._countryStateConstructor() {
    init(
      baseOptions: BaseOptions(
        baseUrl: 'https://api.countrystatecity.in/v1/',
        headers: {
          "X-CSCAPI-KEY": dotenv.env["COUNTRY_API_KEY"],
        }
      ),
    );
  }

  NetworkService._countryConstructor() {
    init(
      baseOptions: BaseOptions(
        baseUrl: 'https://restcountries.com/v3.1/',
      )
    );
  }

  NetworkService._googleApiConstructor() {
    init(
        baseOptions: BaseOptions(
          baseUrl: 'https://maps.googleapis.com/maps/api/',
        )
    );
  }

  static final _service = NetworkService._constructor();
  static final _countryService = NetworkService._countryConstructor();
  static final _googleApiService = NetworkService._googleApiConstructor();
  static final _countryStateServce = NetworkService._countryStateConstructor();

  factory NetworkService() => _service;

  factory NetworkService.googleMapApi() => _googleApiService;

  factory NetworkService.country() {
    return _countryService;
  }

  factory NetworkService.countryState() {
    return _countryStateServce;
  }

  Future<Response> get(String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress}) {
    return _dio.get(
      url,
      queryParameters: queryParams,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<Map<String, dynamic>>> post(String url,
      {Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        bool? isFormData,
        void Function(int, int)? onSendProgress,
        void Function(int, int)? onReceiveProgress}) async {
    return _dio.post(url,
        data: data != null
            ? (isFormData == true ? FormData.fromMap(data) : data)
            : null,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<Map<String, dynamic>>> put(String url,
      {Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool? isFormData,
        CancelToken? cancelToken,
        void Function(int, int)? onSendProgress,
        void Function(int, int)? onReceiveProgress}) async {
    return _dio.put(url,
        data: data != null
            ? (isFormData == true ? FormData.fromMap(data) : data)
            : null,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<Map<String, dynamic>>> del(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        bool? isFormData,
        CancelToken? cancelToken,
      }) async {
    return _dio.delete(
      url,
      data: data != null
          ? (isFormData == true ? FormData.fromMap(data) : data)
          : null,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }


}
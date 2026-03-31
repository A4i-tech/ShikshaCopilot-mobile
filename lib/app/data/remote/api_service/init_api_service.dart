import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:path/path.dart' as path;
import 'package:sikshana/app/data/config/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sikshana/app/data/local/store/local_store.dart';
import 'package:sikshana/app/data/local/user_provider.dart';
import 'package:sikshana/app/ui/components/app_snackbar.dart';

part '../../../utils/api_extensions.dart';

/// DIO interceptor to add the authentication token
InterceptorsWrapper addAuthToken({String authTokenHeader = 'authorization'}) =>
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        options.headers.addAll(<String, dynamic>{
          authTokenHeader: '${LocalStore.authToken}',
        });
        handler.next(options); //continue
      },
    );

/// Dio interceptor to encrypt the request body
InterceptorsWrapper encryptBody() => InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    final String method = options.method.toUpperCase();

    if (options.headers['encrypt'] as bool) {
      switch (method) {
        case 'POST':
        case 'PUT':
        case 'PATCH':
          logW('encrypting $method method');
          if (options.data.runtimeType.toString() ==
              '_InternalLinkedHashMap<String, dynamic>') {
            logI('Data will be encrypted before sending request');
            options.data = <String, dynamic>{'data': jsonEncode(options.data)};
          } else {
            logI('Skipping encryption for ${options.data.runtimeType} type');
          }

          break;
        default:
          logWTF('Skipping encryption for $method method');
          break;
      }
    }
    handler.next(options); //continue
  },
);

/// API service of the application. To use Get, POST, PUT and PATCH rest methods
class APIService {
  static final Dio _dio = Dio();
  static bool _isInitialized = false;
  static bool _isLoggingOut = false;

  /// Initialize the API service
  static void initializeAPIService({
    required String baseUrl,
    bool encryptData = false,
    String authHeader = 'authorization',
  }) {
    _dio.options.baseUrl = baseUrl;

    if (_isInitialized) {
      return; // prevent duplicate interceptors
    }

    _dio.interceptors.clear(); // optional but recommended

    _dio.interceptors.add(addAuthToken(authTokenHeader: authHeader));

    if (encryptData) {
      _dio.interceptors.add(encryptBody());
    }
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401 && !_isLoggingOut) {
            _isLoggingOut = true;
            logE('Token expired. Logging out...');
            appSnackBar(
              message: 'Session expired. Logging out...',
              state: SnackBarState.info,
              type: SnackBarType.top,
            );
            await UserProvider.onLogout();
          }
          handler.next(error);
        },
      ),
    );

    _isInitialized = true; // mark as initialized
  }

  /// GET rest API call
  /// Used to get data from backend
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<T>?> get<T>({
    required String path,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    bool encrypt = true,
  }) async => _dio.get<T>(
    path,
    queryParameters: params,
    options: Options(headers: headers ?? <String, dynamic>{'encrypt': encrypt}),
  );

  /// POST rest API call
  /// Used to send any data to server and get a response
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<T>?> post<T>({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    bool encrypt = true,
  }) async => _dio.post<T>(
    path,
    data: data,
    queryParameters: params,
    options: Options(headers: headers ?? <String, dynamic>{'encrypt': encrypt}),
  );

  /// POST rest API call
  /// Used to send any data to server and get a response
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<Map<String, dynamic>?>?> postFormData({
    required String path,
    FormData? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    bool encrypt = true,
  }) async => _dio.post<Map<String, dynamic>?>(
    path,
    data: data,
    queryParameters: params,
    options: Options(headers: headers ?? <String, dynamic>{'encrypt': encrypt}),
  );

  /// PUT rest API call
  /// Usually used to create new record
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<T>?> put<T>({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    bool encrypt = true,
    Map<String, dynamic>? headers,
  }) async => _dio.put<T>(
    path,
    data: data,
    queryParameters: params,
    options: Options(headers: headers ?? <String, dynamic>{'encrypt': encrypt}),
  );

  /// PATCH rest API call
  /// Usually used to update any record
  ///
  /// The updated data to be passed in [data]
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the body needs to be encrypted. Make sure the
  /// encryption keys in the backend matches with the one in frontend
  static Future<Response<T>?> patch<T>({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    bool encrypt = true,
  }) async => _dio.patch<T>(
    path,
    data: data,
    queryParameters: params,
    options: Options(headers: headers ?? <String, dynamic>{'encrypt': encrypt}),
  );

  /// DELETE rest API call
  /// Usually used to delete a record
  ///
  /// [params] are query parameters
  ///
  /// [path] is the part of the path after the base URL
  ///
  /// set [encrypt] to true if the request needs to be encrypted.
  static Future<Response<T>?> delete<T>({
    required String path,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    bool encrypt = true,
    Map<String, dynamic>? data,
  }) async => _dio.delete<T>(
    path,
    queryParameters: params,
    data: data,
    options: Options(headers: headers ?? <String, dynamic>{'encrypt': encrypt}),
  );

  /// Upload file to the server. You will get the URL in the response if the
  /// [file] was uploaded successfully. Else you will get null in response.
  ///
  static Future<String?> uploadFile({
    required File file,
    required String folder,
  }) async {
    final Response<Map<String, dynamic>?>? response = await APIService.post(
      path: '/user/upload/$folder/images',
      data: <String, dynamic>{
        'images': MultipartFile.fromBytes(
          List<int>.from(await file.readAsBytes()),
          contentType: http_parser.MediaType(
            'image',
            path.extension(file.path),
          ),
          filename: file.path,
        ),
      },
      encrypt: false,
    );

    if (response?.statusCode != 200) {
      return null;
    }

    final Map<String, dynamic>? data = response?.data;

    if (data?['code'] == 'FILE_UPLOADED') {
      logE(data?['file']);
      return data?['file'] as String?;
    } else {
      return null;
    }
  }
}

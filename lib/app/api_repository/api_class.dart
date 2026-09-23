import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';

import '../utils/app_constant.dart';
import 'loading.dart';

class HttpUtil {
  factory HttpUtil(String token, bool isLoading, BuildContext context) => _instance(token, isLoading, context);

  static HttpUtil _instance(token, isLoading, context) => HttpUtil._internal(token: token, isLoading: isLoading, context: context);

  late Dio dio;
  CancelToken cancelToken = CancelToken();
  String apiUrl = Constants.baseUrl;

  BuildContext? context;

  HttpUtil._internal({String? token, bool? isLoading, required BuildContext context}) {
    BaseOptions options = BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: 200000,
      receiveTimeout: 200000,
      headers: {
        'Accept': "application/json",
        'Authorization': 'Bearer $token',
      },
      // Don't set contentType here - let Dio auto-detect based on data type
      // This allows multipart/form-data for file uploads and application/json for JSON
      responseType: ResponseType.json,
    );

    dio = Dio(options);
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    // Add loading and error interceptor first
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (isLoading!) {
          Loading.show();
        }
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        if (isLoading!) {
          Loading.dismiss();
        }
        return handler.next(response); // continue
      },
      onError: (DioError e, handler) {
        if (isLoading!) {
          Loading.dismiss();
        }

        onError(createErrorEntity(e), context);

        return handler.next(e); //continue
      },
    ));

    // Add log interceptor second
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
    ));

    // CRITICAL: Add FormData handler LAST to ensure it runs after everything else
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Force multipart/form-data for FormData
        if (options.data is FormData) {
          // Remove any existing content-type
          options.headers.remove('content-type');
          options.headers.remove('Content-Type');
          // Don't set contentType in options - let FormData handle it internally
          options.contentType = null;
          // Ensure Dio default request transformer is used for FormData
          options.extra['_useFormDataTransformer'] = true;
        }
        return handler.next(options);
      },
    ));
  }

// On Error....
  void onError(ErrorEntity eInfo, BuildContext context) {
    print("error.code -> ${eInfo.code}, error.message -> ${eInfo.message}");
    if (eInfo.message.isNotEmpty) {
      utils.showSnackBar(message: eInfo.message, context: context);
    }
  }

  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        return ErrorEntity(code: -1, message: "Request to server was cancelled");
      case DioErrorType.connectTimeout:
        return ErrorEntity(code: -2, message: "Connection timeout with server");
      case DioErrorType.sendTimeout:
        return ErrorEntity(code: -3, message: "Send timeout in connection with server");
      case DioErrorType.receiveTimeout:
        return ErrorEntity(code: -4, message: "Receive timeout in connection with server");
      case DioErrorType.response:
        {
          try {
            int errCode = error.response != null ? error.response!.statusCode! : 00;
            print("errCode--------->> $errCode");
            switch (errCode) {
              case 400:
                return ErrorEntity(code: errCode, message: "Request syntax error");
              case 401:
                return ErrorEntity(code: errCode, message: "Permission denied");
              case 403:
                return ErrorEntity(code: errCode, message: "Server refuses to execute");
              case 404:
                return ErrorEntity(code: errCode, message: "Can not reach server");
              case 405:
                return ErrorEntity(code: errCode, message: "Request method is forbidden");
              case 429:
                return ErrorEntity(code: errCode, message: "Too many requests. Please try again later.");
              case 500:
                return ErrorEntity(code: errCode, message: "Internal server error");
              case 502:
                return ErrorEntity(code: errCode, message: "Invalid request");
              case 503:
                return ErrorEntity(code: errCode, message: "Server hangs");
              case 505:
                return ErrorEntity(code: errCode, message: "HTTP protocol requests are not supported");
              default:
                String errorMessage = "";
                if (error.response != null && error.response!.data != null) {
                  if (error.response!.data is Map<String, dynamic>) {
                    final data = error.response!.data as Map<String, dynamic>;
                    errorMessage = data['message']?.toString() ?? "Unknown error occurred";
                  } else if (error.response!.data is String) {
                    errorMessage = error.response!.data as String;
                  } else {
                    errorMessage = error.response!.data.toString();
                  }
                }
                return ErrorEntity(code: errCode, message: errorMessage);
            }
          } on Exception catch (_) {
            return ErrorEntity(code: 00, message: "Unknown mistake");
          }
        }
      case DioErrorType.other:
        if (error.message.contains("SocketException")) {
          return ErrorEntity(code: -5, message: "Your internet is not available, please try again later");
        } else if (error.message.contains("Software caused connection abort")) {
          return ErrorEntity(code: -6, message: "Your internet is not available, please try again later");
        }
        return ErrorEntity(code: -7, message: "Oops something went wrong");
    }
  }

  void cancelRequests() {
    cancelToken.cancel("cancelled");
  }

  /// restful get
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = true,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post
  Future post(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // For FormData, create clean Options without contentType
    Options requestOptions;
    if (data != null) {
      // Create completely clean options for FormData
      requestOptions = Options(
        headers: options?.headers,
        method: options?.method,
        sendTimeout: options?.sendTimeout,
        receiveTimeout: options?.receiveTimeout,
        extra: options?.extra,
        followRedirects: options?.followRedirects,
        validateStatus: options?.validateStatus,
        receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
        // Explicitly NO contentType - let Dio handle multipart
      );
    } else {
      requestOptions = options ?? Options();
    }
    
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post
  Future postt(
    String path, {
    String? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.contentType = 'application/json'; // Explicit for JSON data
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful put
  Future put(
    String path, {
    String? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.contentType = 'application/json'; // Explicit for JSON data

    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful delete
  Future delete(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // For FormData, create clean Options without contentType
    Options requestOptions;
    if (data != null) {
      requestOptions = Options(
        headers: options?.headers,
        method: options?.method,
        sendTimeout: options?.sendTimeout,
        receiveTimeout: options?.receiveTimeout,
        extra: options?.extra,
        followRedirects: options?.followRedirects,
        validateStatus: options?.validateStatus,
        receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      );
    } else {
      requestOptions = options ?? Options();
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful patch
  Future patch(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // For FormData, create clean Options without contentType
    Options requestOptions;
    if (data != null) {
      requestOptions = Options(
        headers: options?.headers,
        method: options?.method,
        sendTimeout: options?.sendTimeout,
        receiveTimeout: options?.receiveTimeout,
        extra: options?.extra,
        followRedirects: options?.followRedirects,
        validateStatus: options?.validateStatus,
        receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      );
    } else {
      requestOptions = options ?? Options();
    }

    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post form
  Future postForm(
    String path, {
    FormData? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    // For FormData, create clean Options without contentType
    Options requestOptions;
    if (data != null) {
      requestOptions = Options(
        headers: options?.headers,
        method: options?.method,
        sendTimeout: options?.sendTimeout,
        receiveTimeout: options?.receiveTimeout,
        extra: options?.extra,
        followRedirects: options?.followRedirects,
        validateStatus: options?.validateStatus,
        receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      );
    } else {
      requestOptions = options ?? Options();
    }

    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post Stream
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();

    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";

  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}

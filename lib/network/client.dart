import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hostels/network/http_result.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../variables/links.dart';
import '../variables/util_variables.dart';

DioClient? _client;

DioClient get client {
  _client ??= DioClient();
  return _client!;
}

class DioClient {
  Dio? _dio;

  Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      _dio!
        ..interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
        ))
        ..options.baseUrl = Links.baseUrl
        ..options.connectTimeout = const Duration(seconds: 30)
        ..options.receiveTimeout = const Duration(seconds: 30)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json; charset=UTF-8',
        };
    }
    return _dio!;
  }

  Future<MainModel> get(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool withoutHeader = false,
  }) async {
    try {
      final response = await dio.get(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: withoutHeader ? {} : _header()),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return _analyseResponse(response);
    } catch (e) {
      print('dioError: $e');
      if (e is DioException) {
        return _analyseResponse(e.response);
      }
      return defaultModel;
    }
  }

  Future<MainModel> post(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final response = await dio.post(uri,
          data: data,
          queryParameters: queryParameters,
          options: Options(
            headers: _header(),
          ),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return _analyseResponse(response);
    } catch (e) {
      debugPrint('dioError: $e');
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          return defaultModel.copyWith(error: {'description: check internet'});
        }
        if (e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionTimeout) {
          return defaultModel.copyWith(
            error: {'description': 'check server'},
          );
        }
        if (e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionTimeout) {
          return defaultModel.copyWith(
            error: {'description': 'checkServer'},
          );
        }
        return _analyseResponse(e.response);
      }
      return defaultModel;
    }
  }

  MainModel _analyseResponse(Response? response) {
    print(
        'STATUS: ${response?.statusCode}  ERROR: ${response?.data['errors']} --- DATA: ${response?.data['data']}  TRUE MAP OR FALSE ${response?.data is Map<String, dynamic>}: response data ${response?.data} TRUE MAP OR FALSE ${response?.data is Map<String, dynamic>}');
    if (response?.data is Map<String, dynamic>) {
      return MainModel(
        status: int.tryParse('${response?.data['status']}') ??
            response?.statusCode ??
            403,
        error: response?.data['errors'],
        data: response?.data['data'] ??
            response?.data['errors'] ??
            response?.data,
      );
    }
    return defaultModel;
  }

  Map<String, dynamic> _header() {
    String token = pref.getString(PrefKeys.token) ?? "";
    String lan = pref.getString(PrefKeys.language) ?? "uz";
    if (token == "") {
      return {
        "Accept-Language": lan,
        "Accept": 'application/json',
      };
    } else {
      return {
        "Authorization": "Bearer $token",
        "Accept-Language": lan,
        "Accept": 'application/json',
      };
    }
  }
}

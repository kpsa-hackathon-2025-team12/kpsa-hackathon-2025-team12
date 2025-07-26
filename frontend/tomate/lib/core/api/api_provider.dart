import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/secure_storage_provider.dart';
import 'token_interceptor.dart';
import '../../common/constants/defines.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final apiProvider = AsyncNotifierProvider(ApiNotifier.new);

class ApiNotifier extends AsyncNotifier {
  @override
  FutureOr build() {
    _dio = Dio(_options);

    // 요청/응답 로깅을 위한 PrettyDioLogger 추가
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );

    // TokenInterceptor 추가
    final storage = ref.read(secureStorageProvider);
    _dio.interceptors.add(TokenInterceptor(storage: storage));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            handler.resolve(
              Response(
                requestOptions: e.requestOptions,
                statusCode: 400,
                data: {'message': '요청 시간이 초과되었습니다. (5초 제한)'},
              ),
            );
          } else {
            handler.next(e);
          }
        },
      ),
    );
  }

  Future<dynamic> getAsync(String path) async {
    final response = await _dio.get(path);

    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  Future<dynamic> getQueryAsync(
    String path,
    Map<String, String> queryParams, {
    String? authorization,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParams,
      options: Options(
        headers: {
          if (authorization != null) 'Authorization': 'Bearer $authorization',
        },
      ),
    );

    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  Future<dynamic> deleteAsync(String path) async {
    final response = await _dio.delete(path);

    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  Future<dynamic> deleteBodyAsync(
    String path,
    Object body, {
    String? authorization,
  }) async {
    final response = await _dio.delete(
      path,
      data: body,
      options: Options(
        headers: {
          if (authorization != null) 'Authorization': 'Bearer $authorization',
        },
      ),
    );
    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  Future<dynamic> postAsync(
    String path,
    Object body, {
    String? authorization,
  }) async {
    final response = await _dio.post(
      path,
      data: body,
      options: Options(
        headers: {
          if (authorization != null) 'Authorization': 'Bearer $authorization',
        },
      ),
    );
    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  Future<dynamic> postQueryAsync(
    String path,
    Map<String, String> queryParams, {
    String? authorization,
  }) async {
    final response = await _dio.post(
      path,
      queryParameters: queryParams, // 쿼리 파라미터로 전달
      options: Options(
        headers: {
          if (authorization != null) 'Authorization': 'Bearer $authorization',
        },
      ),
    );
    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  Future<dynamic> postMultipartAsync(
    String path,
    FormData formData, {
    String? authorization,
  }) async {
    final response = await _dio.post(
      path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          if (authorization != null) 'Authorization': 'Bearer $authorization',
        },
      ),
    );
    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  Future<dynamic> putAsync(
    String path,
    Object body, {
    String? authorization,
  }) async {
    final response = await _dio.put(
      path,
      data: body,
      options: Options(
        headers: {
          if (authorization != null) 'Authorization': 'Bearer $authorization',
        },
      ),
    );

    return response.statusCode! >= 200 && response.statusCode! < 300
        ? response
        : null;
  }

  final _options = BaseOptions(
    baseUrl: SERVER_URL,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    connectTimeout: Duration(milliseconds: API_TIMEOUT), // 연결 타임아웃
    receiveTimeout: Duration(milliseconds: API_TIMEOUT), // 응답 수신 타임아웃
  );

  late final Dio _dio;
}

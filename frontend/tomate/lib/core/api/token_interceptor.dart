import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/secure_storage.dart';
import '../../common/constants/defines.dart';

/// TokenInterceptor 클래스는 요청, 응답, 에러를 처리하며 토큰 관리를 담당합니다.
class TokenInterceptor extends Interceptor {
  final SecureStorage storage;

  TokenInterceptor({required this.storage});

  /// 1) 요청을 보낼 때 호출됩니다.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      print('[REQ] [${options.method}] ${options.uri}');
    } // 요청 로그

    // 헤더에 'accessToken: true'가 있는 경우
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken'); // 헤더에서 임시 키 제거

      // SecureStorage에서 액세스 토큰 읽기
      final token = await storage.readAccessToken();
      if (kDebugMode) {
        print('[REQ_HEADER_BEFORE] ${options.headers}');
      } // 수정 전 헤더 로그
      options.headers.addAll({
        'authorization': token, // 실제 토큰 추가
      });
      if (kDebugMode) {
        print('[REQ_HEADER] ${options.headers}');
      } // 수정 후 헤더 로그
    }
    handler.next(options); // 다음 단계로 전달
  }

  /// 2) 응답을 받을 때 호출됩니다.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}',
      );
    } // 응답 로그
    handler.next(response); // 응답 처리
  }

  /// 3) 요청 도중 에러가 발생했을 때 호출됩니다.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    } // 에러 로그

    // 401 Unauthorized 에러 처리
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.readRefreshToken();
      if (refreshToken != null) {
        try {
          final newAccessToken = await _refreshAccessToken(refreshToken);
          if (newAccessToken != null) {
            // 실패한 요청을 재시도
            final requestOptions = err.requestOptions;
            requestOptions.headers['authorization'] = 'Bearer $newAccessToken';
            handler.resolve(await Dio().fetch(requestOptions)); // 재시도 후 응답 반환
            return;
          }
        } catch (e) {
          if (kDebugMode) {
            print('[Token Refresh Error] $e');
          }
        }
      }
    }

    handler.next(err); // 에러를 다음 단계로 전달
  }

  /// 리프레시 토큰을 사용해 새로운 액세스 토큰을 요청
  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final dio = Dio(); // 별도의 Dio 인스턴스 생성
      final response = await dio.post(
        '$SERVER_URL/auth/refresh-token', // 토큰 갱신 API 엔드포인트
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        await storage.saveAccessToken(newAccessToken); // 새 토큰 저장
        return newAccessToken;
      }
    } catch (e) {
      if (kDebugMode) {
        print('[Failed to refresh access token] $e');
      }
    }
    return null;
  }
}

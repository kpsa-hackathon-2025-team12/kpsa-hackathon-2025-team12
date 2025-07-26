import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  final FlutterSecureStorage storage;

  SecureStorage({required this.storage});

  // **민감한 데이터 관리 (FlutterSecureStorage)**

  // 리프레시 토큰 저장
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      if (kDebugMode) {
        print('[SECURE_STORAGE] saveRefreshToken: $refreshToken');
      }
      await storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] RefreshToken 저장 실패: $e");
      }
    }
  }

  // 리프레시 토큰 불러오기
  Future<String?> readRefreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'REFRESH_TOKEN');
      if (kDebugMode) {
        print('[SECURE_STORAGE] readRefreshToken: $refreshToken');
      }
      return refreshToken;
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] RefreshToken 불러오기 실패: $e");
      }
      return null;
    }
  }

  // 액세스 토큰 저장
  Future<void> saveAccessToken(String accessToken) async {
    try {
      if (kDebugMode) {
        print('[SECURE_STORAGE] saveAccessToken: $accessToken');
      }
      await storage.write(key: 'ACCESS_TOKEN', value: accessToken);
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] AccessToken 저장 실패: $e");
      }
    }
  }

  // 액세스 토큰 불러오기
  Future<String?> readAccessToken() async {
    try {
      final accessToken = await storage.read(key: 'ACCESS_TOKEN');
      if (kDebugMode) {
        print('[SECURE_STORAGE] readAccessToken: $accessToken');
      }
      return accessToken;
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] AccessToken 불러오기 실패: $e");
      }
      return null;
    }
  }

  // 모든 토큰 삭제
  Future<void> deleteTokens() async {
    try {
      await storage.delete(key: 'ACCESS_TOKEN');
      await storage.delete(key: 'REFRESH_TOKEN');
      if (kDebugMode) {
        print('[SECURE_STORAGE] 모든 토큰 삭제 완료');
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] 토큰 삭제 실패: $e");
      }
    }
  }

  // **일반 데이터 관리 (SharedPreferences)**

  // 문자열 저장
  Future<void> saveString(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      if (kDebugMode) {
        print('[SHARED_PREFS] saveString: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] String 저장 실패: $e");
      }
    }
  }

  // 문자열 불러오기
  Future<String?> readString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      if (kDebugMode) {
        print('[SHARED_PREFS] readString: $key = $value');
      }
      return value;
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] String 불러오기 실패: $e");
      }
      return null;
    }
  }

  // 불린 저장
  Future<void> saveBool(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
      if (kDebugMode) {
        print('[SHARED_PREFS] saveBool: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] Bool 저장 실패: $e");
      }
    }
  }

  // 불린 불러오기
  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool(key) ?? defaultValue;
      if (kDebugMode) {
        print('[SHARED_PREFS] readBool: $key = $value');
      }
      return value;
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] Bool 불러오기 실패: $e");
      }
      return defaultValue;
    }
  }

  // 정수 저장
  Future<void> saveInt(String key, int value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
      if (kDebugMode) {
        print('[SHARED_PREFS] saveInt: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] Int 저장 실패: $e");
      }
    }
  }

  // 정수 불러오기
  Future<int> readInt(String key, {int defaultValue = 0}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getInt(key) ?? defaultValue;
      if (kDebugMode) {
        print('[SHARED_PREFS] readInt: $key = $value');
      }
      return value;
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] Int 불러오기 실패: $e");
      }
      return defaultValue;
    }
  }

  // 특정 키 삭제
  Future<void> deleteKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      if (kDebugMode) {
        print('[SHARED_PREFS] deleteKey: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] Key 삭제 실패: $e");
      }
    }
  }

  // 모든 데이터 삭제
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await storage.deleteAll();
      if (kDebugMode) {
        print('[STORAGE] 모든 데이터 삭제 완료');
      }
    } catch (e) {
      if (kDebugMode) {
        print("[ERR] 전체 데이터 삭제 실패: $e");
      }
    }
  }
}

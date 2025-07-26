import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// Logger 인스턴스
final logger = Logger();

// FCM 토큰 Provider
final fcmTokenProvider = StateProvider<String?>((ref) => null);

// Firebase Messaging Provider
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

// 로컬 알림 Provider
final localNotificationsProvider = Provider<FlutterLocalNotificationsPlugin>((
    ref,
    ) {
  return FlutterLocalNotificationsPlugin();
});

// Firebase 서비스 Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  final messaging = ref.read(firebaseMessagingProvider);
  final localNotifications = ref.read(localNotificationsProvider);
  return FirebaseService(messaging, localNotifications, ref);
});

class FirebaseService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final Ref _ref;

  FirebaseService(this._messaging, this._localNotifications, this._ref);

  /// FCM 토큰 가져오기
  Future<String?> getFCMToken() async {
    try {
      // iOS 알림 권한 상태 확인
      final settings = await _messaging.getNotificationSettings();
      logger.i('iOS 알림 권한 상태: ${settings.authorizationStatus}');

      // 권한이 없다면 요청
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        logger.i('iOS 알림 권한 요청 중...');
        final newSettings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );
        logger.i('iOS 알림 권한 요청 결과: ${newSettings.authorizationStatus}');
      }

      final token = await _messaging.getToken();
      if (token != null) {
        _ref.read(fcmTokenProvider.notifier).state = token;
        logger.i('FCM Token: $token');
      }
      return token;
    } catch (e) {
      logger.e('FCM 토큰 가져오기 실패: $e');
      return null;
    }
  }

  /// FCM 토큰 갱신 리스너 설정
  void setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      _ref.read(fcmTokenProvider.notifier).state = newToken;
      logger.i('FCM Token 갱신됨: $newToken');
      // 필요시 서버에 새 토큰 전송
    });
  }

  /// 포그라운드 메시지 리스너 설정
  void setupForegroundMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logger.i('포그라운드 메시지 수신: ${message.notification?.title}');
      logger.i('메시지 데이터: ${message.data}');
      logger.i('알림 내용: ${message.notification?.body}');
      logger.i('현재 플랫폼: ${Platform.operatingSystem}');

      if (Platform.isAndroid) {
        if (message.notification != null &&
            message.notification!.android != null) {
          logger.i('Android 포그라운드 알림 처리 시작');
          await _showLocalNotificationForAndroid(message);
        } else {
          logger.w('Android 알림 내용이 null입니다.');
        }
      } else if (Platform.isIOS) {
        if (message.notification != null &&
            message.notification!.apple != null) {
          logger.i('iOS 포그라운드 알림 처리 시작 (Apple 알림 데이터 확인됨)');
          await _showLocalNotificationForIOS(message);
        } else {
          logger.w(
            'iOS Apple 알림 내용이 null입니다. message.notification: ${message.notification != null}, apple: ${message.notification?.apple != null}',
          );
        }
      }
    });
  }

  /// 알림 클릭 리스너 설정
  void setupMessageOpenedAppListener() {
    // 앱이 백그라운드에서 알림 클릭으로 열린 경우
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('알림 클릭으로 앱 열림: ${message.notification?.title}');
      _handleNotificationClick(message);
    });

    // 앱이 종료된 상태에서 알림 클릭으로 열린 경우
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        logger.i('앱 종료 상태에서 알림 클릭: ${message.notification?.title}');
        _handleNotificationClick(message);
      }
    });
  }

  /// iOS 로컬 알림 표시
  Future<void> _showLocalNotificationForIOS(RemoteMessage message) async {
    try {
      logger.i('iOS 로컬 알림 표시 시작: ${message.notification?.title}');

      // Apple 이미지 첨부 지원
      final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: message.notification!.apple?.imageUrl != null
            ? [
          DarwinNotificationAttachment(
            message.notification!.apple!.imageUrl!,
          ),
        ]
            : null,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        iOS: iOSDetails,
      );

      await _localNotifications.show(
        message.notification!.hashCode,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: message.data.toString(),
      );

      logger.i('iOS 로컬 알림 표시 완료');
    } catch (e) {
      logger.e('iOS 로컬 알림 표시 실패: $e');
    }
  }

  /// Android 로컬 알림 표시
  Future<void> _showLocalNotificationForAndroid(RemoteMessage message) async {
    try {
      logger.i('Android 로컬 알림 표시 시작: ${message.notification?.title}');

      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'AppTest_notification',
        'Notifications for AppTest app',
        priority: Priority.high, // 우선순위 높게 설정
        importance: Importance.max,
        channelDescription: 'AppTest 알림입니다.',
        icon: "@mipmap/ic_launcher",
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
      );

      await _localNotifications.show(
        message.notification!.hashCode,
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: message.data.toString(),
      );

      logger.i('Android 로컬 알림 표시 완료');
    } catch (e) {
      logger.e('Android 로컬 알림 표시 실패: $e');
    }
  }

  /// 알림 클릭 처리
  void _handleNotificationClick(RemoteMessage message) {
    // 알림 클릭 시 처리할 로직 구현
    // 예: 특정 페이지로 이동
    final data = message.data;
    logger.i('알림 데이터: $data');

    // TODO: 라우팅 로직 구현
    // context.go('/notification_detail', extra: data);
  }

  /// Firebase 서비스 초기화
  Future<void> initialize() async {
    await getFCMToken();

    // iOS 전용 권한 상태 상세 확인
    if (Platform.isIOS) {
      await _checkIOSNotificationStatus();
    }

    setupTokenRefreshListener();
    setupForegroundMessageListener();
    setupMessageOpenedAppListener();

    logger.i('Firebase 서비스 초기화 완료');
  }

  /// iOS 알림 권한 상태 상세 확인
  Future<void> _checkIOSNotificationStatus() async {
    try {
      final settings = await _messaging.getNotificationSettings();
      logger.i('=== iOS 알림 권한 상태 ===');
      logger.i('authorizationStatus: ${settings.authorizationStatus}');
      logger.i('==================');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        logger.w('iOS 알림 권한이 거부되었습니다. 사용자가 설정에서 권한을 허용해야 합니다.');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        logger.i('iOS 알림 권한이 허용되었습니다.');
      }
    } catch (e) {
      logger.e('iOS 알림 권한 상태 확인 실패: $e');
    }
  }
}

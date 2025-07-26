import Flutter
import UIKit
import Firebase
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Firebase 초기화
    FirebaseApp.configure()

    // 푸시 알림 delegate 설정
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // 플러그인 자동 등록
    GeneratedPluginRegistrant.register(with: self)

    // Flutter 초기화 완료 후 계속 진행
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 앱 포그라운드 상태에서 알림 수신 처리
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // 포그라운드에서도 알림 표시 허용
    completionHandler([.alert, .badge, .sound])
  }

  // 알림 클릭 시 동작 처리
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}

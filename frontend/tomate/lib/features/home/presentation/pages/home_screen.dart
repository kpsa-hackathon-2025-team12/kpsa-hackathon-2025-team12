import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../../core/api/api_provider.dart';
import '../../../../core/providers/firebase_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        backgroundColor: Colors.deepPurple.shade50,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80.sp, color: Colors.deepPurple),
            SizedBox(height: 20.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pretendard',
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              '현재 $title 화면입니다',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Pretendard',
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 40.h),
            // API 테스트 버튼
            Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25.r),
                  onTap: () => _testApiCall(ref, context),
                  child: Center(
                    child: Text(
                      'API 테스트',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            // API 상태 표시
            ref
                .watch(apiProvider)
                .when(
                  data: (data) => Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'API 연결 준비 완료',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'API 초기화 중...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  error: (error, stack) => Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 24.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'API 초기화 실패: $error',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            SizedBox(height: 30.h),
            // Firebase 테스트 섹션
            _buildFirebaseSection(ref, context),
          ],
        ),
      ),
    );
  }

  // Firebase 테스트 섹션 위젯
  Widget _buildFirebaseSection(WidgetRef ref, BuildContext context) {
    final fcmToken = ref.watch(fcmTokenProvider);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud, color: Colors.orange, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Firebase 연결 상태',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (fcmToken != null) ...[
            Text(
              'FCM 토큰:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.orange.shade700,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fcmToken,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'monospace',
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _copyToClipboard(context, fcmToken),
                        icon: Icon(Icons.copy, size: 16.sp),
                        label: Text('복사'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              children: [
                SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.orange),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'FCM 토큰 로딩 중...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _refreshFCMToken(ref, context),
              icon: Icon(Icons.refresh, size: 18.sp),
              label: Text('토큰 새로고침'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FCM 토큰 클립보드 복사
  void _copyToClipboard(BuildContext context, String token) {
    Clipboard.setData(ClipboardData(text: token));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('FCM 토큰이 클립보드에 복사되었습니다'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // FCM 토큰 새로고침
  void _refreshFCMToken(WidgetRef ref, BuildContext context) async {
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.getFCMToken();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('FCM 토큰을 새로고침했습니다'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('FCM 토큰 새로고침 실패: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // API 테스트 함수
  void _testApiCall(WidgetRef ref, BuildContext context) async {
    try {
      // API Provider에서 인스턴스 가져오기
      final apiNotifier = ref.read(apiProvider.notifier);

      // 예제 GET 요청 (실제 URL로 변경 필요)
      await apiNotifier.getAsync('v1/ping');

      if (!context.mounted) return;

      // 성공 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API 테스트 성공!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!context.mounted) return;

      // 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('API 테스트 실패: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home4Screen extends ConsumerWidget {
  const Home4Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          '내 정보',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            // 프로필 섹션
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              // 나중에 에셋 이미지로 교체될 부분
            ),
            SizedBox(height: 20.h),
            // 사용자 정보
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Row(
                children: [
                  Text(
                    '주솜님',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 20.sp,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Text(
                'memorycoll22@naver.com',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            // 메뉴 섹션
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildMenuItemWithArrow('리포트'),
                  _buildDivider(),
                  _buildMenuItem('투자 일정'),
                  _buildDivider(),
                  _buildMenuItem('문의하기'),
                  _buildDivider(),
                  _buildMenuItem('버전 정보'),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            // 로그아웃 버튼
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextButton(
                onPressed: () {
                  // 로그아웃 로직
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            fontFamily: 'Pretendard',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemWithArrow(String title) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Pretendard',
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 20.sp, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.h,
      margin: EdgeInsets.only(left: 20.w),
      color: Colors.grey.shade200,
    );
  }
}

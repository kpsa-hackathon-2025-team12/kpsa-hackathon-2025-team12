import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tomate/core/routes/route_provider.dart';

class Home4Screen extends ConsumerWidget {
  const Home4Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF5),
      appBar: AppBar(
        title: Text(
          '내 정보',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFFFFFF5),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 36),
            // 프로필 섹션
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/my.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              // 나중에 에셋 이미지로 교체될 부분
            ),
            SizedBox(height: 25),
            // 사용자 정보
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '주승현',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'tmdgus4475@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF666666)
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: Color(0xFF757575),
                  ),
                ],
              ),
            ),
            _buildDivider(),
            SizedBox(height: 30),
            // 메뉴 섹션
            Container(
              child: Column(
                children: [
                  _buildMenuItemWithArrow('리포트'),
                  _buildDivider(),
                  _buildMenuItem('푸시 알림'),
                  _buildDivider(),
                  _buildMenuItem('문의하기'),
                  _buildDivider(),
                  _buildMenuItem('버전 정보'),
                ],
              ),
            ),
            SizedBox(height: 40),
            // 로그아웃 버튼
          TextButton(
                onPressed: () {
                  // 로그아웃 로직
                  GoRouter.of(context).pushNamed(AppRoutes.splashScreen.name);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    color: Color(0xFFA5A5A5),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                )
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithArrow(String title) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 24,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        height: 1,
        color: Color(0xFFBCBCBC),
      ),
    );
  }
}

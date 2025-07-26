import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key, required this.tab});

  final String tab;

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  // 탭 인덱스와 라우트 이름 매핑
  int getCurrentIndex(String tab) {
    switch (tab) {
      case 'homeScreen':
      case 'home1Screen':
        return 0;
      case 'home2Screen':
        return 1;
      case 'windScreen':
        return 2; // 가운데 버튼
      case 'home3Screen':
        return 3;
      case 'home4Screen':
        return 4;
      default:
        return 0; // 기본값 설정
    }
  }

  // 탭 순서대로 라우트 이름 배열
  final List<String?> _tabs = [
    'homeScreen', // 인덱스 0 - 홈
    'home2Screen', // 인덱스 1 - 대화
    'windScreen', // 인덱스 2 - 호흡하기 (가운데)
    'home3Screen', // 인덱스 3 - 일기
    'home4Screen', // 인덱스 4 - 내 정보
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: const Color(0xFFCACACA),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
      ),

      child: BottomAppBar(
        elevation: 0.0,
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              _buildNavItem(
                index: 0,
                iconPath: 'assets/icons/home.png',
                label: '홈',
              ),
              _buildNavItem(
                index: 1,
                iconPath: 'assets/icons/chat.png',
                label: '대화',
              ),
              const SizedBox(width: 74), // 중앙 버튼 공간
              _buildNavItem(
                index: 3,
                iconPath: 'assets/icons/diary.png',
                activeIconPath: 'assets/icons/activeDiary.png',
                label: '일기',
                isDiary: true,
              ),
              _buildNavItem(
                index: 4,
                iconPath: 'assets/icons/mypage.png',
                label: '내 정보',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    String? activeIconPath,
    bool isDiary = false,
  }) {
    final isActive = getCurrentIndex(widget.tab) == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();

          final newTab = _tabs[index];
          if (newTab != null && newTab != widget.tab) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            context.goNamed(newTab);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isDiary && isActive && activeIconPath != null
                  ? activeIconPath
                  : iconPath,
              width: 28,
              height: 28,
              color: isDiary
                  ? null
                  : isActive
                  ? const Color(0xFFEB423D)
                  : const Color(0xFF989898),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? const Color(0xFFEB423D)
                    : const Color(0xFF989898),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

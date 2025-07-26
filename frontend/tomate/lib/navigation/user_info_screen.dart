import 'package:tomate/core/routes/route_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  bool _isAllFieldsFilled = false;
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_checkAllFields);
    _birthController.addListener(_checkAllFields);
    _genderController.addListener(_checkAllFields);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _checkAllFields() {
    setState(() {
      _isAllFieldsFilled = _nicknameController.text.isNotEmpty;
    });
  }

  bool _isValidNickname(String nickname) {
    // 특수문자 제외 (한글, 영문, 숫자만 허용)
    final RegExp validRegExp = RegExp(r'^[a-zA-Z0-9가-힣]+$');
    return validRegExp.hasMatch(nickname);
  }

  void _showGenderBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '성별을 선택해주세요',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                _genderOption('남자'),
                SizedBox(height: 12.0),
                _genderOption('여자'),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _genderOption(String gender) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _genderController.text = gender;
        });
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          gender,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _onNextPressed() {
    if (_isAllFieldsFilled) {
      // 닉네임 유효성 검사
      if (!_isValidNickname(_nicknameController.text)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('닉네임에는 특수문자를 사용할 수 없습니다.')));
        return;
      }

      // 생년월일 유효성 검사 (입력된 경우에만)
      if (_birthController.text.isNotEmpty &&
          _birthController.text.length != 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('생년월일은 6자리로 입력해주세요. (예: 960101)')),
        );
        return;
      }

      // 설문 소개 화면으로 이동
      GoRouter.of(context).goNamed(AppRoutes.surveyIntroScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFF5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 130.0),

                      // 제목
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '이 공간이 더 따뜻해지도록,\n',
                              style: TextStyle(
                                color: const Color(0xFF0B0B0B),
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '나만의 이야기',
                              style: TextStyle(
                                color: const Color(0xFF0B0B0B),
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: '를 담아볼까요?',
                              style: TextStyle(
                                color: const Color(0xFF0B0B0B),
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 70.0),

                      Text(
                        '앞으로 이렇게 부를게요.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      // 닉네임 입력 필드
                      _inputField(
                        controller: _nicknameController,
                        hintText: '닉네임 ( 특수문자 불가능 )',
                        inputFormatters: [
                     // 방법 3: 공백도 허용하려면
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\s]'))
                        ],
                      ),

                      SizedBox(height: 48.0),

                      Text(
                        '입력 시 맞춤 훈련에 도움이 돼요. (선택 가능)',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      // 생년월일 입력 필드
                      _inputField(
                        controller: _birthController,
                        hintText: '생년월일 ( ex: 960101 )',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                      ),

                      SizedBox(height: 18.0),

                      // 성별 입력 필드 (클릭 전용)
                      GestureDetector(
                        onTap: _showGenderBottomSheet,
                        child: _inputField(
                          controller: _genderController,
                          hintText: '성별',
                          enabled: false,
                        ),
                      ),

                      SizedBox(height: 100.0), // 버튼을 위한 여백
                    ],
                  ),
                ),
              ),
            ),

            // 다음으로 버튼 (하단 고정)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 46.0,
                child: ElevatedButton(
                  onPressed: _isAllFieldsFilled ? _onNextPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAllFieldsFilled
                        ? Color(0xFFEB423D)
                        : Color(0xFF9F9F9F),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.0),
                    ),
                  ),
                  child: Text(
                    '다음으로',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return Container(
      height: 45,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFF4E4E4E)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          enabled: enabled,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(fontSize: 15.0, color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4D4D4D),
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          ),
        ),
      ),
    );
  }
}

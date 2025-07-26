import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tomate/core/api/api_provider.dart';

// 메시지 데이터 모델
class ChatMessage {
  final String memberLogs;
  final int buttonType;
  final int idx;
  final int type; // 0: 사용자, 1: 시스템

  ChatMessage({
    required this.memberLogs,
    required this.buttonType,
    required this.idx,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      memberLogs: json['memberLogs'] ?? '',
      buttonType: json['buttonType'] ?? 0,
      idx: json['idx'] ?? 0,
      type: json['type'] ?? 0,
    );
  }
}

class Home2Screen extends ConsumerStatefulWidget {
  const Home2Screen({super.key});

  @override
  ConsumerState<Home2Screen> createState() => _Home2ScreenState();
}

class _Home2ScreenState extends ConsumerState<Home2Screen> {
  bool _isFirstButtonPressed = false;
  bool _isSecondButtonPressed = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  bool _showQuizButtons = false; // 퀴즈 버튼 표시 여부

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 새 채팅 시작
  void _startNewChat() {
    setState(() {
      _messages.clear();
      _showQuizButtons = false; // 퀴즈 버튼 숨기기
    });
    // 스크롤을 맨 위로 이동
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // 스크롤을 맨 아래로 이동
  void _scrollToBottom() {
    // 키보드가 완전히 올라온 후 한 번만 부드럽게 스크롤
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  // 메시지를 리스트에 추가하고 스크롤을 맨 아래로 이동
  void _addMessages(List<ChatMessage> newMessages) {
    setState(() {
      _messages.addAll(newMessages);
    });
    _scrollToBottom();
  }

  // API 응답 처리
  void _handleApiResponse(dynamic response) {
    if (response != null &&
        response.data != null &&
        response.data['data'] != null) {
      List<ChatMessage> newMessages = [];
      for (var messageData in response.data['data']) {
        newMessages.add(ChatMessage.fromJson(messageData));
      }
      _addMessages(newMessages);
    }
  }

  // 메시지 전송
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // 사용자 메시지를 먼저 추가
    _addMessages([
      ChatMessage(
        memberLogs: message,
        buttonType: 0,
        idx: DateTime.now().millisecondsSinceEpoch,
        type: 0, // 사용자 메시지
      ),
    ]);

    _messageController.clear();

    try {
      // API 호출 (실제 API 엔드포인트에 맞게 수정 필요)
      final response = await ref.read(apiProvider.notifier).postAsync(
        '/chat/message',
        {
          "message": message,
          "userId": "kko_3006418247",
          "llmModel": "gemini-2.0-flash",
        },
      );

      _handleApiResponse(response);
    } catch (e) {
      print('메시지 전송 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF5),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFCF5),
        elevation: 0,
        title: Text(
          '마토와 대화하기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu_outlined, size: 20),
            padding: EdgeInsets.zero,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                _startNewChat();
              },
              child: Icon(Icons.add_outlined, size: 22),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    // 기존 토마토 메시지 (항상 보이도록 유지)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          width: 215,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFEEE1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  '지금 마음에 가장 가까운 느낌을\n골라볼까요? 마토가 함께할게요!',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () async {
                                    final response = await ref
                                        .read(apiProvider.notifier)
                                        .postAsync('/chat/default', {
                                          "request": "0",
                                          "userId": "kko_4364192436",
                                          "llmModel": "gemini-2.0-flash",
                                        });

                                    print(response);
                                    _handleApiResponse(response);
                                  },
                                  onTapDown: (_) {
                                    setState(() {
                                      _isFirstButtonPressed = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _isFirstButtonPressed = false;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _isFirstButtonPressed = false;
                                    });
                                  },
                                  child: AnimatedScale(
                                    scale: _isFirstButtonPressed ? 0.95 : 1.0,
                                    duration: Duration(milliseconds: 100),
                                    child: Container(
                                      height: 61,
                                      decoration: ShapeDecoration(
                                        color: _isFirstButtonPressed
                                            ? const Color(0xFFF5F5F5)
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1,
                                            color: _isFirstButtonPressed
                                                ? const Color(0xFFEB423D)
                                                : const Color(0xFF4D4D4D),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '이야기가 하고 싶어요. \n',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '대화하면서 안정을 찾아보아요.',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF828282,
                                                  ),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' ',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF828282,
                                                  ),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () async {
                                    final response = await ref
                                        .read(apiProvider.notifier)
                                        .postAsync('/chat/default', {
                                          "request": "",
                                          "userId": "kko_4364192436",
                                          "llmModel": "gemini-2.0-flash",
                                        });

                                    print(response);
                                    _handleApiResponse(response);
                                    setState(() {
                                      _showQuizButtons = true; // 퀴즈 버튼 표시
                                    });
                                  },
                                  onTapDown: (_) {
                                    setState(() {
                                      _isSecondButtonPressed = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _isSecondButtonPressed = false;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _isSecondButtonPressed = false;
                                    });
                                  },
                                  child: AnimatedScale(
                                    scale: _isSecondButtonPressed ? 0.95 : 1.0,
                                    duration: Duration(milliseconds: 100),
                                    child: Container(
                                      height: 61,
                                      decoration: ShapeDecoration(
                                        color: _isSecondButtonPressed
                                            ? const Color(0xFFF5F5F5)
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 1,
                                            color: _isSecondButtonPressed
                                                ? const Color(0xFFEB423D)
                                                : const Color(0xFF4D4D4D),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '생각 전환을 하고 싶어요. \n',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '마토와 집중해서 퀴즈를 풀어봐요!',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF828282,
                                                  ),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          left: 0,
                          child: Image.asset(
                            'assets/icons/mini_tomate.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),

                    // 채팅 메시지 리스트
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildChatMessage(message);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 하단 채팅 입력창
            Transform.translate(
              offset: Offset(0, keyboardHeight > 0 ? 50 : 0),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  26,
                  16,
                  26,
                  keyboardHeight > 0 ? 0 : 48,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFCBCBCB),
                            ),
                            borderRadius: BorderRadius.circular(29),
                          ),
                        ),
                        child: TextField(
                          controller: _messageController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: '마토랑 의사소통을 해봐요:)',
                            hintStyle: TextStyle(
                              color: Color(0xFFCBCBCB),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          style: TextStyle(fontSize: 14),
                          onTap: () {
                            // 입력창 클릭 시 스크롤을 맨 아래로 이동
                            _scrollToBottom();
                          },
                          onSubmitted: (text) => _sendMessage(text),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFE6E6E6),
                        shape: OvalBorder(),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              _sendMessage(_messageController.text),
                          icon: Center(
                            child: Icon(
                              Icons.arrow_upward_outlined,
                              color: Color(0xFF989898),
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 채팅 메시지 위젯 빌더
  Widget _buildChatMessage(ChatMessage message) {
    final isUser = message.type == 0;

    if (isUser) {
      // 사용자 메시지 (기존 방식 유지)
      return Container(
        margin: EdgeInsets.only(bottom: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: const Color(0xFFE0E0E0), width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                ),
                child: Text(
                  message.memberLogs,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      );
    } else {
      // 시스템 메시지 (토마토 아이콘 겹치기)
      return Container(
        margin: EdgeInsets.only(bottom: 22),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              padding: EdgeInsets.fromLTRB(19, 16, 19, 0),
              decoration: ShapeDecoration(
                color: const Color(0xFFFFEEE1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.memberLogs,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // 퀴즈 버튼들 (마지막 시스템 메시지이고 _showQuizButtons가 true일 때만 표시)
                  if (_showQuizButtons &&
                      _messages.isNotEmpty &&
                      _messages.last == message) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuizButton('한 번 더'),
                        SizedBox(width: 8),
                        _buildQuizButton('이제 그만'),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ],
              ),
            ),
            Positioned(
              top: -4,
              left: 0,
              child: Image.asset(
                'assets/icons/mini_tomate.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      );
    }
  }

  // 사이드 드로어 빌더
  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.6,
      backgroundColor: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          // 상단 여백
          SizedBox(height: 60),

          // 메뉴 항목들
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.edit_outlined, '새 채팅'),
                _buildDrawerItem(Icons.search_outlined, '채팅 검색'),
                _buildDrawerItem(Icons.library_books_outlined, 'AI 모델 변경'),

                SizedBox(height: 20),

                _buildDrawerItem(Icons.chat_outlined, '이야기가 하고 싶어요.'),
                _buildDrawerItem(Icons.chat_outlined, '싶어요.'),
                _buildDrawerItem(Icons.chat_outlined, '나의 감정을 컨트롤 하기 힘들어.'),
                _buildDrawerItem(Icons.chat_outlined, '오늘 많이 힘들었어..'),

                SizedBox(height: 20),

                _buildDrawerItem(Icons.chat_outlined, '난 대표님만 보면 숨이 막혀..'),
                _buildDrawerItem(
                  Icons.chat_outlined,
                  '열심히 해도 왜 월급은 쥐 꼴만 할까..??',
                ),
              ],
            ),
          ),

          // 하단 계정 정보
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '주승현',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '2Level',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // 드로어 메뉴 아이템 빌더
  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // 각 메뉴별 기능 추가 가능
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 2),
    );
  }

  // 퀴즈 버튼 빌더
  Widget _buildQuizButton(String text) {
    return GestureDetector(
      onTap: () {
        // 버튼 클릭 시 퀴즈 버튼 숨기기
        setState(() {
          _showQuizButtons = false;
        });
        // 추가 기능 구현 가능
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF4D4D4D), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

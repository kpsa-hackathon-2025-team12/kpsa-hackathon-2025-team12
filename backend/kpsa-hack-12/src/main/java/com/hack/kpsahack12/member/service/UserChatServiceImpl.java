package com.hack.kpsahack12.member.service;

import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.exception.CustomException;
import com.hack.kpsahack12.model.dto.LlmChatRequestDto;
import com.hack.kpsahack12.model.dto.LlmChatResponseDto;
import com.hack.kpsahack12.model.dto.UserChatRequestDto;
import com.hack.kpsahack12.model.dto.UserChatResponseDto;
import com.hack.kpsahack12.model.entity.member.MemberLlmData;
import com.hack.kpsahack12.model.entity.member.Members;
import com.hack.kpsahack12.model.repository.MemberLlmDataRepository;
import com.hack.kpsahack12.model.repository.MembersRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserChatServiceImpl implements UserChatService {

    private final GeminiWebClientService geminiWebClientService;
    private final MembersRepository membersRepository;
    private final MemberLlmDataRepository memberLlmDataRepository;
    
    // Default
    @Override
    public Mono<ResponseEntity<Map<String, Object>>> getchattingdefault(UserChatRequestDto userChatRequestDto) {
        // 1. 사용자 요청을 DB에 저장 (type=0, 요청)

        MemberLlmData requestLog = saveChatLog(userChatRequestDto.getUserId(), userChatRequestDto.getRequest(), 0, 0);

        LlmChatRequestDto llmChatRequestDto = new LlmChatRequestDto(userChatRequestDto,
                "공황발작 실전 대응'에 특화된 감정 지원 챗봇이야." +
                        " 사용자가 심한 불안이나 공황 증상을 호소할 경우, 감성적 위로보다 객관적 생리 지식과 실전 대처법 중심으로 짧고 정확하게 안내해줘." +
                        " 사용자 대부분은 지금 말도 하기 어려울 정도의 과호흡·감각 저하 상태일 수 있으므로, 불필요한 질문이나 감정 확인은 생략하고 바로 대처법 중심으로 응답해줘 ." +
                        "상대방에게 편안한 느낌을 줄 수 있게 반말 해줘." +
                        " 사용자의 감사표현, 인사, 일상적인 감정교류와 같은 표현들과 `이야기가 하고 싶어요.` 같은 문장에서는 대해서는 긍정적이고 언제나 반겨주는 친구처럼 화답해줘. " +
                        " 공황과 관련없는 이야기나 사용자의 현재 불안/공황 상태와 연관된 질문이나 입력값이 아니라면 response 1" +
                        "response1 : '나는 너의 불안 조절을 돕기위한 마토야. 감정이나 불안과 무관한 질문에는 대답할 수 없어. 내가 필요할 때 다시 불러줘!' ");

        // 2. LLM에 요청 전송 및 응답 받기
        return geminiWebClientService.getChatCompletion(llmChatRequestDto)
                .map(llmResponse -> {
                    // 3. LLM 응답을 DB에 저장 (type=1, 응답)
                    String response = llmResponse.getLlmResponse();
                    MemberLlmData responseLog = saveChatLog(userChatRequestDto.getUserId(), response, 1, 0);

                    // 4. 사용자의 모든 채팅 내역 조회
                    List<MemberLlmData> allUserChats = memberLlmDataRepository.findByMemberIdAndButtonTypeOrderByIdxAsc(userChatRequestDto.getUserId(), 0);

                    // 5. 원하는 형식으로 응답 데이터 구성
                    Map<String, Object> result = new HashMap<>();
                    Map<String, Object> status = new HashMap<>();
                    status.put("code", 200);
                    status.put("message", "success");

                    List<Map<String, Object>> dataList = new ArrayList<>();

                    // 모든 채팅 내역을 추가
                    for (MemberLlmData chat : allUserChats) {
                        Map<String, Object> chatData = new HashMap<>();
                        chatData.put("idx", chat.getIdx());
                        chatData.put("type", chat.getType());
                        chatData.put("memberLogs", chat.getMemberLogs());
                        chatData.put("buttonType", chat.getButtonType());

                        dataList.add(chatData);
                    }

                    // 최종 결과 구성
                    result.put("status", status);
                    result.put("data", dataList);

                    return ResponseEntity.ok(result);
                });
    }

    private MemberLlmData saveChatLog(String userId, String message, int type, int buttonType) {
        try {
            // 회원 정보 조회
            Optional<Members> memberOpt = membersRepository.findById(userId);

            if (memberOpt.isPresent()) {
                Members member = memberOpt.get();

                // 로그 객체 생성 및 저장
                MemberLlmData chatLog = MemberLlmData.builder()
                        .member(member)
                        .type(type)
                        .memberLogs(message)
                        .buttonType(buttonType)
                        .build();

                return memberLlmDataRepository.save(chatLog);
            } else {
                // 회원 정보가 없을 경우 로그 출력
                log.error("사용자 ID가 존재하지 않습니다: " + userId);
                throw new CustomException( ErrorCode.SERVER_ERROR ,"사용자 ID가 존재하지 않습니다: " + userId);
            }
        } catch (Exception e) {
            // 저장 실패 시 로그 출력 (실제 환경에서는 적절한 로깅 프레임워크 사용 권장)
            log.error("채팅 로그 저장 실패: " + e.getMessage());
            throw new CustomException(ErrorCode.SERVER_ERROR , "채팅 로그 저장 실패: " + e.getMessage());
        }
    }



    @Override
    public Mono<ResponseEntity<Map<String, Object>>> getchattingOneComment(UserChatRequestDto userChatRequestDto) {
        // 1. 사용자 요청을 DB에 저장 (type=0, 요청)
        MemberLlmData requestLog = saveChatLog(userChatRequestDto.getUserId(), userChatRequestDto.getRequest(), 0, 1);

        LlmChatRequestDto llmChatRequestDto = new LlmChatRequestDto(userChatRequestDto,
                "너는 아래에 6개의 대답 response1 ~ response6 까지 랜덤으로 대답 할 수 있어. " +
                        " 대신 response1: ~ response6: 이 단어는 빼고 뒷 문장만," +
                        "response1: 그래, 딴 생각 해보자! 빨간 과일 다섯 개 떠올릴 수 있어?." +
                        "response2:지금 이 순간 눈에 보이는 파란색 물건 3개를 찾아봐!," +
                        "response3:좋아! 그럼 머릿속으로 날개달린 바나나를 상상해볼래?," +
                        "response4:손끝으로 지금 만지고 있는 물건의 재질을 설명해볼래?," +
                        "response5:지금 들리는 소리 3가지를 조용히 들어볼까?," +
                        "response6:조금 어렵겠지만... 13의 배수 3개만 말해볼래?, ");

        // 2. LLM에 요청 전송 및 응답 받기
        return geminiWebClientService.getChatCompletion(llmChatRequestDto)
                .map(llmResponse -> {
                    // 3. LLM 응답을 DB에 저장 (type=1, 응답)
                    String response = llmResponse.getLlmResponse();
                    MemberLlmData responseLog = saveChatLog(userChatRequestDto.getUserId(), response, 1, 1);

                    // 4. 사용자의 모든 채팅 내역 조회 (기존 메서드 사용)
                    List<MemberLlmData> allUserChats = memberLlmDataRepository.findByMemberIdAndButtonTypeOrderByIdxAsc(userChatRequestDto.getUserId(), 1);

                    // 5. 원하는 형식으로 응답 데이터 구성
                    Map<String, Object> result = new HashMap<>();
                    Map<String, Object> status = new HashMap<>();
                    status.put("code", 200);
                    status.put("message", "success");

                    List<Map<String, Object>> dataList = new ArrayList<>();

                    // 모든 채팅 내역을 추가
                    for (MemberLlmData chat : allUserChats) {
                        Map<String, Object> chatData = new HashMap<>();
                        chatData.put("idx", chat.getIdx());
                        chatData.put("type", chat.getType());
                        chatData.put("memberLogs", chat.getMemberLogs());
                        chatData.put("buttonType", chat.getButtonType());

                        dataList.add(chatData);
                    }

                    // 최종 결과 구성
                    result.put("status", status);
                    result.put("data", dataList);

                    return ResponseEntity.ok(result);
                });
    }



}

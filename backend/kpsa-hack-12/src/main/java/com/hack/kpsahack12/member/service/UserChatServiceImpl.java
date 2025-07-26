package com.hack.kpsahack12.member.service;

import com.hack.kpsahack12.model.dto.LlmChatRequestDto;
import com.hack.kpsahack12.model.dto.LlmChatResponseDto;
import com.hack.kpsahack12.model.dto.UserChatRequestDto;
import com.hack.kpsahack12.model.dto.UserChatResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class UserChatServiceImpl implements UserChatService {

    private final GeminiWebClientService geminiWebClientService;

    // Default
    @Override
    public Mono<UserChatResponseDto> getchattingdefault(UserChatRequestDto userChatRequestDto) {
        LlmChatRequestDto llmChatRequestDto = new LlmChatRequestDto(userChatRequestDto,
                "공황발작 실전 대응’에 특화된 감정 지원 챗봇이야." +
                " 사용자가 심한 불안이나 공황 증상을 호소할 경우, 감성적 위로보다 객관적 생리 지식과 실전 대처법 중심으로 짧고 정확하게 안내해줘." +
                " 사용자 대부분은 지금 말도 하기 어려울 정도의 과호흡·감각 저하 상태일 수 있으므로, 불필요한 질문이나 감정 확인은 생략하고 바로 대처법 중심으로 응답해줘 ." +
                "상대방에게 편안한 느낌을 줄 수 있게 반말 해줘." +
                " 사용자의 감사표현, 인사, 일상적인 감정교류와 같은 표현들에 대해서는 긍정적이고 언제나 반겨주는 친구처럼 화답해줘. " +
                " 공황과 관련없는 이야기나 사용자의 현재 불안/공황 상태와 연관된 질문이나 입력값이 아니라면 response 1" +
                "response1 : '나는 너의 불안 조절을 돕기위한 마토야. 감정이나 불안과 무관한 질문에는 대답할 수 없어. 내가 필요할 때 다시 불러줘!' ");
        Mono<LlmChatResponseDto> chatCompletionMono = geminiWebClientService.getChatCompletion(llmChatRequestDto);
        return chatCompletionMono.map(UserChatResponseDto::new);
    }

    @Override
    public Mono<UserChatResponseDto> getchattingOneComment(UserChatRequestDto userChatRequestDto) {
        LlmChatRequestDto llmChatRequestDto = new LlmChatRequestDto(userChatRequestDto,
                "너가 대답 할 수 있는건 두개야 YES OR NO");
        Mono<LlmChatResponseDto> chatCompletionMono = geminiWebClientService.getChatCompletion(llmChatRequestDto);
        return chatCompletionMono.map(UserChatResponseDto::new);
    }


}

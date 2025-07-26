package com.hack.kpsahack12.member.controller;
import com.hack.kpsahack12.model.dto.UserChatRequestDto;
import com.hack.kpsahack12.model.dto.UserChatResponseDto;
import com.hack.kpsahack12.member.service.UserChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
@Tag(name = "LLM Chat", description = "Gemmini LLM 채팅 기능 구현 ")
public class UserChatController {

    private final UserChatService userChatService;


    @Operation(
            summary = "잼민이랑 대화 하기",
            description = "프롬프트 현재 - 존댓말 하지 않고 대답 잘하기 -. llmModel 은 NULL able"
    )

    @PostMapping("/default")
    public Mono<UserChatResponseDto> getchattingdefault(@RequestBody UserChatRequestDto userChatRequestDto) {
        return userChatService.getchattingdefault(userChatRequestDto);
    }

    @PostMapping("/prompt")
    public Mono<UserChatResponseDto> chattingOneComment(@RequestBody UserChatRequestDto userChatRequestDto) {
        return userChatService.getchattingOneComment(userChatRequestDto);
    }
}

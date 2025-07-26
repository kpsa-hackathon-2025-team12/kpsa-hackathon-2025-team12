package com.hack.kpsahack12.member.controller;
import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.enums.ResponseCode;
import com.hack.kpsahack12.model.dto.UserChatRequestDto;
import com.hack.kpsahack12.model.dto.UserChatResponseDto;
import com.hack.kpsahack12.member.service.UserChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

import java.util.Map;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
@Tag(name = "LLM Chat", description = "Gemmini LLM 채팅 기능 구현 ")
@Slf4j
public class UserChatController {

    private final UserChatService userChatService;

    @PostMapping("/truncate")
    public ApiResponseV2<?> truncate(){
        userChatService.truncate();
        return ApiResponseV2.success(ResponseCode.SUCCESS);
    }

    @Operation(
            summary = "잼민이랑 대화 하기",
            description = "프롬프트 현재 - 존댓말 하지 않고 대답 잘하기 -. llmModel 은 NULL able"
    )

    @PostMapping("/default")
    public Mono<ResponseEntity<Map<String, Object>>> getchattingdefault(@RequestBody UserChatRequestDto userChatRequestDto) {

        if(userChatRequestDto.getRequest().equals("0")){
            userChatRequestDto.setRequest("이야기가 하고 싶어요.");
        }

        return userChatService.getchattingdefault(userChatRequestDto);
    }

    @PostMapping("/prompt")
    public Mono<ResponseEntity<Map<String, Object>>> chattingOneComment(@RequestBody UserChatRequestDto userChatRequestDto) {

        log.info("====== chattingOneComment ====== : {} ", userChatRequestDto.getRequest());

        if(userChatRequestDto.getRequest().equals("1") || userChatRequestDto.getRequest().equals("１")){
            userChatRequestDto.setRequest("생각 전환을 하고 싶어요.");
        }


        return userChatService.getchattingOneComment(userChatRequestDto);
    }
}

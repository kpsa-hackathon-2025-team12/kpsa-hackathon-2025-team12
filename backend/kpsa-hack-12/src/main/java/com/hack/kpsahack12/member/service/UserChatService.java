package com.hack.kpsahack12.member.service;

import com.hack.kpsahack12.model.dto.UserChatRequestDto;
import com.hack.kpsahack12.model.dto.UserChatResponseDto;
import org.springframework.http.ResponseEntity;
import reactor.core.publisher.Mono;

import java.util.Map;

public interface UserChatService {
    Mono<ResponseEntity<Map<String, Object>>> getchattingOneComment(UserChatRequestDto userChatRequestDto);
    Mono<ResponseEntity<Map<String, Object>>> getchattingdefault(UserChatRequestDto userChatRequestDto);
}

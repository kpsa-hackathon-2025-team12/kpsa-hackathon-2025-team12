package com.hack.kpsahack12.member.service;

import com.hack.kpsahack12.model.dto.UserChatRequestDto;
import com.hack.kpsahack12.model.dto.UserChatResponseDto;
import reactor.core.publisher.Mono;

public interface UserChatService {
    Mono<UserChatResponseDto> getchattingOneComment(UserChatRequestDto userChatRequestDto);
}

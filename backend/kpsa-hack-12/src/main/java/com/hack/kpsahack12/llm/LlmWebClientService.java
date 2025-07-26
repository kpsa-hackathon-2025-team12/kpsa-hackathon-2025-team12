package com.hack.kpsahack12.llm;

import com.hack.kpsahack12.enums.LlmType;
import com.hack.kpsahack12.model.dto.LlmChatRequestDto;
import com.hack.kpsahack12.model.dto.LlmChatResponseDto;
import reactor.core.publisher.Mono;

public interface LlmWebClientService {
    Mono<LlmChatResponseDto> getChatCompletion(LlmChatRequestDto requestDto);

    LlmType getLlmType();
}

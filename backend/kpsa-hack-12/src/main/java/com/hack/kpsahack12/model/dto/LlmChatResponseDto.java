package com.hack.kpsahack12.model.dto;

import com.hack.kpsahack12.llm.gemini.response.GeminiChatResponseDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class LlmChatResponseDto {
    private String llmResponse;

    public LlmChatResponseDto(GeminiChatResponseDto geminiChatResponseDto) {
        this.llmResponse = geminiChatResponseDto.getSingleText();
    }
}

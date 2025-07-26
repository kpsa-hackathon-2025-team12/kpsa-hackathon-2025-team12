package com.hack.kpsahack12.llm.gemini.request;

import com.hack.kpsahack12.llm.gemini.GeminiMessageRole;
import com.hack.kpsahack12.llm.gemini.response.GeminiContent;
import com.hack.kpsahack12.llm.gemini.response.GeminiPart;
import com.hack.kpsahack12.model.dto.LlmChatRequestDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class GeminiChatRequestDto{

    private List<GeminiContent> contents;
    private GeminiContent systemInstruction;
    private GeminiGenerationConfigDto generationConfig;

    public GeminiChatRequestDto(LlmChatRequestDto llmChatRequestDto) {
        if (llmChatRequestDto.isUseJson()) {
            this.generationConfig = new GeminiGenerationConfigDto();
        }
        this.contents = List.of(new GeminiContent(List.of(new GeminiPart(llmChatRequestDto.getUserRequest())), GeminiMessageRole.USER));

        if (llmChatRequestDto.getSystemPrompt() != null && !llmChatRequestDto.getSystemPrompt().isEmpty()) {
            this.systemInstruction = new GeminiContent(List.of(new GeminiPart(llmChatRequestDto.getSystemPrompt())));
        }
    }

}

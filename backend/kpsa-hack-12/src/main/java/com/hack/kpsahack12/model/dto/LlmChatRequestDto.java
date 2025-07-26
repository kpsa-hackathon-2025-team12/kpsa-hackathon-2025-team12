package com.hack.kpsahack12.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class LlmChatRequestDto {

    private String userRequest;

    private String systemPrompt;
    private boolean useJson;
    private LlmModel llmModel;

    public LlmChatRequestDto(UserChatRequestDto userChatRequestDto, String systemPrompt) {
        this.llmModel = userChatRequestDto.getLlmModel();
        this.systemPrompt = systemPrompt;
        this.userRequest = userChatRequestDto.getRequest();
    }
}

package com.hack.kpsahack12.model.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserChatRequestDto{

    private String request;
    private LlmModel llmModel;
}

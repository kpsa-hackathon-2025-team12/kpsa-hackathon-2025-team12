package com.hack.kpsahack12.llm.gemini.request;

import com.hack.kpsahack12.llm.gemini.GeminiMessageRole;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class GeminiCompletionRequestDto{

    private GeminiMessageRole role; //
    private String content; //채팅 내용

    public GeminiCompletionRequestDto(String content) {

        this.content = content;
    }
}

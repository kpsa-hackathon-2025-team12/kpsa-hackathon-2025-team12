package com.hack.kpsahack12.llm.gemini.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


@AllArgsConstructor
@Getter
@Setter
public class GeminiGenerationConfigDto {

    private String responseMimeType;

    public GeminiGenerationConfigDto () {

        this.responseMimeType = "application/json";
    }
}

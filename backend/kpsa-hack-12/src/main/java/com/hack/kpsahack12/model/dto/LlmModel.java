package com.hack.kpsahack12.model.dto;

import com.fasterxml.jackson.annotation.JsonValue;
import com.hack.kpsahack12.enums.LlmType;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum LlmModel {
    GEMINI_2_0_FLASH("gemini-2.0-flash", LlmType.GEMINI)
    ;

    private final String code;
    private final LlmType llmType;

    @JsonValue
    @Override
    public String toString() {
        return code;
    }
}

package com.hack.kpsahack12.llm.gemini;

import com.fasterxml.jackson.annotation.JsonValue;

public enum GeminiMessageRole {
    USER,
    MODEL
    ;

    @JsonValue
    @Override
    public String toString() {

        return name().toLowerCase();
    }
}

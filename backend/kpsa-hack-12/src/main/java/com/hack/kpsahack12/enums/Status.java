package com.hack.kpsahack12.enums;

import lombok.Getter;

@Getter
public enum Status {
    LOGIN("LOGIN", "로그인");

    private final String code;
    private final String message;

    Status(String code, String message) {
        this.code = code;
        this.message = message;
    }
}

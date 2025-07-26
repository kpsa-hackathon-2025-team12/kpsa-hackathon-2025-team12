package com.hack.kpsahack12.enums;

import lombok.Getter;

@Getter
public enum Status {
    REGISTER("REGISTER", "등록");

    private final String code;
    private final String message;

    Status(String code, String message) {
        this.code = code;
        this.message = message;
    }
}

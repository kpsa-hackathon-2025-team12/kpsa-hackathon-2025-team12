package com.hack.kpsahack12.enums;

import lombok.Getter;

@Getter
public enum ResponseCode {
    SUCCESS(200, "SUCCESS");

    private final int code;
    private final String message;

    ResponseCode(int code, String message) {
        this.code = code;
        this.message = message;
    }
}

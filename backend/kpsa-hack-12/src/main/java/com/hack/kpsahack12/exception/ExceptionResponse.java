package com.hack.kpsahack12.exception;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.hack.kpsahack12.enums.ErrorCode;
import lombok.Getter;

@Getter
public class ExceptionResponse {

    @JsonProperty("errorCode")
    private final String errorCode;

    private final String message;

    public ExceptionResponse(ErrorCode errorCode, String message) {
        this.errorCode = String.valueOf(errorCode.getErrorCode()); // 코드 값을 문자열로 변환
        this.message = message;
    }
}

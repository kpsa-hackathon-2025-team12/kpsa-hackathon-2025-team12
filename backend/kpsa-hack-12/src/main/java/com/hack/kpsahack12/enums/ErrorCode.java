package com.hack.kpsahack12.enums;

import lombok.Getter;
import org.springframework.http.HttpStatus;


@Getter
public enum ErrorCode {
    SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR,-999, "API 사용중 ERROR 발생"),
    NOT_FOUND_USER_NAME(HttpStatus.BAD_REQUEST,-101,"사용자를 찾을 수 없습니다"),

    //OAuth2
    NOT_FOUND_OAUTH_PROVIDER(HttpStatus.BAD_REQUEST,-201,"잘못된 인가 정보 입니다."),

    FAILED_TO_CALL_CLIENT(HttpStatus.BAD_GATEWAY,-301, "HTTP CALL FAILED"),
    CALL_REQUEST_BODY_NULL(HttpStatus.BAD_REQUEST,-302,"HTTP CALL REQEUST BODY NULL" ),

    // FCM
    DURING_SEND_TO_FCM_ERROR(HttpStatus.BAD_REQUEST,-303,"FCM 알림 발송 중 에러 발생")
    ;

    private final HttpStatus httpStatus;
    private final int ErrorCode;
    private final String message;

    ErrorCode(HttpStatus httpStatus, int errorCode, String message) {

        ErrorCode = errorCode;
        this.httpStatus = httpStatus;
        this.message = message;
    }
}

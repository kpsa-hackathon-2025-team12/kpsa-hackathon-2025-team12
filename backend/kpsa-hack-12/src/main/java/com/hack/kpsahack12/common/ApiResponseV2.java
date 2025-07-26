package com.hack.kpsahack12.common;

import com.hack.kpsahack12.enums.ResponseCode;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ApiResponseV2<T> {
    private Status status;
    private T data;

    @Getter
    @Builder
    public static class Status {
        private int code;
        private String message;
    }


    public static <T> ApiResponseV2<T> success(T data) { // 기본 디폴트값
            return success(ResponseCode.SUCCESS , data);
    }

    // 성공 응답 생성
    public static <T> ApiResponseV2<T> success(ResponseCode status, T data) {
        return ApiResponseV2.<T>builder()
                .status(Status.builder()
                        .code(status.getCode())
                        .message(status.getMessage())
                        .build())
                .data(data)
                .build();
    }


}
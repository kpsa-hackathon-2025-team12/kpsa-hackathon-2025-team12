package com.hack.kpsahack12.common;

import com.hack.kpsahack12.enums.ErrorCode;
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

    // 실패 응답 생성
    public static <T> ApiResponseV2<T> error(ErrorCode errorCode) {
        return error(errorCode, null);
    }

    public static <T> ApiResponseV2<T> errorResponse(ErrorCode errorCode, T data) {
        return error(errorCode, data);
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

    public static <T> ApiResponseV2<T> error(ErrorCode errorCode, T data) {
        return ApiResponseV2.<T>builder()
                .status(Status.builder()
                        .code(errorCode.getErrorCode())
                        .message(errorCode.getMessage())
                        .build())
                .data(data)
                .build();
    }



}
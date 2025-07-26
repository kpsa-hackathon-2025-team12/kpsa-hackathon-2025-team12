package com.hack.kpsahack12.exception;

import com.hack.kpsahack12.common.ApiResponseV2;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
@Component
@RequiredArgsConstructor
@Slf4j
public class CustomExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<ApiResponseV2<Object>> handleCustomException(CustomException e) {
        log.error("EXCEPTION : {}", e.getMessage());

        ApiResponseV2<Object> errorResponse = ApiResponseV2.error(e.getErrorCode());

        return ResponseEntity
                .status(e.getErrorCode().getHttpStatus())
                .body(errorResponse);
    }



}

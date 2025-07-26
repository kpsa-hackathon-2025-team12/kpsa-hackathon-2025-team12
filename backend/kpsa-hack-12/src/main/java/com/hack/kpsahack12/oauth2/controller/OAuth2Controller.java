package com.hack.kpsahack12.oauth2.controller;


import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.exception.CustomException;
import com.hack.kpsahack12.oauth2.service.auth.KakaoAuthService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/oauth2")
@RequiredArgsConstructor
@Slf4j
public class OAuth2Controller {

    private final KakaoAuthService kakaoAuthService;

    @GetMapping("/login/kakao")
    public ApiResponseV2<?> kakaoLogin() {

        try {
            log.info("kakao login");
            return ApiResponseV2.success(kakaoAuthService.getPermissionCodeUrl());
        }catch (Exception e){
            throw new CustomException(ErrorCode.NOT_FOUND_OAUTH_PROVIDER);
        }
    }

    @GetMapping("/login/naver")
    public ApiResponseV2<?> NaverLogin() {
        log.info("naver login");
        return ApiResponseV2.success("");
    }
}

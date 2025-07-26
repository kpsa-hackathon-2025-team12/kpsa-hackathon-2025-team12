package com.hack.kpsahack12.oauth2.controller;


import com.hack.kpsahack12.common.ApiResponseV2;
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

    @GetMapping("/login/kakao")
    public ApiResponseV2<?> kakaoLogin() throws IOException {
        log.info("kakao login");
        return ApiResponseV2.success("");
    }

    @GetMapping("/login/naver")
    public ApiResponseV2<?> NaverLogin() throws IOException {
        log.info("naver login");
        return ApiResponseV2.success("");
    }
}

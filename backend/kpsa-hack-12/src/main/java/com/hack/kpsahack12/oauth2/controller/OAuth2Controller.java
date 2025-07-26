package com.hack.kpsahack12.oauth2.controller;


import com.hack.kpsahack12.common.ApiResponseV2;
import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.exception.CustomException;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2TokenResponse;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2UserResponse;
import com.hack.kpsahack12.oauth2.service.auth.KakaoAuthService;
import com.hack.kpsahack12.oauth2.service.auth.NaverAuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/oauth2")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "OAuth2", description = "OAuth2 로그인 관리 현재 카카오 로그인 구현")
public class OAuth2Controller {

    private final KakaoAuthService kakaoAuthService;
    private final NaverAuthService naverAuthService;

    @GetMapping("/callback/naver")
    public void callbackNaver(@RequestParam String code, @RequestParam String state, HttpServletRequest request, HttpServletResponse response) throws IOException {

        log.info("code : {}, state : {}", code, state);

        OAuth2TokenResponse oAuth2TokenResponse = naverAuthService.getAccessToken(code);
        log.info("네이버 콜백 인가 함수 호출");

        OAuth2UserResponse userInfo = naverAuthService.getUserInfo(oAuth2TokenResponse.getAccessToken());
        log.info("user Info : {}", userInfo);

        HttpSession session = request.getSession(true);
        session.setAttribute("token", "TEST API TOKEN");
        session.setAttribute("user", "dev_naver"  + userInfo.getId()); // 사용자 식별자도 저장

        log.info("네이버 로그인 성공: 세션 ID = {}", session.getId());

        log.info("네이버 로그인 성공: 세션 token = {}", session.getAttribute("token"));
        log.info("세션 속성: user = {}", session.getAttribute("user"));

        response.sendRedirect("https://google.com");
    }



    @Operation(
            summary = "카카오 로그인 콜백 처리",
            description = "카카오 인증 완료 후 콜백을 처리 현재 프론트 URL 몰라서.. ㅎㅎ NAVER 로",
            parameters = {
                    @Parameter(name = "code", description = "카카오 인증 코드", required = true)
            }
    )
    @GetMapping("/callback/kakao")
    public void kakaoCallback(@RequestParam(required = false) String code, HttpServletRequest request, HttpServletResponse response) throws IOException {

        OAuth2TokenResponse oAuth2TokenResponse = kakaoAuthService.getAccessToken(code);
        log.info("카카오 콜백 인가 함수 호출");

        OAuth2UserResponse userInfo = kakaoAuthService.getUserInfo(oAuth2TokenResponse.getAccessToken());
        log.info("user Info : {}", userInfo);

        // TODO DB 저장 userID
//        HttpSession session = request.getSession(true);
//        session.setAttribute("token", "TEST API TOKEN");
//        session.setAttribute("user", "dev_kakao"  + userInfo.getId()); // 사용자 식별자도 저장
//
//        log.info("카카오 로그인 성공: 세션 ID = {}", session.getId());
//
//        log.info("카카오 로그인 성공: 세션 token = {}", session.getAttribute("token"));
//        log.info("세션 속성: user = {}", session.getAttribute("user"));

        response.sendRedirect("https://naver.com");

    }


    @Operation(
            summary = "카카오 로그인 Redirect URL 리턴",
            description = "카카오 로그인 버튼 클릭시 동의 화면 호출 URL",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "카카오 로그인 URL 반환 성공",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = ApiResponseV2.class)
                            )
                    )
            }
    )
    @GetMapping("/login/kakao")
    public ApiResponseV2<?> kakaoLogin() {

        try {
            log.info("kakao login");
            return ApiResponseV2.success(kakaoAuthService.getPermissionCodeUrl());
        }catch (Exception e){
            throw new CustomException(ErrorCode.NOT_FOUND_OAUTH_PROVIDER);
        }
    }
    @Operation(
            summary = "네이버 로그인 Redirect URL 리턴",
            description = "네이버 로그인 버튼 클릭시 동의 화면 호출 URL",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "네이버 로그인 URL 반환 성공",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = ApiResponseV2.class)
                            )
                    )
            }
    )
    @GetMapping("/login/naver")
    public ApiResponseV2<?> NaverLogin() {

        try{
            log.info("naver login");
            return ApiResponseV2.success("");
        }catch (Exception ex){
            throw new CustomException(ErrorCode.NOT_FOUND_OAUTH_PROVIDER);
        }
    }
}

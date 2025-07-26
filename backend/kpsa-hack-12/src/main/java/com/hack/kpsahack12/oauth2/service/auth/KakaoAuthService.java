package com.hack.kpsahack12.oauth2.service.auth;

import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2TokenResponse;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2UserResponse;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuthServiceInterface;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.IOException;


@Service
@RequiredArgsConstructor
@Slf4j
public class KakaoAuthService implements OAuthServiceInterface {

    @Override
    public String getProviderName() {

        return "";
    }

    @Override
    public String getPermissionCodeUrl() {

        return "";
    }

    @Override
    public OAuth2TokenResponse getAccessToken(String code) throws IOException {

        return null;
    }

    @Override
    public OAuth2UserResponse getUserInfo(String accessToken) {

        return null;
    }
}

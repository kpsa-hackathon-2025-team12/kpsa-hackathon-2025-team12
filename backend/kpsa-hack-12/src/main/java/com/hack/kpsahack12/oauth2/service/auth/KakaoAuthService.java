package com.hack.kpsahack12.oauth2.service.auth;

import com.hack.kpsahack12.common.CallClient;
import com.hack.kpsahack12.config.OAUth2.OAuth2Config;
import com.hack.kpsahack12.config.OAUth2.OAuth2ProviderValues;
import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.enums.Oauth2;
import com.hack.kpsahack12.exception.CustomException;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2TokenResponse;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2UserResponse;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuthServiceInterface;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Optional;


@Service
@RequiredArgsConstructor
@Slf4j
public class KakaoAuthService implements OAuthServiceInterface {


    private final OAuth2Config oAuth2Config;
    private OAuth2ProviderValues oAuthInfo;
    private final CallClient callClient;

    @PostConstruct
    public void init(

    ) {
        this.oAuthInfo = Optional.ofNullable(oAuth2Config.getProvider(Oauth2.KAKAO_OAUTH.getProvider()))
                .orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_OAUTH_PROVIDER));
    }


    @Override
    public String getProviderName() {
        return Oauth2.KAKAO_OAUTH.getProvider();
    }

    @Override
    public String getPermissionCodeUrl() {

        String clientId = oAuthInfo.getClientId();
        String redirectUri = oAuthInfo.getRedirectUri(); // 콜백 URL

        log.debug("clientId : {}, redirectUri : {}", clientId, redirectUri);

        String kakaoAuthUrl = oAuthInfo.getAuthUrl().getPermissionCode() +
                "?client_id=" + clientId +
                "&redirect_uri=" + redirectUri +
                "&response_type=code";

        log.debug("kakaoAuthUrl : {}", kakaoAuthUrl);

        return kakaoAuthUrl;
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

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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.Map;
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

        String clientId = oAuthInfo.getClientId();
        String clientSecret = oAuthInfo.getClientSecret();
        String redirectUri = oAuthInfo.getRedirectUri();

        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
        formData.add("grant_type", "authorization_code");
        formData.add("client_id", clientId);
        formData.add("redirect_uri", redirectUri);
        formData.add("client_secret", clientSecret);
        formData.add("code", code);

        Map<String, String> headers = Map.of("Content-Type", "application/x-www-form-urlencoded");

        String jsonString = callClient.POST(oAuthInfo.getAuthUrl().getAuthToken(), headers, formData);
        log.info("jsonString : {}", jsonString);

        // {
        // "access_token":"rVVeHz2GwqQl4aKkyI_NzgICu2R58qC6AAAAAQoNDSEAAAGXgdOiZMTTXs9KIG_V",
        // "token_type":"bearer",
        // "refresh_token":"QdA_AW_rbc1_caxOuBiSZ7LNr3lXbjkpAAAAAgoNDSEAAAGXgdOiW8TTXs9KIG_V",
        // "expires_in":21599,
        // "scope":"talk_message profile_nickname",
        // "refresh_token_expires_in":5183999
        // }


        return null;
    }

    @Override
    public OAuth2UserResponse getUserInfo(String accessToken) {

        return null;
    }
}

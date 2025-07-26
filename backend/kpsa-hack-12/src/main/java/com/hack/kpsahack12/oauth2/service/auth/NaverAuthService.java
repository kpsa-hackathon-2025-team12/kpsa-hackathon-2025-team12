package com.hack.kpsahack12.oauth2.service.auth;

import com.hack.kpsahack12.common.CallClient;
import com.hack.kpsahack12.common.JsonUtil;
import com.hack.kpsahack12.config.OAUth2.OAuth2Config;
import com.hack.kpsahack12.config.OAUth2.OAuth2ProviderValues;
import com.hack.kpsahack12.enums.ErrorCode;
import com.hack.kpsahack12.enums.Oauth2;
import com.hack.kpsahack12.exception.CustomException;
import com.hack.kpsahack12.model.naver.NaverTokenResponse;
import com.hack.kpsahack12.model.naver.NaverUserResponse;
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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class NaverAuthService implements OAuthServiceInterface {

    private final OAuth2Config oAuth2Config;
    private OAuth2ProviderValues oAuthInfo;
    private final String status = "NAVER_LOGIN_START";
    private final String requestStatus = "NAVER_LOGIN_END";
    private final CallClient callClient;

    @PostConstruct
    public void init() {
        this.oAuthInfo = Optional.ofNullable(oAuth2Config.getProvider(Oauth2.NAVER_OAUTH.getProvider()))
                .orElseThrow(() -> new CustomException(ErrorCode.NOT_FOUND_OAUTH_PROVIDER));
    }


    @Override
    public String getProviderName() { return Oauth2.NAVER_OAUTH.getProvider(); }

    @Override
    public String getPermissionCodeUrl() {

        String clientId = oAuthInfo.getClientId();
        String redirectUri = oAuthInfo.getRedirectUri(); // 콜백 URL

        log.debug("clientId : {}, redirectUri : {}", clientId, redirectUri);
        String state = URLEncoder.encode(status, StandardCharsets.UTF_8);
        log.debug("state : {}", state);
        String naverAuthUrl = oAuthInfo.getAuthUrl().getPermissionCode() +
                "?response_type=code" +
                "&client_id=" + clientId +
                "&state=" + state +
                "&redirect_uri=" + redirectUri;

        log.debug("naverAuthUrl : {}", naverAuthUrl);

        return naverAuthUrl;
    }


    @Override
    public OAuth2TokenResponse getAccessToken(String code) throws IOException {

        String clientId = oAuthInfo.getClientId();
        String clientSecret = oAuthInfo.getClientSecret();
        String redirectUri = oAuthInfo.getRedirectUri();
        String state = URLEncoder.encode(requestStatus, StandardCharsets.UTF_8);
        log.debug("state : {}", state);
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();

        formData.add("grant_type", "authorization_code");
        formData.add("client_id", clientId);
        formData.add("redirect_uri", redirectUri);
        formData.add("client_secret", clientSecret);
        formData.add("code", code);
        formData.add("state", state);

        Map<String, String> headers = Map.of("Content-Type", "application/x-www-form-urlencoded");

        // {
        // "access_token":"AAAANgBHyK8NkMIufivGl1HykshN3IimoJYM0OiYkZtDCQFxmt6bG0dY9WXvak4H0fIXQRr8cr3phl7WZ4c0iS7IAuc",
        // "refresh_token":"oHBTD1XRnQQcPczYNkMaSKxiiaLs9SGyNIY5mwnSdl3mE2de3iskXyyRipKXucdiiNcweWiittlOPkJGk3CH0GNFhX2cZlA03yG6p0epfH8jKgLBv47KegJ4iiHWPVZHdplipcV",
        // "token_type":"bearer",
        // "expires_in":"3600"
        // }
        String jsonString = callClient.POST(oAuthInfo.getAuthUrl().getAuthToken(), headers, formData);
        log.info("jsonString : {}", jsonString);

        NaverTokenResponse response = JsonUtil.getInstance().decodeFromJson(jsonString, NaverTokenResponse.class);

        log.debug("response : {}", response);

        Map<String, String> TokenInfoHeaders = Map.of("Authorization", "Bearer " + response.getAccessToken());

        // 접근 토큰 허용 프로필 권한 확인
        // info	boolean	N	false	true일 경우 권한 설정정보 응답
        boolean info = true;
        String TokenInfoString = callClient.GET(oAuthInfo.getAuthUrl().getAccessTokenInfo() + "?info=" + info,TokenInfoHeaders);

        log.debug("TokenInfoString : {}", TokenInfoString);

        Map<String,Object> tokenInfo = JsonUtil.getInstance().decodeFromJson(TokenInfoString, Map.class);

        log.debug("tokenInfo : {}", tokenInfo);

        return response;
    }

    @Override
    public OAuth2UserResponse getUserInfo(String accessToken) {

        Map<String, String> TokenInfoHeaders = Map.of("Authorization", "Bearer " + accessToken);

        //{
        //  "resultcode":"00",
        //  "message":"success",
        //  "response":{
        //    "id":"Iq15quPmsXc-JAbG5VYZNtJ6-ccvkjrUyLkBi-vms6E",
        //    "nickname":"dk123",
        //    "profile_image":"https://ssl.pstatic.net/static/pwe/address/img_profile.png",
        //    "age":"20-29",
        //    "gender":"M",
        //    "email":"679748@naver.com",
        //    "mobile":"010-7728-0056",
        //    "mobile_e164":"+821077280056",
        //    "name":"이대호",
        //    "birthday":"10-31",
        //    "birthyear":"1998"
        //  }
        //}
        String userInfoJsonString = callClient.GET(oAuthInfo.getApiUrl().getUserInfo(),TokenInfoHeaders);
        log.info("userInfoJsonString : {}", userInfoJsonString);

        NaverUserResponse userInfo = JsonUtil.getInstance().decodeFromJson(userInfoJsonString, NaverUserResponse.class);

        log.debug("userInfo : {}", userInfo);

        return userInfo;
    }
}

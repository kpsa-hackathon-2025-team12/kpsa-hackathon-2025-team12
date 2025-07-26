package com.hack.kpsahack12.model.naver;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2TokenResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class NaverTokenResponse implements OAuth2TokenResponse {
    @JsonProperty("access_token")
    private String accessToken;

    @Override
    public String getAccessToken() {
        return accessToken;
    }

    @Override
    public String getRefreshToken() {

        return "";
    }

    @Override
    public long getExpiresIn() {

        return 0;
    }
}

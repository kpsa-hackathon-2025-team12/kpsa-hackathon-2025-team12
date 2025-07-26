package com.hack.kpsahack12.model.kakao;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.hack.kpsahack12.oauth2.Interface.OAuht2.OAuth2TokenResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class KaKaoTokenResponse implements OAuth2TokenResponse {
    @JsonProperty("access_token")
    private String accessToken;

    @JsonProperty("refresh_token")
    private String refreshToken;

    @JsonProperty("expires_in")
    private long expiresIn;

    @Override
    public String getAccessToken() {
        return accessToken;
    }

    @Override
    public String getRefreshToken() {
        return refreshToken;
    }

    @Override
    public long getExpiresIn() {
        return expiresIn;
    }
}
